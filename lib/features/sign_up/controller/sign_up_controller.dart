import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:beehive/common/data/di/repository_module.dart';
import 'package:beehive/common/entities/error/api_error_response.dart';
import 'package:beehive/common/routes/routes.dart';
import 'package:beehive/common/utils/constants.dart';
import 'package:beehive/common/utils/logger.dart';
import 'package:beehive/common/widgets/popup_messages.dart';
import 'package:beehive/features/application/provider/application_nav_notifier.dart';
import 'package:beehive/features/home/controller/home_controller.dart';
import 'package:beehive/features/sign_up/notifiers/step_notifier.dart';
import 'package:beehive/features/sign_up/provider/register_notifier.dart';
import 'package:beehive/features/sign_up/provider/update_user_info_notifier.dart';
import 'package:beehive/global.dart';
import 'package:beehive/common/entities/auth/registrationRequest/registration_request.dart';

class SignUpController {
  final WidgetRef ref;

  SignUpController({
    required this.ref,
  });

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>['openid'],
  );

  Future<void> handleSignUp(String type) async {
    if (type == "email") {
      await _handleEmailSignUp();
    } else if (type == "google") {
      await _handleGoogleSignUp();
    } else if (type == "facebook") {
      await _handleFacebookSignUp();
    } else if (type == "apple") {
      await _handleAppleSignUp();
    } else {
      toastInfo('Invalid sign-up type');
    }
  }

  Future<void> _handleEmailSignUp() async {
    final notifier = ref.read(signUpNotifierProvier.notifier);
    notifier.onUserAuthTypeChange("email");
    var state = ref.watch(signUpNotifierProvier);
    asyncPostAllData(state);
  }

  Future<void> _handleGoogleSignUp() async {
    try {
      var user = await _googleSignIn.signIn();
      if (user != null) {
        _updateUserData(
          displayName: user.displayName ?? '',
          email: user.email,
          id: user.id,
          photoUrl: user.photoUrl,
          authType: "google",
        );
        asyncPostAllData(ref.watch(signUpNotifierProvier));
      } else {
        toastInfo('Google sign-up cancelled or failed');
      }
    } catch (error) {
      if (kDebugMode) {
        print("Google SignUp Error: ${error.toString()}");
      }
      toastInfo("Sign-up error during Google sign-up");
    }
  }

  Future<void> _handleFacebookSignUp() async {
    try {
      final loginResult = await FacebookAuth.instance.login();
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);
      final user = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);
      if (user.user != null) {
        _updateUserData(
          displayName: user.user?.displayName ?? '',
          email: user.user?.email ?? '',
          id: user.user?.uid ?? '',
          photoUrl: user.user?.photoURL,
          authType: "facebook",
        );
        asyncPostAllData(ref.watch(signUpNotifierProvier));
      } else {
        toastInfo('Facebook sign-up error');
      }
    } catch (error) {
      if (kDebugMode) {
        print("Facebook SignUp Error: ${error.toString()}");
      }
      toastInfo("Sign-up error during Facebook sign-up");
    }
  }

  Future<void> _handleAppleSignUp() async {
    try {
      final appleProvider = AppleAuthProvider();
      final user =
          await FirebaseAuth.instance.signInWithProvider(appleProvider);
      if (user.user != null) {
        _updateUserData(
          displayName: user.user?.displayName ?? 'Apple User',
          email: user.user?.email ?? 'apple@email.com',
          id: user.user?.uid ?? '',
          photoUrl: user.user?.photoURL,
          authType: "apple",
        );
        asyncPostAllData(ref.watch(signUpNotifierProvier));
      } else {
        toastInfo('Apple sign-up error');
      }
    } catch (error) {
      if (kDebugMode) {
        print("Apple SignUp Error: ${error.toString()}");
      }
      toastInfo("Sign-up error during Apple sign-up");
    }
  }

  void _updateUserData({
    required String displayName,
    required String email,
    required String id,
    String? photoUrl,
    required String authType,
  }) {
    final List<String> nameParts = displayName.split(' ');
    final String firstname = nameParts.isNotEmpty ? nameParts.first : '';
    final String lastname =
        nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    final notifier = ref.read(signUpNotifierProvier.notifier);
    notifier.onUserEmailChange(email);
    notifier.onfirstNameChange(firstname);
    notifier.onlastNameChange(lastname);
    notifier.onUserAvatarChange(photoUrl ??
        "https://res.cloudinary.com/dtqimnssm/image/upload/v1730063749/images/media-1730063756706.jpg");
    notifier.onUserOpenIdChange(id);
    notifier.onUserAuthTypeChange(authType);
  }

  Future<void> asyncPostAllData(RegistrationRequest registerRequest) async {
    EasyLoading.show(
        indicator: const CircularProgressIndicator(),
        maskType: EasyLoadingMaskType.clear,
        dismissOnTap: true);

    final authRepository = ref.read(authRepositoryProvider);
    var result = await authRepository.register(registerRequest);

    // Utiliser fold pour gérer les deux cas (erreur et succès)
    result.fold(
        // Cas d'erreur (Left)
        (error) {
      EasyLoading.dismiss();
      _handleRegistrationError(error);
    },
        // Cas de succès (Right)
        (success) {
      if (success.code == 201) {
        print(success.user);
        Global.storageService.setString(
            AppConstants.STORAGE_USER_PROFILE_KEY, jsonEncode(success.user));
        Global.storageService.setString(
            AppConstants.STORAGE_USER_TOKEN_KEY, jsonEncode(success.tokens));

        ref.read(isLoggedInProvider.notifier).setValue(true);

        if (registerRequest.authType == "email") {
          ref.read(registrationCurrentStepProvider.notifier).setCurrentStep(1);
        } else {
          ref.read(registrationCurrentStepProvider.notifier).setCurrentStep(2);
        }
      } else {
        // Ce cas ne devrait normalement pas se produire car un code non-201 devrait être une erreur
        EasyLoading.dismiss();
        toastInfo('Registration failed. Please check your details.');
        Logger.write(
            "Unexpected result in asyncPostAllData: ${success.message}");
      }
      EasyLoading.dismiss();
    });
  }

  void _handleRegistrationError(ApiErrorResponse error) {
    // Log l'erreur complète pour le débogage
    Logger.write("Error in registration: ${error.message}, Code: ${error.code}");
    if (error.details != null && error.details!.isNotEmpty) {
      Logger.write("Error details: ${error.details}");
    }

    // Vérifier les détails d'erreur pour afficher les messages exacts du backend
    if (error.details != null && error.details!.isNotEmpty) {
      // Afficher le premier message d'erreur détaillé
      final detail = error.details!.first;
      final String fieldMessage = detail.message ?? '';
      
      // Afficher directement le message d'erreur du backend
      toastInfo(fieldMessage);
      return;
    }

    // Si pas de détails spécifiques, afficher le message général
    if (error.message != null && error.message!.isNotEmpty) {
      toastInfo(error.message!);
    } else {
      // Message par défaut si aucun message n'est fourni
      toastInfo('Erreur lors de l\'inscription. Veuillez réessayer.');
    }
  }

  Future<void> updateUserInfo() async {
    EasyLoading.show(
        indicator: const CircularProgressIndicator(),
        maskType: EasyLoadingMaskType.clear,
        dismissOnTap: true);
    try {
      final state = ref.watch(updateUserInfoNotifierProvier);
      final authRepository = ref.read(authRepositoryProvider);
      final userInfo = ref.watch(homeUserProfileProvider);
      final userId = userInfo.asData?.value.id;
      
      if (userId != null) {
        final response = await authRepository.updateUserInfo(userId, state);
        Global.storageService.setString(
          AppConstants.STORAGE_USER_PROFILE_KEY,
          jsonEncode(response),
        );
        ref.read(registrationCurrentStepProvider.notifier).setCurrentStep(0);
        Global.navigatorKey.currentState
            ?.pushNamedAndRemoveUntil(AppRoutes.APPLICATION, (route) => false);
      } else {
        toastInfo("Erreur: ID utilisateur non trouvé");
        Logger.write("Error in updateUserInfo: User ID is null");
        ref.read(registrationCurrentStepProvider.notifier).setCurrentStep(0);
        Global.navigatorKey.currentState
            ?.pushNamedAndRemoveUntil(AppRoutes.APPLICATION, (route) => false);
      }
    } catch (e) {
      EasyLoading.dismiss();
      
      // Extraire le message d'erreur si possible
      String errorMessage = 'Erreur lors de la mise à jour du profil';
      
      // Essayer d'extraire un message plus spécifique de l'exception
      if (e.toString().contains('message')) {
        try {
          // Tenter d'extraire un message d'erreur plus spécifique
          final errorString = e.toString();
          if (errorString.contains('L\'email est déjà utilisé')) {
            errorMessage = 'L\'email est déjà utilisé';
          } else if (errorString.contains('mot de passe')) {
            errorMessage = 'Le format du mot de passe est incorrect';
          }
        } catch (_) {
          // En cas d'échec de l'extraction, utiliser le message par défaut
        }
      }
      
      toastInfo(errorMessage);
      Logger.write("Error in updateUserInfo: $e");
    } finally {
      EasyLoading.dismiss();
    }
  }
}

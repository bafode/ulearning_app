import 'dart:convert';
import 'dart:io';
import 'package:beehive/common/routes/routes.dart';
import 'package:beehive/features/sign_up/notifiers/step_notifier.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:beehive/common/data/di/repository_module.dart';
import 'package:beehive/common/entities/auth/loginRequest/login_request.dart';
import 'package:beehive/common/entities/error/api_error_response.dart';
import 'package:beehive/common/utils/constants.dart';
import 'package:beehive/common/utils/logger.dart';
import 'package:beehive/common/widgets/popup_messages.dart';
import 'package:beehive/features/application/provider/application_nav_notifier.dart';
import 'package:beehive/global.dart';
import 'package:beehive/features/sign_in/provider/sign_in_notifier.dart';

class SignInController {
  final WidgetRef ref;
  SignInController({required this.ref});

  init() {}

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'openid',
    ],
  );
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  Future<UserCredential> signInWithApple() async {
    // Ensure we can check for availability
    final isAvailable = await SignInWithApple.isAvailable();
    if (!isAvailable) {
      throw Exception("Sign in with Apple is not available on this device");
    }

    Logger.write("Starting Apple Sign In with direct package");
    
    // Request credential from Apple
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    
    Logger.write("Apple credential received: ${appleCredential.toString()}");
    Logger.write("Email from Apple: ${appleCredential.email}");
    Logger.write("User identifier: ${appleCredential.userIdentifier}");
    Logger.write("Name: ${appleCredential.givenName} ${appleCredential.familyName}");
    
    // Create OAuthCredential for Firebase
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );
    
    // Sign in to Firebase with the Apple OAuth credential
    return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  }

  Future<void> handleSignIn(String type) async {
    try {
      switch (type) {
        case "email":
          _handleEmailSignIn();
          break;
        case "google":
          await _handleGoogleSignIn();
          break;
        case "facebook":
          await _handleFacbookSignIn();
          break;
        case "apple":
          await _handleAppleSignIn();
          break;
        default:
          toastInfo('Invalid sign-in type');
      }
    } catch (error, stackTrace) {
      toastInfo('An unexpected error occurred during login');
      Logger.write("SignIn Error: $error\nStackTrace: $stackTrace");
    }
  }

  void _handleEmailSignIn() {
    final notifier = ref.read(signInNotifierProvier.notifier);
    notifier.onUserAuthTypeChange("email");
    var state = ref.watch(signInNotifierProvier);
    FocusManager.instance.primaryFocus?.unfocus();
    try {
      if(state.email!.isEmpty || state.password!.isEmpty) {
        toastInfo("Remplissez tous les champs");
        return;
      }
      asyncPostAllData(state);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      toastInfo("login error");
    }
  }

  Future<void> _handleGoogleSignIn() async {
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
        asyncPostAllData(ref.watch(signInNotifierProvier));
      } else {
        toastInfo('Google login cancelled or failed');
      }
    } catch (error) {
      if (kDebugMode) {
        print("Google SignIn Error: ${error.toString()}");
      }
      toastInfo("Login error during Google sign-in");
    }
  }

  Future<void> _handleFacbookSignIn() async {
    try {
      Logger.write("facebook");
      var user = await signInWithFacebook();
      Logger.write("${user.user}");
      if (user.user != null) {
        _updateUserData(
          displayName: user.user?.displayName ?? '',
          email: user.user?.email ?? '',
          id: user.user?.uid ?? '',
          photoUrl: user.user?.photoURL,
          authType: "facebook",
        );
        asyncPostAllData(ref.watch(signInNotifierProvier));
      } else {
        toastInfo('facebook login error');
      }
    } catch (error) {
      if (kDebugMode) {
        print("Facebook SignIn Error: ${error.toString()}");
      }
      toastInfo("Login error during facebook sign-in");
    }
  }

  Future<void> _handleAppleSignIn() async {
    try {
      Logger.write("Starting Apple Sign In process");
      
      // First, get the Apple credential directly
      final isAvailable = await SignInWithApple.isAvailable();
      if (!isAvailable) {
        toastInfo("Sign in with Apple n'est pas disponible sur cet appareil");
        return;
      }
      
      // Get the Apple ID credential
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      
      // Log all the information we get from Apple
      Logger.write("Apple credential received");
      Logger.write("Email from Apple: ${appleCredential.email}");
      Logger.write("User identifier: ${appleCredential.userIdentifier}");
      Logger.write("Given name: ${appleCredential.givenName}");
      Logger.write("Family name: ${appleCredential.familyName}");
      
      // Create OAuthCredential for Firebase
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );
      
      // Sign in to Firebase with the Apple OAuth credential
      final user = await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      
      if (user.user != null) {
        // Get email from Apple credential first, then fallback to Firebase
        String? email = appleCredential.email;
        
        // If email is null from Apple credential, try to get it from Firebase
        if (email == null || email.isEmpty) {
          email = user.user?.email;
          
          // If still null, try to get it from stored user data if this is a returning user
          if ((email == null || email.isEmpty) && user.additionalUserInfo?.isNewUser == false) {
            try {
              await user.user?.reload();
              User? refreshedUser = FirebaseAuth.instance.currentUser;
              email = refreshedUser?.email;
              Logger.write("Retrieved email for returning Apple user: $email");
            } catch (e) {
              Logger.write("Error refreshing user data: $e");
            }
          }
        }
        
        // If email is still null, try to get it from our secure storage
        if (email == null || email.isEmpty) {
          final appleUserId = appleCredential.userIdentifier;
          if (appleUserId != null) {
            final storedEmail = Global.storageService.getString(
                "${AppConstants.STORAGE_APPLE_EMAIL_PREFIX}$appleUserId");
            if (storedEmail.isNotEmpty) {
              email = storedEmail;
              Logger.write("Retrieved stored email for Apple user ID: $email");
            }
          }
        }
        
        // Store the email in secure storage for future use if we have it
        if (email != null && email.isNotEmpty) {
          // We have the email, store it for future use with this Apple ID
          final appleUserId = appleCredential.userIdentifier;
          if (appleUserId != null) {
            // Store the mapping between Apple user ID and email
            Global.storageService.setString(
                "${AppConstants.STORAGE_APPLE_EMAIL_PREFIX}$appleUserId", email);
            Logger.write("Stored email $email for Apple user ID $appleUserId");
          }
        } else {
          // If we still don't have an email, show an error
          Logger.write("Apple Sign In did not provide an email address");
          toastInfo('Apple ne nous a pas fourni votre email. Veuillez utiliser une autre méthode de connexion ou contacter le support.');
          await FirebaseAuth.instance.signOut();
          return;
        }
        
        // Construct display name from Apple credential if available
        String displayName = 'Apple User';
        if (appleCredential.givenName != null || appleCredential.familyName != null) {
          displayName = [appleCredential.givenName, appleCredential.familyName]
              .where((name) => name != null && name.isNotEmpty)
              .join(' ');
        }
        
        if (displayName.isEmpty) {
          displayName = user.user?.displayName ?? 'Apple User';
        }
        
        _updateUserData(
          displayName: displayName,
          email: email,
          id: user.user?.uid ?? '',
          photoUrl: user.user?.photoURL,
          authType: "apple",
        );
        
        asyncPostAllData(ref.watch(signInNotifierProvier));
      } else {
        toastInfo('Erreur lors de la connexion avec Apple');
      }
    } catch (error) {
      if (kDebugMode) {
        print("Apple SignIn Error: ${error.toString()}");
      }
      toastInfo("Erreur lors de la connexion avec Apple");
      Logger.write("Detailed Apple SignIn Error: $error");
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
    final String firstName = nameParts.isNotEmpty ? nameParts.first : '';
    final String lastName =
        nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    final notifier = ref.read(signInNotifierProvier.notifier);
    notifier.onUserEmailChange(email);
    notifier.onUserFirstNameChange(firstName);
    notifier.onUserLastNameChange(lastName);
    notifier.onUserAvatarChange(photoUrl ?? "https://res.cloudinary.com/dtqimnssm/image/upload/v1730063749/images/media-1730063756706.jpg");
    notifier.onUserOpenIdChange(id);
    notifier.onUserAuthTypeChange(authType);
  }

  Future<void> asyncPostAllData(LoginRequest loginRequest) async {
    EasyLoading.show(
        indicator: const CircularProgressIndicator(),
        maskType: EasyLoadingMaskType.clear,
        dismissOnTap: true);
    //we need to talk to server
    final authRepository = ref.read(authRepositoryProvider);
    var result = await authRepository.login(loginRequest);
    result.fold(
      // Cas d'erreur (Left)
      (error) {
        EasyLoading.dismiss();
        _handleLoginError(error);
      },
      // Cas de succès (Right)
      (success) {
        if (success.code == 200) {
          print(success.user);
          Global.storageService.setString(
              AppConstants.STORAGE_USER_PROFILE_KEY, jsonEncode(success.user));
          Global.storageService.setString(
              AppConstants.STORAGE_USER_TOKEN_KEY, jsonEncode(success.tokens));
          
          ref.read(isLoggedInProvider.notifier).setValue(true);
          final notifier = ref.read(signInNotifierProvier.notifier);
          notifier.onUserEmailChange("");
          notifier.onUserPasswordChange("");
          EasyLoading.dismiss();
          if(success.code==201){
            ref.read(registrationCurrentStepProvider.notifier).setCurrentStep(2);
            Global.navigatorKey.currentState
                ?.pushNamedAndRemoveUntil(AppRoutes.SIGN_UP, (route) => false);
          }else{
            Global.navigatorKey.currentState
                ?.pushNamedAndRemoveUntil("/application", (route) => false);
          }

        } else {
          // Ce cas ne devrait normalement pas se produire car un code non-200 devrait être une erreur
          EasyLoading.dismiss();
          toastInfo('Connexion échouée. Veuillez vérifier vos informations.');
          Logger.write("Unexpected result in asyncPostAllData: ${success.message}");
        }
        EasyLoading.dismiss();
      }
    );
  }
  
  void _handleLoginError(ApiErrorResponse error) {
    // Log l'erreur complète pour le débogage
    Logger.write("Error in login: ${error.message}, Code: ${error.code}");
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

    // Vérifier le code d'erreur pour des cas spécifiques
    if (error.code == 401) {
      toastInfo('Email ou mot de passe incorrect');
      return;
    }

    // Vérifier le message d'erreur pour des cas spécifiques
    final errorMsg = error.message?.toLowerCase() ?? '';
    if (errorMsg.contains('email') && errorMsg.contains('password')) {
      toastInfo('Email ou mot de passe incorrect');
    } else if (errorMsg.contains('network') || errorMsg.contains('connection')) {
      toastInfo('Erreur de réseau. Veuillez vérifier votre connexion internet et réessayer.');
    } else if (errorMsg.contains('unauthorized') || errorMsg.contains('permission')) {
      toastInfo('Accès non autorisé. Veuillez vous reconnecter.');
    } else {
      // Message d'erreur générique si aucun cas spécifique n'est identifié
      toastInfo(error.message ?? 'Erreur lors de la connexion. Veuillez réessayer.');
    }
  }
}

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:beehive/common/data/di/repository_module.dart';
import 'package:beehive/common/entities/auth/loginRequest/login_request.dart';
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
    final appleProvider = AppleAuthProvider();
    return await FirebaseAuth.instance.signInWithProvider(appleProvider);
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
      Logger.write("apple");
      var user = await signInWithApple();
      Logger.write("${user.user}");
      if (user.user != null) {
        _updateUserData(
          displayName: user.user?.displayName ??
              'Apple User', // Ou une autre valeur par défaut
          email: user.user?.email ??
              'apple@email.com', // Par défaut ou de sauvegarde
          id: user.user?.uid ?? '',
          photoUrl: user.user?.photoURL,
          authType: "apple",
        );
        asyncPostAllData(ref.watch(signInNotifierProvier));
      } else {
        toastInfo('Apple login error');
      }
    } catch (error) {
      if (kDebugMode) {
        print("Apple SignIn Error: ${error.toString()}");
      }
      toastInfo("Login error during apple sign-in");
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
    notifier.onUserAvatarChange(photoUrl ?? "default.png");
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
    try {
    var result = await authRepository.login(loginRequest);
      if (result.code == 200) {
        //have local storage
        //try to remember user info
        Global.storageService.setString(
            AppConstants.STORAGE_USER_PROFILE_KEY, jsonEncode(result.user));
        Global.storageService.setString(
            AppConstants.STORAGE_USER_TOKEN_KEY, jsonEncode(result.tokens));
        ref.read(isLoggedInProvider.notifier).setValue(true);
        EasyLoading.dismiss();
        Global.navigatorKey.currentState
            ?.pushNamedAndRemoveUntil("/application", (route) => false);
        //redirect to new page
      } else {
         EasyLoading.dismiss();
        toastInfo('invalid credentials');
      }
    } catch (e) {
      EasyLoading.dismiss();
      toastInfo('invalid credentials or internet error');
      Logger.write("$e");
    }
  }
}

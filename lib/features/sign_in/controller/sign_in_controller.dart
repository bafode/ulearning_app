import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ulearning_app/common/data/di/repository_module.dart';
import 'package:ulearning_app/common/entities/auth/loginRequest/login_request.dart';
import 'package:ulearning_app/common/global_loader/global_loader.dart';
import 'package:ulearning_app/common/utils/constants.dart';
import 'package:ulearning_app/common/widgets/popup_messages.dart';
import 'package:ulearning_app/features/application/provider/application_nav_notifier.dart';
import 'package:ulearning_app/global.dart';
import 'package:ulearning_app/features/sign_in/provider/sign_in_notifier.dart';
import 'package:ulearning_app/main.dart';

class SignInController {
  SignInController();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> handleSignIn(WidgetRef ref) async {
    var state = ref.watch(signInNotifierProvier);
    String email = state.email ?? "";
    String password = state.password ?? "";

    emailController.text = email;
    passwordController.text = password;

    if (email.isEmpty) {
      toastInfo("Your email is empty");
      return;
    }
    if (password.isEmpty) {
      toastInfo("Your password is empty");
      return;
    }

    try {
      asyncPostAllData(state, ref);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      toastInfo("login error");
    }
  }

  Future<void> asyncPostAllData(
      LoginRequest loginRequest, WidgetRef ref) async {
    ref.read(appLoaderProvider.notifier).setLoaderValue(true);
    //we need to talk to server
    final authRepository = ref.read(authRepositoryProvider);
    var result = await authRepository.login(loginRequest);
    if (result.code == 200) {
      //have local storage
      try {
        //try to remember user info
        Global.storageService.setString(
            AppConstants.STORAGE_USER_PROFILE_KEY, jsonEncode(result.user));
        Global.storageService.setString(
            AppConstants.STORAGE_USER_TOKEN_KEY, jsonEncode(result.tokens));
        ref.read(isLoggedInProvider.notifier).setValue(true);
        navKey.currentState
            ?.pushNamedAndRemoveUntil("/application", (route) => false);
      } catch (e) {
        if (kDebugMode) {
          print(e.toString());
        }
      }
      //redirect to new page
    } else {
      ref.read(appLoaderProvider.notifier).setLoaderValue(false);
      toastInfo("Login error");
    }
    ref.read(appLoaderProvider.notifier).setLoaderValue(false);
  }
}

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ulearning_app/common/data/di/repository_module.dart';
import 'package:ulearning_app/common/data/repository/auth_repository.dart';
import 'package:ulearning_app/common/entities/auth/loginRequest/login_request.dart';
import 'package:ulearning_app/common/global_loader/global_loader.dart';
import 'package:ulearning_app/common/utils/constants.dart';
import 'package:ulearning_app/common/view_model/base_view_model.dart';
import 'package:ulearning_app/common/widgets/popup_messages.dart';
import 'package:ulearning_app/global.dart';
import 'package:ulearning_app/main.dart';

final authViewModelProvider =
    Provider((ref) => AuthViewModel(ref, ref.read(authRepositoryProvider)));

class AuthViewModel extends BaseViewModel {
  final AuthRepository _authRepository;
  AuthViewModel(ProviderRef ref, this._authRepository) : super(ref);

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> handleSignIn(WidgetRef ref) async {
    var state = ref.watch(signInNotifierProvier);
    String? email = state.email;
    String? password = state.password;

    emailController.text = email ?? "";
    passwordController.text = password ?? "";

    if (state.email!.isEmpty || email!.isEmpty) {
      toastInfo("Your email is empty");
      return;
    }
    if (state.password!.isEmpty || password!.isEmpty) {
      toastInfo("Your password is empty");
      return;
    }
    ref.read(appLoaderProvider.notifier).setLoaderValue(true);

    try {
      LoginRequest loginRequest = const LoginRequest();
      loginRequest.copyWith(email: email);
      loginRequest.copyWith(password: password);
      asyncPostAllData(loginRequest);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      toastInfo("login error");
    }

    ref.read(appLoaderProvider.notifier).setLoaderValue(false);
  }

  Future<void> asyncPostAllData(LoginRequest params) async {
    //we need to talk to server
    var result = await _authRepository.login(params);
    if (result?.code == 200) {
      //have local storage
      try {
        //try to remember user info
        Global.storageService.setString(
            AppConstants.STORAGE_USER_PROFILE_KEY, jsonEncode(result!.user));
        Global.storageService.setString(
            AppConstants.STORAGE_USER_TOKEN_KEY, jsonEncode(result.tokens));

        // navKey.currentState
        //     ?.pushNamedAndRemoveUntil("/application", (route) => false);
      } catch (e) {
        if (kDebugMode) {
          print(e.toString());
        }
      }

      //redirect to new page
    } else {
      toastInfo("Login error");
    }
  }
}

final signInNotifierProvier =
    StateNotifierProvider<SignInNotifier, LoginRequest>(
        (ref) => SignInNotifier());

class SignInNotifier extends StateNotifier<LoginRequest> {
  SignInNotifier() : super(const LoginRequest());

  void onUserEmailChange(String email) {
    state = state.copyWith(email: email);
  }

  void onUserPasswordChange(String password) {
    state = state.copyWith(password: password);
  }
}

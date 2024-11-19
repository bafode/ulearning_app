import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ulearning_app/common/entities/auth/loginRequest/login_request.dart';

class SignInNotifier extends StateNotifier<LoginRequest> {
  SignInNotifier() : super(const LoginRequest());

  void onUserEmailChange(String email) {
    state = state.copyWith(email: email);
     if (kDebugMode) {
      print(state.password);
      print(state.email);
      print(state.type);
    }
  }

  void onUserPasswordChange(String password) {
    state = state.copyWith(password: password);
    if (kDebugMode) {
      print(state.password);
      print(state.email);
      print(state.type);
    }
  }

  void onUserFirstNameChange(String firstName) {
    state = state.copyWith(firstName: firstName);
  }

  void onUserLastNameChange(String lastName) {
    state = state.copyWith(lastName: lastName);
  }

  void onUserAvatarChange(String avatar) {
    state = state.copyWith(avatar: avatar);
  }

  void onUserOpenIdChange(String openId) {
    state = state.copyWith(open_id: openId);
  }

  void onUserTypeChange(int type) {
    state = state.copyWith(type: type);
   if (kDebugMode) {
      print(state.password);
      print(state.email);
      print(state.type);
    }
  }
}

final signInNotifierProvier =
    StateNotifierProvider<SignInNotifier, LoginRequest>(
        (ref) => SignInNotifier());

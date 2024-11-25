import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ulearning_app/common/entities/auth/loginRequest/login_request.dart';

class SignInNotifier extends StateNotifier<LoginRequest> {
  SignInNotifier() : super(const LoginRequest());

  void onUserEmailChange(String email) {
    state = state.copyWith(email: email);
  }

  void onUserPasswordChange(String password) {
    state = state.copyWith(password: password);
  }

  void onUserFirstNameChange(String firstName) {
    state = state.copyWith(firstname: firstName);
  }

  void onUserLastNameChange(String lastName) {
    state = state.copyWith(lastname: lastName);
  }

  void onUserAvatarChange(String avatar) {
    state = state.copyWith(avatar: avatar);
  }

  void onUserOpenIdChange(String openId) {
    state = state.copyWith(open_id: openId);
  }

  void onUserAuthTypeChange(String authType) {
    state = state.copyWith(authType: authType);
  }
}

final signInNotifierProvier =
    StateNotifierProvider<SignInNotifier, LoginRequest>(
        (ref) => SignInNotifier());

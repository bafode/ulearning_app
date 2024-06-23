import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ulearning_app/common/entities/auth/loginRequest/login_request.dart';

class SignInNotifier extends StateNotifier<LoginRequest> {
  SignInNotifier() : super(const LoginRequest());

  void onUserEmailChange(String email) {
    state = state.copyWith(email: email);
    print(state.email);
    print(state.password);
  }

  void onUserPasswordChange(String password) {
    state = state.copyWith(password: password);
    print(state.email);
    print(state.password);
  }
}

final signInNotifierProvier =
    StateNotifierProvider<SignInNotifier, LoginRequest>(
        (ref) => SignInNotifier());

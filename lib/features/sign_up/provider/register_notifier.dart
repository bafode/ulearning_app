import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ulearning_app/common/entities/auth/registrationRequest/registration_request.dart';

class SignUpNotifier extends StateNotifier<RegistrationRequest> {
  SignUpNotifier() : super(RegistrationRequest());

  void onfirstNameChange(String firstname) {
    state = state.copyWith(firstname: firstname);
    print(state.firstname);
    print(state.lastname);
    print(state.email);
    print(state.password);
    print(state.rePassword);
  }

  void onlastNameChange(String lastname) {
    state = state.copyWith(lastname: lastname);
    print(state.firstname);
    print(state.lastname);
    print(state.email);
    print(state.password);
    print(state.rePassword);
  }

  void onUserEmailChange(String email) {
    state = state.copyWith(email: email);
  }

  void onUserPasswordChange(String password) {
    state = state.copyWith(password: password);
  }

  void onUserRePasswordChange(String rePassword) {
    state = state.copyWith(rePassword: rePassword);
  }
}

final signUpNotifierProvier =
    StateNotifierProvider<SignUpNotifier, RegistrationRequest>(
        (ref) => SignUpNotifier());

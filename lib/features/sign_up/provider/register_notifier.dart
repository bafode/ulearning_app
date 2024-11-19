import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ulearning_app/common/entities/auth/registrationRequest/registration_request.dart';

class SignUpNotifier extends StateNotifier<RegistrationRequest> {
  SignUpNotifier() : super(RegistrationRequest());

  void onfirstNameChange(String firstname) {
    state = state.copyWith(firstName: firstname);
  }

  void onlastNameChange(String lastname) {
    state = state.copyWith(lastName: lastname);
  }

  void onUserEmailChange(String email) {
    state = state.copyWith(email: email.trim());
  }

  void onUserPasswordChange(String password) {
    state = state.copyWith(password: password);
  }

  void onUserRePasswordChange(String rePassword) {
    state = state.copyWith(rePassword: rePassword);
  }

  void onUserAvatarChange(String avatar) {
    state = state.copyWith(avatar: avatar);
  }

  void onUserOpenIdChange(String openId) {
    state = state.copyWith(open_id: openId);
  }

  void onUserTypeChange(int type) {
    state = state.copyWith(type: type);
  }
}

final signUpNotifierProvier =
    StateNotifierProvider<SignUpNotifier, RegistrationRequest>(
        (ref) => SignUpNotifier());

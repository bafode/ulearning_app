import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beehive/common/entities/auth/registrationRequest/registration_request.dart';

class SignUpNotifier extends StateNotifier<RegistrationRequest> {
  SignUpNotifier()
      : super(RegistrationRequest(
            passwordVisibility: true, 
            rePasswordVisibility: true,
            isFirstnameValid: false,
            isLastnameValid: false,
            isEmailValid: false,
            isPasswordValid: false,
            isRePasswordValid: false
            ));

  void onfirstNameChange(String firstname) {
    state = state.copyWith(firstname: firstname);
  }

  void onlastNameChange(String lastname) {
    state = state.copyWith(lastname: lastname);
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

  void onUserAuthTypeChange(String authType) {
    state = state.copyWith(authType: authType);
  }

  void onPasswordVisibilityChange(bool visibility) {
    state = state.copyWith(passwordVisibility: visibility);
  }

  void onRePasswordVisibilityChange(bool visibility) {
    state = state.copyWith(rePasswordVisibility: visibility);
  }

  void setFirstNameValidity(bool valid) {
    state = state.copyWith(isFirstnameValid: valid);
  }

  void setLastNameValidity(bool valid) {
    state = state.copyWith(isLastnameValid: valid);
  }

  void setEmailValidity(bool valid) {
    state = state.copyWith(isEmailValid: valid);
  }

  void setPasswordValidity(bool valid) {
    state = state.copyWith(isPasswordValid: valid);
  }

  void setRePasswordValidity(bool valid) {
    state = state.copyWith(isRePasswordValid: valid);
  }
}

final signUpNotifierProvier =
    StateNotifierProvider<SignUpNotifier, RegistrationRequest>(
        (ref) => SignUpNotifier());

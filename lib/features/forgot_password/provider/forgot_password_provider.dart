import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ulearning_app/common/entities/auth/forgotPasswordRequest/forgot_password_request.dart';

final sendEmailButtonEnabledProvider = StateProvider<bool>((ref) => false);

class ForgotPasswordNotifier extends StateNotifier<ForgotPasswordRequest> {
  ForgotPasswordNotifier() : super(const ForgotPasswordRequest());

  void onEmailChange(String email) {
    state = state.copyWith(email: email.trim());
  }
}

final forgotPasswordProvider =
    StateNotifierProvider<ForgotPasswordNotifier, ForgotPasswordRequest>(
        (ref) => ForgotPasswordNotifier());

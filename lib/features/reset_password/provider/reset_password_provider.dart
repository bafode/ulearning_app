import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beehive/common/entities/auth/resetPasswordRequest/reset_password_request.dart';

final resetPasswordButtonEnabledProvider = StateProvider<bool>((ref) => false);

class ResetPasswordNotifier extends StateNotifier<ResetPasswordRequest> {
  ResetPasswordNotifier() : super(const ResetPasswordRequest());

  void onTokenChange(String token) {
    state = state.copyWith(token: token);
  }

  void onPasswordChange(String password) {
    state = state.copyWith(password: password);
  }
}

final resetPasswordProvider =
    StateNotifierProvider<ResetPasswordNotifier, ResetPasswordRequest>(
        (ref) => ResetPasswordNotifier());

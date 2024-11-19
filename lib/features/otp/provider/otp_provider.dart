import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ulearning_app/common/entities/auth/verifyEmailRequest/verify_email_request.dart';

class OtpNotifier extends StateNotifier<VerifyEmailRequest> {
  OtpNotifier() : super(const VerifyEmailRequest());

  void onTokenChange(String token) {
    state = state.copyWith(token: token);
    print(state);
  }
}

final emailVerificationProvier =
    StateNotifierProvider<OtpNotifier, VerifyEmailRequest>(
        (ref) => OtpNotifier());

class OtpResponseNotifier extends StateNotifier<bool> {
  OtpResponseNotifier() : super(false);

  void setResponseCode(bool response) {
    state = response;
    print("Response code: $state");
  }
}

final emailVerificationResponseProvier =
    StateNotifierProvider<OtpResponseNotifier, bool>(
        (ref) => OtpResponseNotifier());

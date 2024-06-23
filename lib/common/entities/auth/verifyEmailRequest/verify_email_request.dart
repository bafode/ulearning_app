import 'package:freezed_annotation/freezed_annotation.dart';
part 'verify_email_request.freezed.dart';
part 'verify_email_request.g.dart';

@freezed
class VerifyEmailRequest with _$VerifyEmailRequest {
  const factory VerifyEmailRequest({
    String? token,
  }) = _VerifyEmailRequest;

  factory VerifyEmailRequest.fromJson(Map<String, dynamic> json) =>
      _$VerifyEmailRequestFromJson(json);
}

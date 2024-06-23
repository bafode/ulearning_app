import 'package:freezed_annotation/freezed_annotation.dart';
part 'logout_request.freezed.dart';
part 'logout_request.g.dart';

@freezed
class LogoutRequest with _$LogoutRequest {
  const factory LogoutRequest({
    String? refreshToken,
  }) = _LogoutRequest;

  factory LogoutRequest.fromJson(Map<String, dynamic> json) =>
      _$LogoutRequestFromJson(json);
}

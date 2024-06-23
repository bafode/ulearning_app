import 'package:freezed_annotation/freezed_annotation.dart';

part 'logout_response.g.dart';
part 'logout_response.freezed.dart';

@freezed
class LogoutResponse with _$LogoutResponse {
  factory LogoutResponse({
    required int code,
    required String message,
  }) = _LogoutResponse;

  factory LogoutResponse.fromJson(Map<String, dynamic> json) =>
      _$LogoutResponseFromJson(json);
}

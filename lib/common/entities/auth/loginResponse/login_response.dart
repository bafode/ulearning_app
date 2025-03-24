import 'package:beehive/common/entities/error/api_error_detail.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:beehive/common/entities/auth/token/tokens.dart';
import 'package:beehive/common/entities/user/user.dart';
part 'login_response.freezed.dart';
part 'login_response.g.dart';

@freezed
class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    int? code,
    String? message,
    User? user,
    Tokens? tokens,
    List<ApiErrorDetail>? details,
    String? stack
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}

import 'package:beehive/common/entities/error/api_error_detail.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'api_error_response.freezed.dart';
part 'api_error_response.g.dart';

@freezed
class ApiErrorResponse with _$ApiErrorResponse {
  const factory ApiErrorResponse({
    int? code,
    String? message,
    List<ApiErrorDetail>? details,
    String? stack
  }) = _ApiErrorResponse;

  factory ApiErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorResponseFromJson(json);
}

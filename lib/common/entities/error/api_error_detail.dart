import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_error_detail.freezed.dart';
part 'api_error_detail.g.dart';

@freezed
class ApiErrorDetail with _$ApiErrorDetail {
  const factory ApiErrorDetail({
    String? field,
    String? message,
  }) = _ApiErrorDetail;

  factory ApiErrorDetail.fromJson(Map<String, dynamic> json) => _$ApiErrorDetailFromJson(json);
}

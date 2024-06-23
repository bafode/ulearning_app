import 'package:freezed_annotation/freezed_annotation.dart';

part 'registration_response.g.dart';
part 'registration_response.freezed.dart';

@freezed
class RegistrationResponse with _$RegistrationResponse {
  factory RegistrationResponse({
    required int code,
    required String message,
  }) = _RegistratiResponse;

  factory RegistrationResponse.fromJson(Map<String, dynamic> json) =>
      _$RegistrationResponseFromJson(json);
}

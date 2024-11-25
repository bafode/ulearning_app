import 'package:freezed_annotation/freezed_annotation.dart';

part 'registration_request.g.dart';
part 'registration_request.freezed.dart';

@freezed
class RegistrationRequest with _$RegistrationRequest {
  factory RegistrationRequest({
    String? firstname,
    String? lastname,
    String? email,
    String? password,
    String? authType,
    String? description,
    String? phone,
    String? avatar,
    String? open_id,
    int? online,
    @JsonKey(includeFromJson: false, includeToJson: false) String? rePassword,
  }) = _RegistrationRequest;

  factory RegistrationRequest.fromJson(Map<String, dynamic> json) =>
      _$RegistrationRequestFromJson(json);
}

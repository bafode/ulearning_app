import 'package:freezed_annotation/freezed_annotation.dart';
part 'login_request.freezed.dart';
part 'login_request.g.dart';

@freezed
class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    String? email,
    String? password,
    String? authType,
    String? firstname,
    String? lastname,
    String? description,
    String? phone,
    String? avatar,
    String? open_id,
    int? online,
    @JsonKey(includeFromJson: false, includeToJson: false)
    bool? passwordVisibility,
    @JsonKey(includeFromJson: false, includeToJson: false)
    bool? isEmailValid,
    @JsonKey(includeFromJson: false, includeToJson: false)
    bool? isPasswordValid,
  }) = _LoginRequest;

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
}

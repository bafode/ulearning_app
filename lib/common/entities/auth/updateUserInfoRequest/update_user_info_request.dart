import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_user_info_request.g.dart';
part 'update_user_info_request.freezed.dart';

@freezed
class UpdateUserInfoRequest with _$UpdateUserInfoRequest {
  factory UpdateUserInfoRequest({
    String? city,
    String? school,
    String? fieldOfStudy,
    String? levelOfStudy,
    List<String>? categories,
    @JsonKey(includeFromJson: false, includeToJson: false) String? rePassword,
  }) = _UpdateUserInfoRequest;

  factory UpdateUserInfoRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserInfoRequestFromJson(json);
}

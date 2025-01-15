import 'package:freezed_annotation/freezed_annotation.dart';
part 'edit_profil_request.freezed.dart';
part 'edit_profil_request.g.dart';

@freezed
class EditProfilRequest with _$EditProfilRequest {
  const factory EditProfilRequest({
   
    String? firstname,
    String? lastname,
    String? description,
  }) = _EditProfilRequest;

  factory EditProfilRequest.fromJson(Map<String, dynamic> json) =>
      _$EditProfilRequestFromJson(json);
}

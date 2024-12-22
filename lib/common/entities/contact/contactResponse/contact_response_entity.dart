import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_response_entity.freezed.dart';
part 'contact_response_entity.g.dart';

@freezed
class ContactResponseEntity with _$ContactResponseEntity {
  const factory ContactResponseEntity({
    required int? code,
    required String? msg,
    required List<ContactItem>? data,
  }) = _ContactResponseEntity;

  factory ContactResponseEntity.fromJson(Map<String, dynamic> json) =>
      _$ContactResponseEntityFromJson(json);
}

@freezed
class ContactItem with _$ContactItem {
  const factory ContactItem({
    required  String? token,
    required String? firstname,
    required String? lastname,
    required String? description,
    required String? avatar,
    required int? online,  
  }) = _ContactItem;

  factory ContactItem.fromJson(Map<String, dynamic> json) => _$ContactItemFromJson(json);
}

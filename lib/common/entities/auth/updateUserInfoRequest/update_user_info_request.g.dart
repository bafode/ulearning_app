// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_user_info_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UpdateUserInfoRequestImpl _$$UpdateUserInfoRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$UpdateUserInfoRequestImpl(
      city: json['city'] as String?,
      school: json['school'] as String?,
      fieldOfStudy: json['fieldOfStudy'] as String?,
      levelOfStudy: json['levelOfStudy'] as String?,
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$UpdateUserInfoRequestImplToJson(
        _$UpdateUserInfoRequestImpl instance) =>
    <String, dynamic>{
      'city': instance.city,
      'school': instance.school,
      'fieldOfStudy': instance.fieldOfStudy,
      'levelOfStudy': instance.levelOfStudy,
      'categories': instance.categories,
    };

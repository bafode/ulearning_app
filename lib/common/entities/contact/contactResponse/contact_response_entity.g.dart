// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_response_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ContactResponseEntityImpl _$$ContactResponseEntityImplFromJson(
        Map<String, dynamic> json) =>
    _$ContactResponseEntityImpl(
      code: (json['code'] as num?)?.toInt(),
      msg: json['msg'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ContactItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ContactResponseEntityImplToJson(
        _$ContactResponseEntityImpl instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data,
    };

_$ContactItemImpl _$$ContactItemImplFromJson(Map<String, dynamic> json) =>
    _$ContactItemImpl(
      token: json['token'] as String?,
      firstname: json['firstname'] as String?,
      lastname: json['lastname'] as String?,
      description: json['description'] as String?,
      avatar: json['avatar'] as String?,
      online: (json['online'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$ContactItemImplToJson(_$ContactItemImpl instance) =>
    <String, dynamic>{
      'token': instance.token,
      'firstname': instance.firstname,
      'lastname': instance.lastname,
      'description': instance.description,
      'avatar': instance.avatar,
      'online': instance.online,
    };

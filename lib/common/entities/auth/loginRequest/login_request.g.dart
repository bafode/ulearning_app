// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoginRequestImpl _$$LoginRequestImplFromJson(Map<String, dynamic> json) =>
    _$LoginRequestImpl(
      email: json['email'] as String?,
      password: json['password'] as String?,
      type: (json['type'] as num?)?.toInt(),
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      description: json['description'] as String?,
      phone: json['phone'] as String?,
      avatar: json['avatar'] as String?,
      open_id: json['open_id'] as String?,
      online: (json['online'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$LoginRequestImplToJson(_$LoginRequestImpl instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'type': instance.type,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'description': instance.description,
      'phone': instance.phone,
      'avatar': instance.avatar,
      'open_id': instance.open_id,
      'online': instance.online,
    };

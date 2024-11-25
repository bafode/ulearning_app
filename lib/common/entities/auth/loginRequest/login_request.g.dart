// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoginRequestImpl _$$LoginRequestImplFromJson(Map<String, dynamic> json) =>
    _$LoginRequestImpl(
      email: json['email'] as String?,
      password: json['password'] as String?,
      authType: json['authType'] as String?,
      firstname: json['firstname'] as String?,
      lastname: json['lastname'] as String?,
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
      'authType': instance.authType,
      'firstname': instance.firstname,
      'lastname': instance.lastname,
      'description': instance.description,
      'phone': instance.phone,
      'avatar': instance.avatar,
      'open_id': instance.open_id,
      'online': instance.online,
    };

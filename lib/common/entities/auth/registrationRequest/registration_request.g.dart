// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registration_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RegistrationRequestImpl _$$RegistrationRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$RegistrationRequestImpl(
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      type: (json['type'] as num?)?.toInt(),
      description: json['description'] as String?,
      phone: json['phone'] as String?,
      avatar: json['avatar'] as String?,
      open_id: json['open_id'] as String?,
      online: (json['online'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$RegistrationRequestImplToJson(
        _$RegistrationRequestImpl instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'password': instance.password,
      'type': instance.type,
      'description': instance.description,
      'phone': instance.phone,
      'avatar': instance.avatar,
      'open_id': instance.open_id,
      'online': instance.online,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registration_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RegistrationRequestImpl _$$RegistrationRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$RegistrationRequestImpl(
      firstname: json['firstname'] as String?,
      lastname: json['lastname'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      authType: json['authType'] as String?,
      description: json['description'] as String?,
      phone: json['phone'] as String?,
      avatar: json['avatar'] as String?,
      open_id: json['open_id'] as String?,
      online: (json['online'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$RegistrationRequestImplToJson(
        _$RegistrationRequestImpl instance) =>
    <String, dynamic>{
      'firstname': instance.firstname,
      'lastname': instance.lastname,
      'email': instance.email,
      'password': instance.password,
      'authType': instance.authType,
      'description': instance.description,
      'phone': instance.phone,
      'avatar': instance.avatar,
      'open_id': instance.open_id,
      'online': instance.online,
    };

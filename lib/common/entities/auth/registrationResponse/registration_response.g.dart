// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registration_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RegistratiResponseImpl _$$RegistratiResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$RegistratiResponseImpl(
      code: (json['code'] as num).toInt(),
      message: json['message'] as String,
    );

Map<String, dynamic> _$$RegistratiResponseImplToJson(
        _$RegistratiResponseImpl instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
    };

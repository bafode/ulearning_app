// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logout_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LogoutResponseImpl _$$LogoutResponseImplFromJson(Map<String, dynamic> json) =>
    _$LogoutResponseImpl(
      code: (json['code'] as num).toInt(),
      message: json['message'] as String,
    );

Map<String, dynamic> _$$LogoutResponseImplToJson(
        _$LogoutResponseImpl instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
    };

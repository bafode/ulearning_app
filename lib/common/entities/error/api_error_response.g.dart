// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_error_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApiErrorResponseImpl _$$ApiErrorResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$ApiErrorResponseImpl(
      code: (json['code'] as num?)?.toInt(),
      message: json['message'] as String?,
      details: (json['details'] as List<dynamic>?)
          ?.map((e) => ApiErrorDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
      stack: json['stack'] as String?,
    );

Map<String, dynamic> _$$ApiErrorResponseImplToJson(
        _$ApiErrorResponseImpl instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'details': instance.details,
      'stack': instance.stack,
    };

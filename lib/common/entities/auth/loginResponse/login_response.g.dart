// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoginResponseImpl _$$LoginResponseImplFromJson(Map<String, dynamic> json) =>
    _$LoginResponseImpl(
      code: (json['code'] as num?)?.toInt(),
      message: json['message'] as String?,
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      tokens: json['tokens'] == null
          ? null
          : Tokens.fromJson(json['tokens'] as Map<String, dynamic>),
      details: (json['details'] as List<dynamic>?)
          ?.map((e) => ApiErrorDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
      stack: json['stack'] as String?,
    );

Map<String, dynamic> _$$LoginResponseImplToJson(_$LoginResponseImpl instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'user': instance.user,
      'tokens': instance.tokens,
      'details': instance.details,
      'stack': instance.stack,
    };

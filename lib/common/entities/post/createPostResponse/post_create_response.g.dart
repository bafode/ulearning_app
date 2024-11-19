// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_create_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostCreateResponseImpl _$$PostCreateResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$PostCreateResponseImpl(
      code: (json['code'] as num?)?.toInt(),
      message: json['message'] as String?,
      post: json['post'] == null
          ? null
          : Post.fromJson(json['post'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PostCreateResponseImplToJson(
        _$PostCreateResponseImpl instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'post': instance.post,
    };

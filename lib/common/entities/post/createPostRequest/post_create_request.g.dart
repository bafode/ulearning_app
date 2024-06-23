// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_create_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostCreateRequestImpl _$$PostCreateRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$PostCreateRequestImpl(
      title: json['title'] as String?,
      content: json['content'] as String?,
      category: json['category'] as String?,
    );

Map<String, dynamic> _$$PostCreateRequestImplToJson(
        _$PostCreateRequestImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
      'category': instance.category,
    };

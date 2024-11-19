// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostImpl _$$PostImplFromJson(Map<String, dynamic> json) => _$PostImpl(
      id: json['id'] as String?,
      author: json['author'] as String?,
      title: json['title'] as String?,
      content: json['content'] as String?,
      category: json['category'] as String?,
      media:
          (json['media'] as List<dynamic>?)?.map((e) => e as String).toList(),
      likes:
          (json['likes'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$PostImplToJson(_$PostImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'author': instance.author,
      'title': instance.title,
      'content': instance.content,
      'category': instance.category,
      'media': instance.media,
      'likes': instance.likes,
    };

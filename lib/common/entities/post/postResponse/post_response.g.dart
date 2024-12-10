// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostResponseImpl _$$PostResponseImplFromJson(Map<String, dynamic> json) =>
    _$PostResponseImpl(
      results: (json['results'] as List<dynamic>)
          .map((e) => Post.fromJson(e as Map<String, dynamic>))
          .toList(),
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
      totalResults: (json['totalResults'] as num).toInt(),
    );

Map<String, dynamic> _$$PostResponseImplToJson(_$PostResponseImpl instance) =>
    <String, dynamic>{
      'results': instance.results,
      'page': instance.page,
      'limit': instance.limit,
      'totalPages': instance.totalPages,
      'totalResults': instance.totalResults,
    };

_$PostImpl _$$PostImplFromJson(Map<String, dynamic> json) => _$PostImpl(
      title: json['title'] as String?,
      content: json['content'] as String?,
      author: Author.fromJson(json['author'] as Map<String, dynamic>),
      category: json['category'] as String?,
      media:
          (json['media'] as List<dynamic>?)?.map((e) => e as String).toList(),
      likes: (json['likes'] as List<dynamic>)
          .map((e) => Author.fromJson(e as Map<String, dynamic>))
          .toList(),
      comments: (json['comments'] as List<dynamic>?)
          ?.map((e) => Comment.fromJson(e as Map<String, dynamic>))
          .toList(),
      id: json['id'] as String,
    );

Map<String, dynamic> _$$PostImplToJson(_$PostImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
      'author': instance.author,
      'category': instance.category,
      'media': instance.media,
      'likes': instance.likes,
      'comments': instance.comments,
      'id': instance.id,
    };

_$AuthorImpl _$$AuthorImplFromJson(Map<String, dynamic> json) => _$AuthorImpl(
      firstname: json['firstname'] as String?,
      lastname: json['lastname'] as String?,
      email: json['email'] as String?,
      avatar: json['avatar'] as String?,
      id: json['id'] as String,
    );

Map<String, dynamic> _$$AuthorImplToJson(_$AuthorImpl instance) =>
    <String, dynamic>{
      'firstname': instance.firstname,
      'lastname': instance.lastname,
      'email': instance.email,
      'avatar': instance.avatar,
      'id': instance.id,
    };

_$CommentImpl _$$CommentImplFromJson(Map<String, dynamic> json) =>
    _$CommentImpl(
      content: json['content'] as String,
      userFirstName: json['userFirstName'] as String?,
      userLastName: json['userLastName'] as String?,
      userAvatar: json['userAvatar'] as String?,
      id: json['id'] as String,
    );

Map<String, dynamic> _$$CommentImplToJson(_$CommentImpl instance) =>
    <String, dynamic>{
      'content': instance.content,
      'userFirstName': instance.userFirstName,
      'userLastName': instance.userLastName,
      'userAvatar': instance.userAvatar,
      'id': instance.id,
    };

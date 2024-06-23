// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_post_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostResponse _$PostResponseFromJson(Map<String, dynamic> json) => PostResponse(
      results: (json['results'] as List<dynamic>)
          .map((e) => PostGet.fromJson(e as Map<String, dynamic>))
          .toList(),
      page: json['page'] as int,
      limit: json['limit'] as int,
      totalPages: json['totalPages'] as int,
      totalResults: json['totalResults'] as int,
    );

PostGet _$PostGetFromJson(Map<String, dynamic> json) => PostGet(
      title: json['title'] as String,
      content: json['content'] as String,
      author: AuthorGet.fromJson(json['author'] as Map<String, dynamic>),
      category: json['category'] as String,
      media: (json['media'] as List<dynamic>).map((e) => e as String).toList(),
      id: json['id'] as String,
    );

Map<String, dynamic> _$PostGetToJson(PostGet instance) => <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
      'author': instance.author,
      'category': instance.category,
      'media': instance.media,
      'id': instance.id,
    };

AuthorGet _$AuthorGetFromJson(Map<String, dynamic> json) => AuthorGet(
      firstname: json['firstname'] as String,
      lastname: json['lastname'] as String,
      email: json['email'] as String,
      avatar: json['avatar'] as String,
      id: json['id'] as String,
    );

Map<String, dynamic> _$AuthorGetToJson(AuthorGet instance) => <String, dynamic>{
      'firstname': instance.firstname,
      'lastname': instance.lastname,
      'email': instance.email,
      'avatar': instance.avatar,
      'id': instance.id,
    };

PostListRequest _$PostListRequestFromJson(Map<String, dynamic> json) =>
    PostListRequest(
      page: json['page'] as int?,
    );

Map<String, dynamic> _$PostListRequestToJson(PostListRequest instance) =>
    <String, dynamic>{
      'page': instance.page,
    };

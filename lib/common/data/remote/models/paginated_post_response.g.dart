// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_post_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostResponse _$PostResponseFromJson(Map<String, dynamic> json) => PostResponse(
      results: (json['results'] as List<dynamic>)
          .map((e) => PostGet.fromJson(e as Map<String, dynamic>))
          .toList(),
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
      totalResults: (json['totalResults'] as num).toInt(),
    );

PostGet _$PostGetFromJson(Map<String, dynamic> json) => PostGet(
      title: json['title'] as String,
      content: json['content'] as String,
      author: AuthorGet.fromJson(json['author'] as Map<String, dynamic>),
      category: json['category'] as String,
      media: (json['media'] as List<dynamic>).map((e) => e as String).toList(),
      likes: (json['likes'] as List<dynamic>)
          .map((e) => AuthorGet.fromJson(e as Map<String, dynamic>))
          .toList(),
      comments: (json['comments'] as List<dynamic>)
          .map((e) => CommentGet.fromJson(e as Map<String, dynamic>))
          .toList(),
      id: json['id'] as String,
    );

Map<String, dynamic> _$PostGetToJson(PostGet instance) => <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
      'author': instance.author,
      'category': instance.category,
      'media': instance.media,
      'likes': instance.likes,
      'comments': instance.comments,
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

CommentGet _$CommentGetFromJson(Map<String, dynamic> json) => CommentGet(
      content: json['content'] as String,
      userFirstName: json['userFirstName'] as String,
      userLastName: json['userLastName'] as String,
      userAvatar: json['userAvatar'] as String,
      id: json['id'] as String,
    );

Map<String, dynamic> _$CommentGetToJson(CommentGet instance) =>
    <String, dynamic>{
      'content': instance.content,
      'userFirstName': instance.userFirstName,
      'userLastName': instance.userLastName,
      'userAvatar': instance.userAvatar,
      'id': instance.id,
    };

PostListRequest _$PostListRequestFromJson(Map<String, dynamic> json) =>
    PostListRequest(
      page: (json['page'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PostListRequestToJson(PostListRequest instance) =>
    <String, dynamic>{
      'page': instance.page,
    };

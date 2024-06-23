import 'package:json_annotation/json_annotation.dart';

part 'paginated_post_response.g.dart';

@JsonSerializable(genericArgumentFactories: true, createToJson: false)
class PostResponse {
  @JsonKey(name: 'results')
  final List<PostGet> results;
  @JsonKey(name: 'page')
  final int page;
  @JsonKey(name: 'limit')
  final int limit;
  @JsonKey(name: 'totalPages')
  final int totalPages;
  @JsonKey(name: 'totalResults')
  final int totalResults;

  PostResponse({
    required this.results,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.totalResults,
  });

  factory PostResponse.fromJson(Map<String, dynamic> json) =>
      _$PostResponseFromJson(json);
}

@JsonSerializable()
class PostGet {
  @JsonKey(name: 'title')
  final String title;
  @JsonKey(name: 'content')
  final String content;
  @JsonKey(name: 'author')
  final AuthorGet author;
  @JsonKey(name: 'category')
  final String category;
  @JsonKey(name: 'media')
  final List<String> media;
  @JsonKey(name: 'id')
  final String id;

  PostGet({
    required this.title,
    required this.content,
    required this.author,
    required this.category,
    required this.media,
    required this.id,
  });

  factory PostGet.fromJson(Map<String, dynamic> json) =>
      _$PostGetFromJson(json);
}

@JsonSerializable()
class AuthorGet {
  @JsonKey(name: 'firstname')
  final String firstname;
  @JsonKey(name: 'lastname')
  final String lastname;
  @JsonKey(name: 'email')
  final String email;
  @JsonKey(name: 'avatar')
  final String avatar;
  @JsonKey(name: 'id')
  final String id;

  AuthorGet({
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.avatar,
    required this.id,
  });

  factory AuthorGet.fromJson(Map<String, dynamic> json) =>
      _$AuthorGetFromJson(json);
}

@JsonSerializable(genericArgumentFactories: true)
class PostListRequest {
  @JsonKey(name: 'page')
  int? page;
  PostListRequest({
    this.page,
  });

  factory PostListRequest.fromJson(Map<String, dynamic> json) =>
      _$PostListRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PostListRequestToJson(this);
}

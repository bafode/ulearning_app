import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_response.freezed.dart';
part 'post_response.g.dart';

@freezed
class PostResponse with _$PostResponse {
  const factory PostResponse({
    required List<Post> results,
    required int page,
    required int limit,
    required int totalPages,
    required int totalResults,
  }) = _PostResponse;

  factory PostResponse.fromJson(Map<String, dynamic> json) =>
      _$PostResponseFromJson(json);
}

@freezed
class Post with _$Post {
  const factory Post({
     required String? title,
    required String? content,
    required Author author,
    required String? category,
    required List<String>? media,
    required List<Author> likes,
    required int? likesCount,
    required List<String>? domain,
    required List<Comment>? comments,
    required String? createdAt,
    required String? updatedAt,
    required String id,
  }) = _Post;

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
}

@freezed
class Author with _$Author {
  const factory Author({
    required String? firstname,
    required String? lastname,
    required String? email,
    required String? school,
    required String? avatar,
    required String id,
  }) = _Author;

  factory Author.fromJson(Map<String, dynamic> json) => _$AuthorFromJson(json);
}

@freezed
class Comment with _$Comment {
  const factory Comment({
    required String content,
    required String? userFirstName,
    required String? userLastName,
    required String? userAvatar,
    required String? id,
  }) = _Comment;

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'post.freezed.dart';

@freezed
class Post with _$Post {
  const factory Post({
    required String title,
    required String content,
    required Author author,
    required String category,
    required List<String> media,
    required String id,
  }) = _Post;
}

@freezed
class Author with _$Author {
  const factory Author({
    required String firstname,
    required String lastname,
    required String email,
    required String avatar,
    required String id,
  }) = _Author;
}

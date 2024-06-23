import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ulearning_app/common/entities/post/post.dart';

part 'post_create_response.freezed.dart';
part 'post_create_response.g.dart';

@freezed
class PostCreateResponse with _$PostCreateResponse {
  const factory PostCreateResponse({
    int? code,
    String? message,
    Post? post,
  }) = _PostCreateResponse;

  factory PostCreateResponse.fromJson(Map<String, dynamic> json) =>
      _$PostCreateResponseFromJson(json);
}

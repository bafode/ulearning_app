import 'package:freezed_annotation/freezed_annotation.dart';
part 'create_comment_request.freezed.dart';
part 'create_comment_request.g.dart';

@freezed
class CreateCommentRequest with _$CreateCommentRequest {
  const factory CreateCommentRequest({
    String? content,
  }) = _CreateCommentRequest;

  factory CreateCommentRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateCommentRequestFromJson(json);
}

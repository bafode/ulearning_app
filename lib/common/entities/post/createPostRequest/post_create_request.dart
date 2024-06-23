import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
part 'post_create_request.freezed.dart';
part 'post_create_request.g.dart';

@freezed
class PostCreateRequest with _$PostCreateRequest {
  const factory PostCreateRequest({
    String? title,
    String? content,
    String? category,
    @JsonKey(includeFromJson: false, includeToJson: false) List<File>? media,
  }) = _PostCreateRequest;

  factory PostCreateRequest.fromJson(Map<String, dynamic> json) =>
      _$PostCreateRequestFromJson(json);
}

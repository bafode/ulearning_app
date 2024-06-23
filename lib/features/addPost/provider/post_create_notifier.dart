import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ulearning_app/common/entities/post/createPostRequest/post_create_request.dart';

class PostCreateNotifier extends StateNotifier<PostCreateRequest> {
  PostCreateNotifier() : super(const PostCreateRequest(title: "post title"));

  void onPostTitleChange(String title) {
    state = state.copyWith(title: title);
  }

  void onPostContentChange(String content) {
    state = state.copyWith(content: content);
    print(state);
  }

  void onPostCategoryChange(String category) {
    state = state.copyWith(category: category);
    print(state);
  }

  void onPostMediaChange(List<File>? media) {
    state = state.copyWith(media: media);
    print(state);
  }
}

final postCreateNotifierProvier =
    StateNotifierProvider<PostCreateNotifier, PostCreateRequest>(
        (ref) => PostCreateNotifier());

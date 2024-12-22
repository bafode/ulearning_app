import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beehive/common/entities/post/createPostFilter/create_post_filter.dart';
import 'package:beehive/common/entities/post/createPostRequest/post_create_request.dart';

class PostCreateNotifier extends StateNotifier<PostCreateRequest> {
  PostCreateNotifier() : super(const PostCreateRequest(title: "post title"));

  void onPostTitleChange(String title) {
    state = state.copyWith(title: title);
  }

  void onPostContentChange(String content) {
    state = state.copyWith(content: content);
  }

  void onPostCategoryChange(String category) {
    state = state.copyWith(category: category);
  }

  void onPostMediaChange(List<File>? media) {
    state = state.copyWith(media: media);
  }
}

final postCreateNotifierProvier =
    StateNotifierProvider<PostCreateNotifier, PostCreateRequest>(
        (ref) => PostCreateNotifier());



final createPostfieldOfStudyProvider = Provider<List<FieldOfStudy>>(
    (ref) => ref.watch(createPostRepositoryProvider).fetchFieldOfStudy());

final createPostRepositoryProvider = Provider((ref) => CreatePostQueryRepository());

class CreatePostQueryRepository {
  List<FieldOfStudy> fetchFieldOfStudy() {
    return [
      const Dev(),
      const Marketing(),
      const DA(),
      const DesignUiUx(),
    ];
  }
}

final createPostFilterNotifierProvider =
    NotifierProvider<CreatePostFilterNotifier, CreatePostFilter>(
        () => CreatePostFilterNotifier());

class CreatePostFilterNotifier extends Notifier<CreatePostFilter> {

  @override
  CreatePostFilter build() => const CreatePostFilter();

  void update(CreatePostFilter filter) {
    state = filter;
  }
}

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

  void onPostDomainChange(List<FieldOfStudy> selectedDomain) {
    state = state.copyWith(selectedDomain: selectedDomain);
  }
}

final postCreateNotifierProvier =
    StateNotifierProvider<PostCreateNotifier, PostCreateRequest>(
        (ref) => PostCreateNotifier());

class CreatePostFilterNotifier extends StateNotifier<CreatePostFilter> {
  CreatePostFilterNotifier(this.ref) : super(const CreatePostFilter());

  final Ref ref;

  void update(CreatePostFilter filter) {
    state = filter;
    // Sync with PostCreateRequest
    ref.read(postCreateNotifierProvier.notifier).onPostDomainChange(filter.fieldsOfStudy);
  }
}

final createPostFilterNotifierProvider =
    StateNotifierProvider<CreatePostFilterNotifier, CreatePostFilter>(
        (ref) => CreatePostFilterNotifier(ref));

final createPostfieldOfStudyProvider = Provider<List<FieldOfStudy>>(
    (ref) => ref.watch(createPostRepositoryProvider).fetchFieldOfStudy());

final createPostRepositoryProvider = Provider((ref) => CreatePostQueryRepository());

class CreatePostQueryRepository {
  List<FieldOfStudy> fetchFieldOfStudy() {
    return [
      const Dev(),
      const WebDev(),
      const MobileDev(),
      const DataScience(),
      const AI(),
      const Marketing(),
      const DigitalMarketing(),
      const ContentStrategy(),
      const DesignUiUx(),
      const GraphicDesign(),
      const ProductDesign(),
      const DA(),
      const ProjectManagement(),
      const BusinessStrategy(),
      const Communication(),
    ];
  }
}

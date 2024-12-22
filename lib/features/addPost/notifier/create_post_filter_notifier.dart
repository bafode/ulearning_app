import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beehive/common/entities/post/createPostFilter/create_post_filter.dart';

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

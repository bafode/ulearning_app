import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ulearning_app/features/post/domain/post_filter.dart';

final postFilterNotifierProvider =
    NotifierProvider<PostFilterNotifier, PostFilter>(
        () => PostFilterNotifier());

class PostFilterNotifier extends Notifier<PostFilter> {
  @override
  PostFilter build() => const PostFilter();

  void updateQuery(String query) {
    state = state.copyWith(query: query);
  }

  void update(PostFilter filter) {
    state = filter;
  }
}

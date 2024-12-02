import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ulearning_app/common/data/di/repository_module.dart';
import 'package:ulearning_app/common/data/domain/post.dart';
import 'package:ulearning_app/common/data/repository/impl/post_repository_impl.dart';
import 'package:ulearning_app/common/entities/post/createCommentRequest/create_comment_request.dart';
import 'package:ulearning_app/common/utils/filter.dart';
import 'package:ulearning_app/common/utils/pagination_controller.dart';
import 'package:ulearning_app/features/post/domain/post_filter.dart';

final postsViewModelProvider =
    AsyncNotifierProvider<PostsViewModel, List<Post>>(() => PostsViewModel());

class PostsViewModel extends AsyncNotifier<List<Post>>
    with
        AsyncPaginationController<Post, int>,
        AsyncPaginationFilter<PostFilter, Post, int> {
  PostRepositoryImpl get repository => ref.read(postRepositoryProvider);

  var _canLoadMore = true;

  get canLoadMore => _canLoadMore;

  @override
  int get initialPage => 1;

  @override
  FutureOr<List<Post>> loadPage(int page) async {
    final (totalResults, posts) = await repository.getPosts(
      sort: currentFilter.sort,
      order: currentFilter.order,
      page: page,
    );
    final previousLength = state.valueOrNull?.length ?? 0;
    _canLoadMore = previousLength + posts.length < totalResults;
    return posts;
  }

  @override
  int nextPage(int currentPage) => currentPage + 1;

  @override
  PostFilter currentFilter = const PostFilter();

  void refresh() {
    currentPage = initialPage;
    applyFilter(currentFilter);
  }

  
  FutureOr<Post?> toggleLikePost(String postId) async {
    final post = await repository.toggleLikePost(
      postId,
    );
    return post;
  }

  FutureOr<Post?> getPost(String postId) async {
    final post = await repository.getPost(
      postId,
    );
    return post;
  }

  FutureOr<Post?> createComment(String postId, String comment) async {
    CreateCommentRequest content = CreateCommentRequest(
      content: comment,
    );
    final post = await repository.createComment(
      postId,
      content,
    );
    return post;
  }
}

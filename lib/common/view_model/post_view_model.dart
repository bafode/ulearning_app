import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ulearning_app/common/data/di/repository_module.dart';
import 'package:ulearning_app/common/data/repository/impl/post_repository_impl.dart';
import 'package:ulearning_app/common/entities/post/createCommentRequest/create_comment_request.dart';
import 'package:ulearning_app/common/entities/post/postResponse/post_response.dart';
import 'package:ulearning_app/common/utils/filter.dart';
import 'package:ulearning_app/common/utils/pagination_controller.dart';
import 'package:ulearning_app/features/post/domain/post_filter.dart';
import 'package:collection/collection.dart';

final postsViewModelProvider =
    AsyncNotifierProvider<PostsViewModel, List<Post>>(() => PostsViewModel());

class PostsViewModel extends AsyncNotifier<List<Post>>
    with
        AsyncPaginationController<Post, int>,
        AsyncPaginationFilter<PostFilter, Post, int> {
  PostRepositoryImpl get repository => ref.read(postRepositoryProvider);

  var _canLoadMore = true;

  bool get canLoadMore => _canLoadMore;

  @override
  int get initialPage => 1;

  @override
  FutureOr<List<Post>> loadPage(int page) async {
    try {
      if (page == initialPage) {
        final cachedPosts = await getPostsFromLocalStorage();
        if (cachedPosts.isNotEmpty) {
          emitIfChanged(cachedPosts);
          return cachedPosts;
        }
      }

      final postResponse = await repository.getPosts(
        sort: currentFilter.sort,
        order: currentFilter.order,
        page: page,
      );

      final previousLength = state.valueOrNull?.length ?? 0;
      _canLoadMore = previousLength + postResponse.results.length <
          postResponse.totalResults;

      await savePostsToLocalStorage(postResponse.results);

      emitIfChanged(postResponse.results);
      return postResponse.results;
    } catch (e) {
      handleError(e);
      return [];
    }
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
    try {
      final post = await repository.toggleLikePost(postId);
      if (post != null) {
        await saveSinglePostToLocalStorage(post);
      }
      return post;
    } catch (e) {
      handleError(e);
      return null;
    }
  }

  FutureOr<Post?> getPost(String postId) async {
    try {
      return await repository.getPost(postId);
    } catch (e) {
      handleError(e);
      return null;
    }
  }

  FutureOr<Post?> createComment(String postId, String comment) async {
    try {
      CreateCommentRequest content = CreateCommentRequest(content: comment);
      final post = await repository.createComment(postId, content);
      if (post != null) {
        await saveSinglePostToLocalStorage(post);
      }
      return post;
    } catch (e) {
      handleError(e);
      return null;
    }
  }

  Future<void> savePostsToLocalStorage(List<Post> posts) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final postsJson = jsonEncode(posts.map((e) => e.toJson()).toList());
      await prefs.setString('posts', postsJson);
    } catch (e) {
      handleError(e);
    }
  }

  Future<void> saveSinglePostToLocalStorage(Post post) async {
    try {
      final posts = await getPostsFromLocalStorage();
      final index = posts.indexWhere((p) => p.id == post.id);

      if (index != -1) {
        posts[index] = post;
      } else {
        posts.add(post);
      }

      await savePostsToLocalStorage(posts);
    } catch (e) {
      handleError(e);
    }
  }

  Future<List<Post>> getPostsFromLocalStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final postsJson = prefs.getString('posts') ?? '[]';
      final List<dynamic> postsList = jsonDecode(postsJson);
      return postsList.map((e) => Post.fromJson(e)).toList();
    } catch (e) {
      handleError(e);
      return [];
    }
  }

  Future<void> clearPostsFromLocalStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('posts');
    } catch (e) {
      handleError(e);
    }
  }

  void emitIfChanged(List<Post> newPosts) {
    if (!const DeepCollectionEquality().equals(state.valueOrNull, newPosts)) {
      state = AsyncData(newPosts);
    }
  }

  @override
  Future<List<Post>> build() async {
    try {
       final postResponse = await repository.getPosts(
        sort: currentFilter.sort,
        order: currentFilter.order,
        page: initialPage,
      );
      if(postResponse.results.isEmpty){
        return await getPostsFromLocalStorage();
      }else{
        state = AsyncData(postResponse.results);
        await savePostsToLocalStorage(postResponse.results);
        return postResponse.results;
      }    
    } catch (e) {
      handleError(e);
      return [];
    }
  }

  void handleError(Object e) {
    // Log or handle the error as required
    print('Error: $e');
  }
}

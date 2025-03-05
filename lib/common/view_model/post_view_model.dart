import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:beehive/common/data/di/repository_module.dart';
import 'package:beehive/common/data/repository/impl/post_repository_impl.dart';
import 'package:beehive/common/entities/post/createCommentRequest/create_comment_request.dart';
import 'package:beehive/common/entities/post/postResponse/post_response.dart';
import 'package:beehive/common/entities/user/user.dart';
import 'package:beehive/common/utils/constants.dart';
import 'package:beehive/common/utils/filter.dart';
import 'package:beehive/common/utils/pagination_controller.dart';
import 'package:beehive/features/post/domain/post_filter.dart';
import 'package:collection/collection.dart';
import 'package:beehive/global.dart';
import 'package:beehive/features/home/controller/home_controller.dart';

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
      final postResponse = await repository.getPosts(
        query: currentFilter.query,
        category: currentFilter.category,
        order: currentFilter.order,
        page: page,
      );

      // Vérifier si nous avons atteint le nombre total de posts
      final previousLength = state.valueOrNull?.length ?? 0;
      final totalFetched = previousLength + postResponse.results.length;
      
      // Mettre à jour canLoadMore en fonction du nombre total de posts
      _canLoadMore = totalFetched < postResponse.totalResults;
      
      // Si nous avons atteint le nombre total ou s'il n'y a pas de nouveaux résultats, 
      // désactiver le chargement de plus de posts
      if (postResponse.results.isEmpty || totalFetched >= postResponse.totalResults) {
        _canLoadMore = false;
      }

      await savePostsToLocalStorage(postResponse.results);

      // Si c'est la première page, remplacer l'état
      if (page == initialPage) {
        state = AsyncData(postResponse.results);
      } else {
        // Sinon, ajouter aux posts existants
        final currentPosts = state.valueOrNull ?? [];
        final combinedPosts = [...currentPosts, ...postResponse.results];
        state = AsyncData(combinedPosts);
      }
      
      return postResponse.results;
    } catch (e) {
      handleError(e);
      // En cas d'erreur, charger les posts depuis SharedPreferences
      final cachedPosts = await getPostsFromLocalStorage();
      if (cachedPosts.isNotEmpty) {
        // Mettre à jour l'état avec les posts en cache
        if (page == initialPage) {
          // Si c'est la première page, remplacer complètement l'état
          state = AsyncData(cachedPosts);
        } else {
          // Si c'est une page suivante, ajouter aux posts existants
          final currentPosts = state.valueOrNull ?? [];
          final combinedPosts = [...currentPosts, ...cachedPosts];
          state = AsyncData(combinedPosts);
        }
        // Indiquer qu'il n'y a plus de pages à charger puisque nous utilisons le cache
        _canLoadMore = false;
      }
      return cachedPosts;
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
      // Update local storage
      final posts = await getPostsFromLocalStorage();
      final index = posts.indexWhere((p) => p.id == post.id);

      if (index != -1) {
        posts[index] = post;
      } else {
        posts.add(post);
      }

      await savePostsToLocalStorage(posts);
      
      // Update the state to reflect changes in the UI
      if (state.hasValue) {
        final currentPosts = state.value!.toList();
        final stateIndex = currentPosts.indexWhere((p) => p.id == post.id);
        
        if (stateIndex != -1) {
          currentPosts[stateIndex] = post;
          state = AsyncData(currentPosts);
        }
      }
    } catch (e) {
      handleError(e);
    }
  }

  Future<List<Post>> getPostsFromLocalStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final postsJson = prefs.getString('posts') ?? '[]';
      final List<dynamic> postsList = jsonDecode(postsJson);
      state = AsyncData(postsList.map((e) => Post.fromJson(e)).toList());
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

  FutureOr<User?> toggleUserFollow(String followId) async {
    try {
      final user = await repository.toggleUserFollow(followId);
      if (user != null) {
        // Update user profile in storage
        Global.storageService
            .setString(AppConstants.STORAGE_USER_PROFILE_KEY, jsonEncode(user));
            
        // Update the profile state
        ref.read(homeUserProfileProvider.notifier).updateProfile(user);
      }
      return user;
    } catch (e) {
      handleError(e);
      return null;
    }
  }

  @override
  Future<List<Post>> build() async {
    try {
      final posts = await loadPage(initialPage);
      if (state.hasError) {
        state = AsyncData(posts);
      }
      return posts;
    } catch (e) {
      handleError(e);
      // Essayer de charger les posts depuis SharedPreferences en cas d'erreur
      final cachedPosts = await getPostsFromLocalStorage();
      if (cachedPosts.isNotEmpty) {
        state = AsyncData(cachedPosts);
        return cachedPosts;
      } else {
        state = const AsyncData([]);
        return [];
      }
    }
  }

  void handleError(Object e) {
    // Log or handle the error as required
    print('Error: $e');
  }
}

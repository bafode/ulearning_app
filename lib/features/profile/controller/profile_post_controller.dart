import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ulearning_app/common/data/di/repository_module.dart';
import 'package:ulearning_app/common/data/repository/impl/post_repository_impl.dart';
import 'package:ulearning_app/common/entities/post/postResponse/post_response.dart';
import 'package:ulearning_app/common/entities/user/user.dart';
import 'package:ulearning_app/common/utils/constants.dart';
import 'package:ulearning_app/common/utils/pagination_controller.dart';
import 'package:collection/collection.dart';
import 'package:ulearning_app/global.dart';

final loggedUserPostControllerProvider =
    AsyncNotifierProvider<LoggedUserPostController, List<Post>>(
        () => LoggedUserPostController());

class LoggedUserPostController extends AsyncNotifier<List<Post>>
    with AsyncPaginationController<Post, int> {
  PostRepositoryImpl get repository => ref.read(postRepositoryProvider);

  var _canLoadMore = true;

  bool get canLoadMore => _canLoadMore;

  @override
  int get initialPage => 1;

  @override
  FutureOr<List<Post>> loadPage(int page) async {
    try {
      final postResponse = await repository.getLoggedUserPost(
        page: page,
      );

      await saveLoggedUserPostToLocalStorage(postResponse.results);
      emitIfChanged(postResponse.results);

      final previousLength = state.valueOrNull?.length ?? 0;
      _canLoadMore = previousLength + postResponse.results.length <
          postResponse.totalResults;
      return postResponse.results;
    } catch (e) {
      handleError(e);
      return await getLoggedUserPostFromLocalStorage();
    }
  }

  @override
  int nextPage(int currentPage) => currentPage + 1;

  void refresh() {
    currentPage = initialPage;
  }

  FutureOr<User?> toggleUserFavorites(String postId) async {
    try {
      final user = await repository.toggleUserFavorites(postId);
      if (user != null) {
        Global.storageService
            .setString(AppConstants.STORAGE_USER_PROFILE_KEY, jsonEncode(user));
      }
      await loadPage(initialPage);
      return user;
    } catch (e) {
      handleError(e);
      return null;
    }
  }

  Future<void> saveLoggedUserPostToLocalStorage(List<Post> posts) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final postsJson = jsonEncode(posts.map((e) => e.toJson()).toList());
      await prefs.setString('loggedUserPosts', postsJson);
    } catch (e) {
      handleError(e);
    }
  }

  Future<void> saveSingleFavoriteToLocalStorage(Post post) async {
    try {
      final favorites = await getLoggedUserPostFromLocalStorage();
      final index = favorites.indexWhere((p) => p.id == post.id);

      if (index != -1) {
        favorites[index] = post;
      } else {
        favorites.add(post);
      }

      await saveLoggedUserPostToLocalStorage(favorites);
    } catch (e) {
      handleError(e);
    }
  }

  Future<List<Post>> getLoggedUserPostFromLocalStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = prefs.getString('loggedUserPosts') ?? '[]';
      final List<dynamic> postList = jsonDecode(favoritesJson);
      state = AsyncData(postList.map((e) => Post.fromJson(e)).toList());
      return postList.map((e) => Post.fromJson(e)).toList();
    } catch (e) {
      handleError(e);
      return [];
    }
  }

  Future<void> clearLoggedUserPostFromLocalStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('loggedUserPosts');
    } catch (e) {
      handleError(e);
    }
  }

  void emitIfChanged(List<Post> newPost) {
    if (!const DeepCollectionEquality()
        .equals(state.valueOrNull, newPost)) {
      state = AsyncData(newPost);
    }
  }

  @override
  Future<List<Post>> build() async {
    try {
      return await loadPage(initialPage);
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

import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:beehive/common/data/di/repository_module.dart';
import 'package:beehive/common/data/repository/impl/post_repository_impl.dart';
import 'package:beehive/common/entities/post/postResponse/post_response.dart';
import 'package:beehive/common/entities/user/user.dart';
import 'package:beehive/common/utils/constants.dart';
import 'package:beehive/common/utils/pagination_controller.dart';
import 'package:collection/collection.dart';
import 'package:beehive/global.dart';

final favoriteControllerProvider =
    AsyncNotifierProvider<FavoriteController, List<Post>>(() => FavoriteController());

class FavoriteController extends AsyncNotifier<List<Post>>
    with
        AsyncPaginationController<Post, int>{
  PostRepositoryImpl get repository => ref.read(postRepositoryProvider);

  var _canLoadMore = true;

  bool get canLoadMore => _canLoadMore;

  @override
  int get initialPage => 1;

  @override
  FutureOr<List<Post>> loadPage(int page) async {
    try {
     
      final postResponse = await repository.getFavorites(
        page: page,
      );

      await saveFavoritesToLocalStorage(postResponse.results);
      emitIfChanged(postResponse.results);

      final previousLength = state.valueOrNull?.length ?? 0;
      _canLoadMore = previousLength + postResponse.results.length <
          postResponse.totalResults;
      return postResponse.results;
    } catch (e) {
      handleError(e);
      return await getFavoritesFromLocalStorage();
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

  Future<void> saveFavoritesToLocalStorage(List<Post> posts) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final postsJson = jsonEncode(posts.map((e) => e.toJson()).toList());
      await prefs.setString('favorites', postsJson);
    } catch (e) {
      handleError(e);
    }
  }

  Future<void> saveSingleFavoriteToLocalStorage(Post post) async {
    try {
      final favorites = await getFavoritesFromLocalStorage();
      final index = favorites.indexWhere((p) => p.id == post.id);

      if (index != -1) {
        favorites[index] = post;
      } else {
        favorites.add(post);
      }

      await saveFavoritesToLocalStorage(favorites);
    } catch (e) {
      handleError(e);
    }
  }

  Future<List<Post>> getFavoritesFromLocalStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = prefs.getString('favorites') ?? '[]';
      final List<dynamic> favoritesList = jsonDecode(favoritesJson);
       state = AsyncData(favoritesList.map((e) => Post.fromJson(e)).toList());
      return favoritesList.map((e) => Post.fromJson(e)).toList();
    } catch (e) {
      handleError(e);
      return [];
    }
  }

  Future<void> clearFavoritesFromLocalStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('favorites');
    } catch (e) {
      handleError(e);
    }
  }

  void emitIfChanged(List<Post> newFavorites) {
    if (!const DeepCollectionEquality().equals(state.valueOrNull, newFavorites)) {
      state = AsyncData(newFavorites);
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

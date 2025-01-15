import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:beehive/common/api/chat.dart';
import 'package:beehive/common/data/repository/impl/auth_repository_impl.dart';
import 'package:beehive/common/routes/names.dart';
import 'package:beehive/common/widgets/popup_messages.dart';
import 'package:beehive/features/application/provider/application_nav_notifier.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:image_picker/image_picker.dart';
import 'package:beehive/common/data/di/repository_module.dart';
import 'package:beehive/common/data/repository/impl/post_repository_impl.dart';
import 'package:beehive/common/entities/post/postResponse/post_response.dart';
import 'package:beehive/common/entities/user/user.dart';
import 'package:beehive/common/utils/constants.dart';
import 'package:beehive/common/utils/pagination_controller.dart';
import 'package:collection/collection.dart';
import 'package:beehive/global.dart';

final loggedUserPostControllerProvider =
    AsyncNotifierProvider<LoggedUserPostController, List<Post>>(
        () => LoggedUserPostController());

class LoggedUserPostController extends AsyncNotifier<List<Post>>
    with AsyncPaginationController<Post, int> {
  PostRepositoryImpl get repository => ref.read(postRepositoryProvider);
  AuthRepositoryImpl get authRepository => ref.read(authRepositoryProvider);

  var _canLoadMore = true;

  bool get canLoadMore => _canLoadMore;

   File? _photo;
  final ImagePicker _picker = ImagePicker();

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

    Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _photo = File(pickedFile.path);
     uploadFile(Global.storageService.getUserProfile().id);
    } else {
      print('No image selected.');
    }
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      _photo = File(pickedFile.path);
     uploadFile(Global.storageService.getUserProfile().id);
    } else {
      print('No image selected.');
    }
  }

  
  Future uploadFile(String? id) async {
    if (_photo == null) return;
    // print(_photo);
    var result = await ChatAPI.uploadProfileImage(file: _photo,id: id);
    await Global.storageService
        .setString(AppConstants.STORAGE_USER_PROFILE_KEY, jsonEncode(result));
    EasyLoading.dismiss();
    ref.read(applicationNavNotifierProvider.notifier).changeIndex(3);
    Global.navigatorKey.currentState
        ?.pushNamedAndRemoveUntil(AppRoutes.APPLICATION, (route) => false);
   
    }

     FutureOr<User?> getUserById(String userId) async {
    try {
      return await authRepository.getUserById(userId);
    } catch (e) {
      handleError(e);
      return null;
    }
  }
}

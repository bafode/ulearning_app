import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:beehive/common/entities/post/postResponse/post_response.dart';

/// A global provider that maintains the state of all posts across the app
final globalPostsProvider = StateNotifierProvider<GlobalPostsNotifier, Map<String, Post>>((ref) {
  return GlobalPostsNotifier();
});

class GlobalPostsNotifier extends StateNotifier<Map<String, Post>> {
  GlobalPostsNotifier() : super({}) {
    // Load posts from local storage when initialized
    _loadPostsFromLocalStorage();
  }

  /// Load posts from SharedPreferences
  Future<void> _loadPostsFromLocalStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final postsJson = prefs.getString('posts') ?? '[]';
      final List<dynamic> postsList = jsonDecode(postsJson);
      final posts = postsList.map((e) => Post.fromJson(e)).toList();
      
      // Convert list to map with post ID as key for easier lookup
      final postsMap = {for (var post in posts) post.id: post};
      state = postsMap;
    } catch (e) {
      print('Error loading posts from local storage: $e');
    }
  }

  /// Save all posts to SharedPreferences
  Future<void> _savePostsToLocalStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final postsList = state.values.toList();
      final postsJson = jsonEncode(postsList.map((e) => e.toJson()).toList());
      await prefs.setString('posts', postsJson);
    } catch (e) {
      print('Error saving posts to local storage: $e');
    }
  }

  /// Update a single post in the state
  void updatePost(Post post) {
    state = {...state, post.id: post};
    _savePostsToLocalStorage();
  }

  /// Update multiple posts at once
  void updatePosts(List<Post> posts) {
    final newState = {...state};
    for (final post in posts) {
      newState[post.id] = post;
    }
    state = newState;
    _savePostsToLocalStorage();
  }

  /// Get a post by ID
  Post? getPost(String id) {
    return state[id];
  }

  /// Get all posts as a list
  List<Post> getAllPosts() {
    return state.values.toList();
  }

  /// Clear all posts
  void clearPosts() {
    state = {};
    _savePostsToLocalStorage();
  }
}

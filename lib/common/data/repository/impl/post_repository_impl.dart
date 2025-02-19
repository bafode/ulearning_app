import 'package:dio/dio.dart';
import 'package:beehive/common/data/remote/rest_client_api.dart';
import 'package:beehive/common/data/repository/post_repository.dart';
import 'package:beehive/common/entities/post/createCommentRequest/create_comment_request.dart';
import 'package:beehive/common/entities/post/createPostResponse/post_create_response.dart';
import 'package:beehive/common/entities/post/postResponse/post_response.dart';
import 'package:beehive/common/entities/user/user.dart';
import 'package:beehive/features/post/domain/post_filter.dart';

class PostRepositoryImpl extends PostRepository {
  final RestClientApi api;

  PostRepositoryImpl(this.api);

  @override
  Future<PostResponse> getPosts({
    String? query,
    SortOption? category,
    OrderOption? order,
    int? page,
    int? limit,
  }) async {
    final response = await api.getPosts(
      query: query,
      category: category?.value,
      sortBy: order?.value,
      page: page,
      limit: limit ?? 10,
    );
    return response;
  }

  @override
  Future<PostResponse> getFavorites({
    String? query,
    SortOption? sort,
    OrderOption? order,
    int? page,
    int? limit,
  }) async {
    final response = await api.getFavorites(
      query: query,
      page: page,
      limit: limit ?? 9,
    );
    return response;
  }

  @override
  Future<PostResponse> getLoggedUserPost({
    String? query,
    SortOption? sort,
    OrderOption? order,
    int? page,
    int? limit,
  }) async {
    final response = await api.getLoggedUserPost(
      query: query,
      page: page,
      limit: limit ?? 9,
    );
    return response;
  }

  @override
  Future<PostCreateResponse?> createPost(String title, String content,
      String category,List<String>? domain, List<MultipartFile> media) async {
    final response = await api.createPost(title, content, category,domain, media);
    return response;
  }
  
  @override
  Future<Post?> toggleLikePost(String postId) async {
    final response= await api.toagleLikePost(postId);
    return response;
  }

  @override
  Future<User?> toggleUserFavorites(String postId) async {
    final response = await api.toggleUserFavorites(postId);
    return response;
  }

   @override
  Future<User?> toggleUserFollow(String followId) async {
    final response = await api.toggleUserFollow(followId);
    return response;
  }

  @override
  Future<Post?> getPost(String postId) async {
    final response = await api.getPost(postId);
    return response;
  }

  @override
  Future<Post?> createComment(String postId, CreateCommentRequest content) async {
    final response = await api.addComment(postId, content);
    return response;
  }
}

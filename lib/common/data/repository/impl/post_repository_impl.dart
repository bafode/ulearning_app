import 'package:beehive/common/entities/error/api_error_response.dart';
import 'package:beehive/common/utils/network_error.dart';
import 'package:dartz/dartz.dart';
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
      limit: limit ?? 30,
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
      limit: limit ?? 50,
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
      limit: limit ?? 50,
    );
    return response;
  }

  @override
  Future<PostResponse> getUserPosts(
    String userId, {
    String? query,
    SortOption? sort,
    OrderOption? order,
    int? page,
    int? limit,
  }) async {
    final response = await api.getUserPosts(
      userId,
      query: query,
      page: page,
      limit: limit ?? 50,
    );
    return response;
  }

  @override
  Future<PostResponse> getUserFavorites(
    String userId, {
    String? query,
    SortOption? sort,
    OrderOption? order,
    int? page,
    int? limit,
  }) async {
    final response = await api.getUserFavorites(
      userId,
      query: query,
      page: page,
      limit: limit ?? 50,
    );
    return response;
  }

  @override
  Future<Either<ApiErrorResponse, PostCreateResponse?>> createPost(String title, String content,
      String category,List<String>? domain, List<MultipartFile> media) async {
    try {
      final response =
          await api.createPost(title, content, category, domain, media);

      if (response.code! >= 400) {
        return Left(ApiErrorResponse(
            code: response.code,
            message: response.message,
            details: [],
            stack: ""));
      } else {
        return Right(response);
      }
    } catch (e) {
      // Gérer les exceptions non liées à la réponse de l'API
      if (e is DioException) {
        return DioErrorHandler.handleDioException(e);
      }
      return Left(ApiErrorResponse(
          code: 500,
          message: 'Erreur de connexion: ${e.toString()}',
          details: []));
    }
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

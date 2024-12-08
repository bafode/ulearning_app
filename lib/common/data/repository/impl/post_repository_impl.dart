import 'package:dio/dio.dart';
import 'package:ulearning_app/common/data/remote/rest_client_api.dart';
import 'package:ulearning_app/common/data/repository/post_repository.dart';
import 'package:ulearning_app/common/entities/post/createCommentRequest/create_comment_request.dart';
import 'package:ulearning_app/common/entities/post/createPostResponse/post_create_response.dart';
import 'package:ulearning_app/common/entities/post/postResponse/post_response.dart';
import 'package:ulearning_app/common/entities/user/user.dart';
import 'package:ulearning_app/features/post/domain/post_filter.dart';

class PostRepositoryImpl extends PostRepository {
  final RestClientApi api;

  PostRepositoryImpl(this.api);

  @override
  Future<PostResponse> getPosts({
    String? query,
    SortOption? sort,
    OrderOption? order,
    int? page,
    int? limit,
  }) async {
    final response = await api.getPosts(
      query: query,
      sort: sort?.value,
      order: order?.value,
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
      limit: limit ?? 10,
    );
    return response;
  }

  @override
  Future<PostCreateResponse?> createPost(String title, String content,
      String category, List<MultipartFile> media) async {
    final response = await api.createPost(title, content, category, media);
    return response;
  }
  
  @override
  Future<Post?> toggleLikePost(String postId) async {
    final response= await api.toagleLikePost(postId);
    return response;
  }

  @override
  Future<User?> toggleUserFavorites(String postId) async {
    final response = await api.toagleUserFavorites(postId);
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

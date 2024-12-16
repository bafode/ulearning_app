
import 'package:dio/dio.dart';
import 'package:ulearning_app/common/entities/post/createCommentRequest/create_comment_request.dart';
import 'package:ulearning_app/common/entities/post/createPostResponse/post_create_response.dart';
import 'package:ulearning_app/common/entities/post/postResponse/post_response.dart';
import 'package:ulearning_app/common/entities/user/user.dart';
import 'package:ulearning_app/features/post/domain/post_filter.dart';

abstract class PostRepository {
  Future<PostResponse> getPosts({
    String query = "",
    SortOption? category,
    OrderOption? order,
    int? page,
    int? limit,
  });

  Future<PostResponse> getFavorites({
    String query = "",
    int? page,
    int? limit,
  });

  Future<PostResponse> getLoggedUserPost({
    String query = "",
    int? page,
    int? limit,
  });

  Future<PostCreateResponse?> createPost(
      String title, String content, String category,List<String> domain, List<MultipartFile> media);

  Future<Post?> toggleLikePost(String postId);

  Future<User?> toggleUserFavorites(String postId);

  Future<User?> toggleUserFollow(String followId);

  Future<Post?> getPost(String postId);

  Future<Post?> createComment(String postId, CreateCommentRequest content);
}

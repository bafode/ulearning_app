
import 'package:dio/dio.dart';
import 'package:ulearning_app/common/entities/post/createCommentRequest/create_comment_request.dart';
import 'package:ulearning_app/common/entities/post/createPostResponse/post_create_response.dart';
import 'package:ulearning_app/common/entities/post/postResponse/post_response.dart';
import 'package:ulearning_app/features/post/domain/post_filter.dart';

abstract class PostRepository {
  Future<PostResponse> getPosts({
    String query = "",
    SortOption? sort,
    OrderOption? order,
    int? page,
    int? limit,
  });

  Future<PostCreateResponse?> createPost(
      String title, String content, String category, List<MultipartFile> media);

  Future<Post?> toggleLikePost(String postId);

  Future<Post?> getPost(String postId);

  Future<Post?> createComment(String postId, CreateCommentRequest content);
}

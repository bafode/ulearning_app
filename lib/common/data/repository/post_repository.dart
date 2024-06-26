import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ulearning_app/common/data/domain/post.dart';
import 'package:ulearning_app/common/entities/post/createPostRequest/post_create_request.dart';
import 'package:ulearning_app/common/entities/post/createPostResponse/post_create_response.dart';
import 'package:ulearning_app/features/post/domain/post_filter.dart';

abstract class PostRepository {
  Future<(int totalResults, List<Post> posts)> getPosts({
    String query = "",
    SortOption? sort,
    OrderOption? order,
    int? page,
    int? limit,
  });

  Future<PostCreateResponse?> createPost(
      String title, String content, String category, List<MultipartFile> media);
}

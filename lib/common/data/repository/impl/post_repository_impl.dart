import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ulearning_app/common/data/domain/post.dart';
import 'package:ulearning_app/common/data/mappers/post_mapper.dart';
import 'package:ulearning_app/common/data/remote/rest_client_api.dart';
import 'package:ulearning_app/common/data/repository/post_repository.dart';
import 'package:ulearning_app/common/entities/post/createPostRequest/post_create_request.dart';
import 'package:ulearning_app/common/entities/post/createPostResponse/post_create_response.dart';
import 'package:ulearning_app/features/post/domain/post_filter.dart';

class PostRepositoryImpl extends PostRepository {
  final RestClientApi api;

  PostRepositoryImpl(this.api);

  @override
  Future<(int totalResults, List<Post> posts)> getPosts({
    String query = "",
    SortOption? sort,
    OrderOption? order,
    int? page,
    int? limit,
  }) async {
    final response = await api.getPosts(
      //query: query,
      sort: sort?.value,
      order: order?.value,
      page: page,
      limit: limit ?? 10,
    );
    return (
      response.totalResults,
      response.results.map((e) => e.toDomain()).toList()
    );
  }

  @override
  Future<PostCreateResponse?> createPost(String title, String content,
      String category, List<MultipartFile> media) async {
    final response = await api.createPost(title, content, category, media);
    return response;
  }
}

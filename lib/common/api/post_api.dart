import 'package:dio/dio.dart';
import 'package:ulearning_app/common/data/domain/post.dart';
import 'package:ulearning_app/common/data/mappers/post_mapper.dart';
import 'package:ulearning_app/common/data/remote/models/paginated_post_response.dart';
import 'package:ulearning_app/common/services/http_util.dart';

final dio = Dio();

class PostAPI {
  static Future<PostResponse>? postsList() async {
    var response = await HttpUtil().get('v1/posts');
    return PostResponse.fromJson(response);
  }

  static Future<(int totalResults, List<Post> posts)> searchPost({
    PostListRequest? params,
  }) async {
    PostResponse response = await HttpUtil().get(
      'v1/posts',
      queryParameters: params?.toJson(),
    );
    print("response: $response");
    return (
      response.totalResults,
      response.results.map((e) => e.toDomain()).toList()
    );
  }
}

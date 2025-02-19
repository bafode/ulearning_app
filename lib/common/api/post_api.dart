import 'package:beehive/common/entities/post/postResponse/post_response.dart';
import 'package:beehive/common/services/http_util.dart';

class PostAPI {
  static Future<PostResponse?> postsList() async {
    var response = await HttpUtil().get(
      'v1/posts',
    );
    if (response != null) {
      return PostResponse.fromJson(response);
    }
    return null;
  }
}

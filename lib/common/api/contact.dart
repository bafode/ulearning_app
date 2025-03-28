
import 'package:beehive/common/entities/contact/contactResponse/contact_response_entity.dart';
import 'package:beehive/common/entities/user/user.dart';
import 'package:beehive/common/services/http_util.dart';

class ContactAPI {
  /// 翻页
  /// refresh 是否刷新
  static Future<ContactResponseEntity> post_contact() async {
    var response = await HttpUtil().get(
      'v1/users/contacts',
    );
    return ContactResponseEntity.fromJson(response);
  }

  static Future<ContactResponseEntity> getFollowers(String id) async {
    var response = await HttpUtil().get(
      "v1/users/$id/followers",
    );
    return ContactResponseEntity.fromJson(response);
  }

  static Future<ContactResponseEntity> getFollowings(String id) async {
    var response = await HttpUtil().get(
      "v1/users/$id/following",
    );
    return ContactResponseEntity.fromJson(response);
  }

  static Future<User> toggleFollow(String targetId) async {
    print("targetId: $targetId");
    var response = await HttpUtil().patch(
      "v1/users/$targetId/follow",
    );
    return User.fromJson(response);
  }
}

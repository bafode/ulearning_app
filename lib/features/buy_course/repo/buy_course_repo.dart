import 'package:ulearning_app/common/models/base.dart';
import 'package:ulearning_app/common/models/course.dart';
import 'package:ulearning_app/common/services/http_util.dart';

class BuyCourseRepo {
  static Future<BaseResponseEntity> buyCourse(
      {CourseRequestEntity? params}) async {
    var response = await HttpUtil()
        .post("api/checkout", queryParameters: params?.toJson());
    return BaseResponseEntity.fromJson(response);
  }
}

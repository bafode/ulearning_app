import 'package:dio/dio.dart';
import 'package:ulearning_app/common/models/course.dart';
import 'package:ulearning_app/common/services/http_util.dart';

final dio = Dio();

class CourseAPI {
  static Future<CourseListResponseEntity> courseList() async {
    var response = await HttpUtil().post('api/courses');
    return CourseListResponseEntity.fromJson(response);
  }

  static Future<CourseListResponseEntity> search({
    SearchRequestEntity? params,
  }) async {
    var response = await HttpUtil().post(
      'api/courses/search',
      queryParameters: params?.toJson(),
    );
    return CourseListResponseEntity.fromJson(response);
  }
}

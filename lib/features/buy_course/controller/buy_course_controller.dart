import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ulearning_app/common/models/course.dart';

import '../repo/buy_course_repo.dart';

part 'buy_course_controller.g.dart';

@riverpod
Future<String?> buyCourseController(BuyCourseControllerRef ref,
    {required String index}) async {
  CourseRequestEntity courseRequestEntity = CourseRequestEntity();
  courseRequestEntity.id = index;
  final response = await BuyCourseRepo.buyCourse(params: courseRequestEntity);
  if (response.code == 200) {
    return response.data;
    //return null;
  } else {
    print('request failed due to ${response.msg}');
    print('request failed due to ${response.code}');
  }
  return null;
}

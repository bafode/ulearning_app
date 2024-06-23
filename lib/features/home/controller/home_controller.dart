import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ulearning_app/common/api/course_api.dart';
import 'package:ulearning_app/common/api/post_api.dart';
import 'package:ulearning_app/common/data/domain/post.dart';
import 'package:ulearning_app/common/models/entities.dart';
import 'package:ulearning_app/global.dart';
part 'home_controller.g.dart';

@Riverpod(keepAlive: true)
class HomeScreenBannerDots extends _$HomeScreenBannerDots {
  @override
  int build() => 0;

  void setIndex(int value) {
    state = value;
  }
}

@Riverpod(keepAlive: true)
class PostBannerDots extends _$PostBannerDots {
  @override
  int build() => 0;

  void setIndex(int value) {
    state = value;
  }
}

@riverpod
class Logout extends _$Logout {
  @override
  FutureOr<bool> build() {
    return Global.storageService.resetStorage();
  }
}

@riverpod
class HomeUserProfile extends _$HomeUserProfile {
  @override
  FutureOr<User> build() {
    return Global.storageService.getUserProfile();
  }
}

@Riverpod(keepAlive: true)
class HomeCourseList extends _$HomeCourseList {
  Future<List<CourseItem>?> fetchCourseList() async {
    var result = await CourseAPI.courseList();
    if (result.code == 200) {
      return result.data;
    }
    return null;
  }

  @override
  FutureOr<List<CourseItem>?> build() async {
    return fetchCourseList();
  }
}

@Riverpod(keepAlive: true)
class HomePostList extends _$HomePostList {
  Future<List<Post>?> fetchPostList() async {
    var response = await PostAPI.postsList();
    if (response != null) {
      // return response.results;
    }
    return null;
  }

  @override
  FutureOr<List<Post>?> build() async {
    return fetchPostList();
  }
}

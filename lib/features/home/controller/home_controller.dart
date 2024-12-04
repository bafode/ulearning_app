import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ulearning_app/common/api/post_api.dart';
import 'package:ulearning_app/common/entities/post/postResponse/post_response.dart';
import 'package:ulearning_app/common/entities/user/user.dart';
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

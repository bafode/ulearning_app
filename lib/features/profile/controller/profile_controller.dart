import 'package:beehive/features/profile/controller/profile_post_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:beehive/common/entities/user/user.dart';
import 'package:beehive/global.dart';
part 'profile_controller.g.dart';

@riverpod
class ProfileController extends _$ProfileController {
  @override
  User build() => Global.storageService.getUserProfile();
}


@riverpod
class AsyncNotifierProfileController
    extends _$AsyncNotifierProfileController {
  @override
  FutureOr<User?> build() async {
    return Global.storageService.getUserProfile();
  }

  void init(String? id) {
    asyncProfileData(id);
  }

  asyncProfileData(String? id) async {
    if(id==null||id== Global.storageService.getUserProfile().id){
      state = AsyncData(Global.storageService.getUserProfile());
    }else{
      var response =
          await ref.read(loggedUserPostControllerProvider.notifier).getUserById(id);
      state = AsyncData(response);
    } 
  }
}



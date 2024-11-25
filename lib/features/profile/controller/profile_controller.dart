import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ulearning_app/common/entities/user/user.dart';
import 'package:ulearning_app/global.dart';
part 'profile_controller.g.dart';

@riverpod
class ProfileController extends _$ProfileController {
  @override
  User build() => Global.storageService.getUserProfile();
}

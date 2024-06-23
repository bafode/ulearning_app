import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ulearning_app/common/models/entities.dart';
import 'package:ulearning_app/global.dart';
part 'profile_controller.g.dart';

@riverpod
class ProfileController extends _$ProfileController {
  @override
  User build() => Global.storageService.getUserProfile();
}

import 'package:get/get.dart';

import 'controller.dart';

class FollowersBinding implements Bindings{
  @override
  void dependencies() {
   Get.lazyPut<FollowersController>(() => FollowersController());
  }
}
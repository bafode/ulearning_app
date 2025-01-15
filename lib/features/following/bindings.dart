import 'package:get/get.dart';

import 'controller.dart';

class FollowingBinding implements Bindings{
  @override
  void dependencies() {
   Get.lazyPut<FollowingController>(() => FollowingController());
  }
}
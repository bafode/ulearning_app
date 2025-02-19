import 'package:get/get.dart';
import 'package:beehive/features/message/controller.dart';

class UnotificationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MessageController>(() => MessageController());
  }
}

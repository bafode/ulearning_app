import 'package:get/get.dart';
import 'package:beehive/features/message/controller.dart';
import 'package:beehive/features/unotification/controller.dart';

class UnotificationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MessageController>(() => MessageController());
    Get.lazyPut<NotificationController>(() => NotificationController());
  }
}

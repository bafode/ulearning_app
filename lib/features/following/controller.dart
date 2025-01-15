import 'package:beehive/common/api/contact.dart';
import 'package:beehive/common/routes/names.dart';
import 'package:beehive/features/following/state.dart';
import 'package:beehive/global.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class FollowingController extends GetxController {
  FollowingController();
  final title = "Following .";
  final state = FollowingState();
  final token = Global.storageService.getUserProfile().id;

  @override
  void onReady() {
    super.onReady();
    asyncLoadAllData(token);
  }

  Future<void> goProfile(String id) async {
    Get.offAllNamed(AppRoutes.Profile, parameters: {"id": id});
  }

  asyncLoadAllData(String? id) async {
    EasyLoading.show(
        indicator: const CircularProgressIndicator(),
        maskType: EasyLoadingMaskType.clear,
        dismissOnTap: true);

    state.followingList.clear();
    var result = await ContactAPI.getFollowings(id!);
    if (kDebugMode) {
      print(result.data!);
    }
    if (result.code == 0) {
      state.followingList.addAll(result.data!);
    }
    EasyLoading.dismiss();
  }
}

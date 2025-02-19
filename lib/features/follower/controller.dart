import 'package:beehive/common/api/contact.dart';
import 'package:beehive/common/routes/names.dart';
import 'package:beehive/common/entities/user/user.dart';
import 'package:beehive/features/follower/index.dart';
import 'package:beehive/global.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class FollowersController extends GetxController {
  FollowersController();
  final title = "Followers .";
  final state = FollowersState();
  final token = Global.storageService.getUserProfile().id;

  @override
  void onReady() {
    super.onReady();
    asyncLoadAllData(token);
  }

  Future<void> goProfile(String id) async {
    Get.offAllNamed(AppRoutes.Profile, parameters: {"id": id});
  }

  Future<void> getFollowersList() async {
    return asyncLoadAllData(token);
  }

  // Track following status
  final RxMap<String, bool> followingStatus = <String, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    updateFollowingStatus();
  }

  Future<void> updateFollowingStatus() async {
    if (token != null) {
      var result = await ContactAPI.getFollowings(token!);
      if (result.code == 0 && result.data != null) {
        followingStatus.clear();
        for (var contact in result.data!) {
          if (contact.token != null) {
            followingStatus[contact.token!] = true;
          }
        }
      }
    }
  }

  bool isFollowing(String targetId) {
    return followingStatus[targetId] ?? false;
  }

  Future<void> toggleFollow(String targetId) async {
    try {
      EasyLoading.show();
      await ContactAPI.toggleFollow(targetId);
       followingStatus[targetId] = !isFollowing(targetId);
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      Get.snackbar(
        'Error',
        'Failed to update follow status',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  asyncLoadAllData(String? id) async {
    EasyLoading.show(
        indicator: const CircularProgressIndicator(),
        maskType: EasyLoadingMaskType.clear,
        dismissOnTap: true);

    state.followerList.clear();
    var result = await ContactAPI.getFollowers(id!);
    if (kDebugMode) {
      print(result.data!);
    }
    if (result.code == 0) {
      var users = result.data!.map((contact) => User(
            id: contact.token,
            firstname: contact.firstname,
            lastname: contact.lastname,
            description: contact.description,
            avatar: contact.avatar,
            online: contact.online,
          )).toList();
      state.followerList.addAll(users);
    }
    EasyLoading.dismiss();
  }
}

import 'dart:convert';

import 'package:beehive/common/api/contact.dart';
import 'package:beehive/common/routes/names.dart';
import 'package:beehive/common/utils/constants.dart';
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

  Future<void> getFollowingList() async {
    return asyncLoadAllData(token);
  }

  // Track following status
  

  @override
  void onInit() {
    super.onInit();
    updateFollowingStatus();
  }

  Future<void> updateFollowingStatus() async {
    if (token != null) {
      var result = await ContactAPI.getFollowings(token!);
      if (result.code == 0 && result.data != null) {
        state.followingStatus.clear();
        for (var contact in result.data!) {
          if (contact.token != null) {
            state.followingStatus[contact.token!] = true;
          }
        }
      }
    }
  }

  bool isFollowing(String targetId) {
    return state.followingStatus[targetId] ?? false;
  }

  Future<void> toggleFollow(String targetId) async {
    try {
      if(kDebugMode) {
        print('follow status for ${state.followingStatus}');
      }
      
      // Update UI immediately for responsive feedback
      final newStatus = !isFollowing(targetId);
      state.followingStatus[targetId] = newStatus;
      state.followingStatus.refresh(); // Force UI update

      // Make API call in background
      final response=await ContactAPI.toggleFollow(targetId);
      await Global.storageService.setString(
          AppConstants.STORAGE_USER_PROFILE_KEY, jsonEncode(response));
       if (!newStatus) {
        state.followingList.removeWhere((user) => user.token == targetId);
      }
    } catch (e) {
      EasyLoading.dismiss();
      state.followingStatus.refresh();
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

import 'package:beehive/common/utils/app_colors.dart';
import 'package:beehive/features/following/widgets/follow_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'controller.dart';

class FollowingPage extends GetView<FollowingController> {
  const FollowingPage({super.key});

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primaryElement,
      leading: GestureDetector(
        child: Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
          size: 20.sp,
        ),
        onTap: () {
          Get.back();
        },
      ),
      title: Text(
        "Abonnements",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // Refresh both following list and status
            await Future.wait([
              controller.getFollowingList(),
              controller.updateFollowingStatus(),
            ]);
          },
          child: const FollowingList(),
        ),
      ),
    );
  }
}

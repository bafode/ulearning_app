import 'package:beehive/common/utils/app_colors.dart';
import 'package:beehive/features/following/widgets/follow_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'controller.dart';

class FollowingPage extends GetView<FollowingController> {
  const FollowingPage({super.key});
  AppBar _buildAppBar(){
    return AppBar(
      title: Text(
        "Following",
        style: TextStyle(
          color: AppColors.primaryText,
          fontSize: 16.sp,
          fontWeight: FontWeight.normal
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body:SizedBox(
        width: 360.w,
        height: 780.h,
        child: const FollowingList()
      )
    );
  }
}

import 'package:beehive/features/application/provider/application_nav_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beehive/common/utils/app_colors.dart';
import 'package:beehive/common/utils/image_res.dart';
AppBar addPostAppBar(WidgetRef ref) {
  return AppBar(
      title: Container(
    margin: EdgeInsets.only(left: 7.w, right: 7.w),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            ref.read(appZoomControllerProvider).toggle?.call();
          },
          child: SizedBox(
            width: 18.w,
            height: 12.h,
            child: Image.asset("assets/icons/menu.png"),
          ),
        ),
        SizedBox(
          child: Text(
            "Add Post",
            style: TextStyle(
              color: AppColors.primaryText,
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
        ),
        SizedBox(
          width: 24.w,
          height: 24.h,
          child: Image.asset(ImageRes.arrowRight),
        ),
      ],
    ),
  ));
}

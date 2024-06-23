import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ulearning_app/common/routes/app_routes_names.dart';
import 'package:ulearning_app/common/utils/app_colors.dart';

class ProfileListView extends StatelessWidget {
  const ProfileListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          child: Container(
            margin: EdgeInsets.only(bottom: 15.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 40.h,
                  height: 40.h,
                  padding: EdgeInsets.all(7.w),
                  decoration: BoxDecoration(
                      color: AppColors.primaryElement,
                      borderRadius: BorderRadius.all(Radius.circular(10.w)),
                      border: Border.all(color: AppColors.primaryElement)),
                  child: Image.asset("assets/icons/settings.png"),
                ),
                Container(
                  margin: EdgeInsets.only(left: 15.w),
                  child: Text(
                    "Settings",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: AppColors.primaryText,
                      fontWeight: FontWeight.bold,
                      fontSize: 13.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            Navigator.of(context).pushNamed(AppRoutesNames.Setting);
          },
        ),
        GestureDetector(
          child: Container(
            margin: EdgeInsets.only(bottom: 15.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 40.h,
                  height: 40.h,
                  padding: EdgeInsets.all(7.w),
                  decoration: BoxDecoration(
                      color: AppColors.primaryElement,
                      borderRadius: BorderRadius.all(Radius.circular(10.w)),
                      border: Border.all(color: AppColors.primaryElement)),
                  child: Image.asset("assets/icons/credit-card.png"),
                ),
                Container(
                  margin: EdgeInsets.only(left: 15.w),
                  child: Text(
                    "Payment Details",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: AppColors.primaryText,
                      fontWeight: FontWeight.bold,
                      fontSize: 13.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            // Navigator.of(context).pushNamed(AppRoutes.Account);
          },
        ),
        Container(
          margin: EdgeInsets.only(bottom: 15.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 40.h,
                height: 40.h,
                padding: EdgeInsets.all(7.w),
                decoration: BoxDecoration(
                    color: AppColors.primaryElement,
                    borderRadius: BorderRadius.all(Radius.circular(10.w)),
                    border: Border.all(color: AppColors.primaryElement)),
                child: Image.asset("assets/icons/award.png"),
              ),
              Container(
                margin: EdgeInsets.only(left: 15.w),
                child: Text(
                  "Achievement",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: AppColors.primaryText,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 15.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 40.h,
                height: 40.h,
                padding: EdgeInsets.all(7.w),
                decoration: BoxDecoration(
                    color: AppColors.primaryElement,
                    borderRadius: BorderRadius.all(Radius.circular(10.w)),
                    border: Border.all(color: AppColors.primaryElement)),
                child: Image.asset("assets/icons/heart(1).png"),
              ),
              Container(
                margin: EdgeInsets.only(left: 15.w),
                child: Text(
                  "Love",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: AppColors.primaryText,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 15.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 40.h,
                height: 40.h,
                padding: EdgeInsets.all(7.w),
                decoration: BoxDecoration(
                    color: AppColors.primaryElement,
                    borderRadius: BorderRadius.all(Radius.circular(10.w)),
                    border: Border.all(color: AppColors.primaryElement)),
                child: Image.asset("assets/icons/cube.png"),
              ),
              Container(
                margin: EdgeInsets.only(left: 15.w),
                child: Text(
                  "Learning Reminders",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: AppColors.primaryText,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

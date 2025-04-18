import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beehive/common/routes/routes.dart';
import 'package:beehive/common/utils/app_colors.dart';

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
                    "Reglages du compte",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 13.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            Navigator.of(context).pushNamed(AppRoutes.Setting);
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
                    "Payement",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.black,
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
                    color: Colors.black,
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
                  "Favoris",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

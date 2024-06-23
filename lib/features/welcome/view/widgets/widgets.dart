import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ulearning_app/common/utils/app_colors.dart';
import 'package:ulearning_app/common/utils/constants.dart';
import 'package:ulearning_app/common/widgets/app_shadow.dart';
import 'package:ulearning_app/common/widgets/text_widgets.dart';
import 'package:ulearning_app/global.dart';

class AppOnboardingPage extends StatelessWidget {
  final PageController controller;
  final String imagePath;
  final String title;
  final String subTitle;
  final int index;
  final BuildContext context;

  const AppOnboardingPage({
    super.key,
    required this.controller,
    required this.imagePath,
    required this.title,
    required this.subTitle,
    required this.index,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.98,
            decoration: BoxDecoration(
              color: AppColors.primaryElement,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Image.asset(
              imagePath,
              width: 300.w,
              height: 300.h,
              fit: BoxFit.contain,
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: 15.h),
              child: text24Normal(text: title)),
          Container(
            margin: EdgeInsets.only(top: 15.h),
            padding: EdgeInsets.only(left: 30.w, right: 30.w),
            child: Text16Normal(
              text: subTitle,
              color: Colors.white,
            ),
          ),
          _nextButton(index, controller, context)
        ],
      ),
    );
  }
}

Widget _nextButton(int index, PageController controller, BuildContext context) {
  return GestureDetector(
    onTap: () {
      if (index < 3) {
        print(index);
        controller.animateToPage(index,
            duration: const Duration(milliseconds: 300), curve: Curves.linear);
      } else {
        //remember if we are first time or not
        Global.storageService
            .setBool(AppConstants.STORAGE_DEVICE_OPEN_FIRST_KEY, true);

        Navigator.pushNamed(
          context,
          "/sign_in",
        );
      }
    },
    child: Container(
      width: 325.w,
      height: 50.h,
      margin: EdgeInsets.only(top: 100.h, left: 25.w, right: 25.w),
      decoration: appBoxShadow(
        color: AppColors.primaryText,
      ),
      child: Center(
        child: Text16Normal(
            text: index < 3 ? "next" : "Get started", color: Colors.white),
      ),
    ),
  );
}

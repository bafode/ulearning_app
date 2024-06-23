import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ulearning_app/common/utils/app_colors.dart';
import 'package:ulearning_app/common/widgets/app_shadow.dart';
import 'package:ulearning_app/common/widgets/text_widgets.dart';

class AppButton extends StatelessWidget {
  final double width;
  final double height;
  final String buttonName;
  final bool isLogin;
  final BuildContext? context;
  final void Function()? func;
  const AppButton({
    Key? key,
    this.width = 325,
    this.height = 50,
    this.buttonName = "",
    this.isLogin = true,
    this.context,
    this.func,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: func,
      child: Container(
        width: width.w,
        height: height.h,
        //isLogin true then send primary color else send white color
        decoration: appBoxShadow(
            color: isLogin ? AppColors.primaryElement : Colors.white,
            boxBorder: Border.all(color: AppColors.primaryFourthElementText)),
        child: Center(
            child: Text16Normal(
                text: buttonName,
                color: isLogin
                    ? AppColors.primaryBackground
                    : AppColors.primaryText)),
      ),
    );
  }
}

class FollowButton extends StatelessWidget {
  final double width;
  final double height;
  final String buttonName;
  final bool isFollowing;
  final BuildContext? context;
  final void Function()? func;
  const FollowButton({
    super.key,
    this.width = 90,
    this.height = 27,
    this.buttonName = "",
    this.isFollowing = true,
    this.context,
    this.func,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: func,
      child: Container(
        width: width.w,
        height: height.h,
        //isLogin true then send primary color else send white color
        decoration: appBoxShadow(
            color: isFollowing ? AppColors.primaryElement : Colors.white,
            boxBorder: Border.all(color: AppColors.primaryFourthElementText)),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text16Normal(
                  text: buttonName, color: AppColors.primaryBackground),
              Icon(Icons.add, color: AppColors.primaryBackground, size: 15.w)
            ],
          ),
        ),
      ),
    );
    ;
  }
}

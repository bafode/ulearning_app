import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beehive/common/utils/app_colors.dart';
import 'package:beehive/common/widgets/app_shadow.dart';
import 'package:beehive/common/widgets/text_widgets.dart';

class AppButton extends StatelessWidget {
  final double width;
  final double height;
  final String buttonName;
  final bool isLogin;
  final bool isEnabled;
  final BuildContext? context;
  final void Function()? func;
  const AppButton({
    super.key,
    this.width = 325,
    this.height = 50,
    this.buttonName = "",
    this.isLogin = true,
    this.isEnabled=true,
    this.context,
    this.func,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? func : null, 
      child: Container(
        width: width.w,
        height: height.h,
        //isLogin true then send primary color else send white color
        decoration: appBoxShadow(
            color:  isEnabled
                ? (isLogin ? AppColors.primaryElement : Colors.white)
                : Colors.grey,
            boxBorder: Border.all(color: AppColors.primaryFourthElementText)),
        child: Center(
            child: Text16Normal(
                text: buttonName,
                color:isEnabled? (isLogin
                    ? AppColors.primaryBackground
                    : AppColors.primaryText): AppColors.primaryBackground)),
      ),
    );
  }
}

class AppOutlinedButton extends StatelessWidget {
  final double width;
  final double height;
  final String buttonName;
   final BuildContext? context;
  final void Function()? func;

  const AppOutlinedButton({
    super.key,
    this.width = 325,
    this.height = 50,
    this.buttonName = "",
    this.context,
    this.func,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: func,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.primaryElement),
          borderRadius: BorderRadius.circular(8.0), // Optional corner radius
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 4), // Optional shadow
            ),
          ],
        ),
        child: Center(
          child: Text(
            buttonName,
            style: const TextStyle(
              color:
                  AppColors.primaryElement,
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

class FollowButton extends StatelessWidget {
  final double width;
  final double height;
  final String buttonName;
  final bool isFollowing;
  final void Function()? onTap;

  const FollowButton({
    super.key,
    this.width = 80,
    this.height = 30,
    this.buttonName = "",
    this.isFollowing = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: isFollowing ? Colors.grey[200] : AppColors.primaryElement,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isFollowing ? Colors.grey[400]! : AppColors.primaryElement,
          ),
          boxShadow: [
            if (!isFollowing)
              BoxShadow(
                color: AppColors.primaryElement.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Center(
          child: Text(
            isFollowing? "abonné" : buttonName,
            style: TextStyle(
              color: isFollowing ? AppColors.primaryElement : Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

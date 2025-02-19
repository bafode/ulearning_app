import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beehive/common/utils/app_colors.dart';

class FollowButton extends StatelessWidget {
  final String token;
  final bool isFollowing;
  final VoidCallback onPressed;

  const FollowButton({
    super.key,
    required this.token,
    required this.isFollowing,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(24.w),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
          decoration: BoxDecoration(
            color: isFollowing ? Colors.red : Colors.white,
            borderRadius: BorderRadius.circular(24.w),
            border: Border.all(
              color: isFollowing ? Colors.red : AppColors.primaryElement,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: (isFollowing ? Colors.red : AppColors.primaryElement)
                    .withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isFollowing ? Icons.person_remove_rounded : Icons.person_add_rounded,
                size: 16.w,
                color: isFollowing ? Colors.white : AppColors.primaryElement,
              ),
              SizedBox(width: 4.w),
              Text(
                isFollowing ? "Unfollow" : "Follow",
                style: TextStyle(
                  color: isFollowing ? Colors.white : AppColors.primaryElement,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

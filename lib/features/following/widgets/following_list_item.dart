import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:beehive/common/utils/app_colors.dart';
import 'package:beehive/common/entities/contact/contactResponse/contact_response_entity.dart';
import 'package:beehive/features/following/widgets/user_avatar.dart';
import 'package:beehive/features/following/widgets/follow_button.dart';
import 'package:beehive/features/following/controller.dart';

class FollowingListItem extends GetView<FollowingController> {
  final ContactItem item;

  const FollowingListItem({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      margin: EdgeInsets.symmetric(vertical: 6.h, horizontal: 8.w),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              UserAvatar(
                token: item.token ?? '',
                avatarUrl: item.avatar,
              ),
              SizedBox(width: 16.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 130.w,
                    child: Text(
                      "${item.firstname ?? ""} ${item.lastname ?? ""}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                        color: AppColors.primaryThirdElementText,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
          FollowButton(
            token: item.token ?? "",
            isFollowing: controller.isFollowing(item.token ?? ""),
            onPressed: () => controller.toggleFollow(item.token ?? ""),
          ),
        ],
      ),
    ));
  }
}

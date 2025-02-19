
import 'package:beehive/common/entities/user/user.dart';
import 'package:beehive/common/utils/app_colors.dart';
import 'package:beehive/features/follower/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FollowersList extends GetView<FollowersController> {
  const FollowersList({super.key});

  Widget _buildListItem(User item) {
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
              Hero(
                tag: 'avatar_${item.avatar}',
                child: Container(
                  width: 56.w,
                  height: 56.w,
                  decoration: BoxDecoration(
                    color: AppColors.primarySecondaryBackground,
                    borderRadius: BorderRadius.all(Radius.circular(28.w)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: CachedNetworkImage(
                    imageUrl: Uri.tryParse(item.avatar ?? '')?.isAbsolute == true
                        ? item.avatar!
                        : item.avatar ?? '',
                    height: 56.w,
                    width: 56.w,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(28.w)),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primaryElement,
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(
                      Icons.person,
                      size: 30.w,
                      color: AppColors.primaryElement,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 15.w),
              // Name
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 130.w, // Limit width for long names
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
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => controller.toggleFollow(item.id ?? ""),
              borderRadius: BorderRadius.circular(24.w),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                decoration: BoxDecoration(
                  color: controller.isFollowing(item.id ?? "") 
                      ? Colors.red 
                      : Colors.white,
                  borderRadius: BorderRadius.circular(24.w),
                  border: Border.all(
                    color: controller.isFollowing(item.id ?? "") 
                        ? Colors.red 
                        : AppColors.primaryElement,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (controller.isFollowing(item.id ?? "") 
                          ? Colors.red 
                          : AppColors.primaryElement).withOpacity(0.3),
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
                      controller.isFollowing(item.id ?? "") 
                          ? Icons.person_remove_rounded 
                          : Icons.person_add_rounded,
                      size: 16.w,
                      color: controller.isFollowing(item.id ?? "") 
                          ? Colors.white 
                          : AppColors.primaryElement,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      controller.isFollowing(item.id ?? "") 
                          ? "Unfollow" 
                          : "Follow",
                      style: TextStyle(
                        color: controller.isFollowing(item.id ?? "") 
                            ? Colors.white 
                            : AppColors.primaryElement,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Obx((){
     return CustomScrollView(
        slivers: [
          SliverPadding(padding: EdgeInsets.symmetric(vertical:0.w, horizontal:10.w),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                      (context, index){
                    var item=  controller.state.followerList[index];
                    return _buildListItem(item);
                  },
                  childCount: controller.state.followerList.length
              ),

            ),

          )
        ],
      );
    });
  }
}

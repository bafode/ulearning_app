
import 'package:beehive/common/entities/contact/contactResponse/contact_response_entity.dart';
import 'package:beehive/common/utils/app_colors.dart';
import 'package:beehive/features/follower/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FollowersList extends GetView<FollowersController> {
  const FollowersList({super.key});

 Widget _buildListItem(ContactItem item) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      decoration: BoxDecoration(
        border: const Border(
          bottom: BorderSide(
            width: 1,
            color: AppColors.primarySecondaryBackground,
          ),
        ),
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 6,
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
              // Avatar
              Container(
                width: 52.w,
                height: 52.w,
                decoration: BoxDecoration(
                  color: AppColors.primarySecondaryBackground,
                  borderRadius: BorderRadius.all(Radius.circular(26.w)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    )
                  ],
                ),
                child: CachedNetworkImage(
                  imageUrl: Uri.tryParse(item.avatar ?? '')?.isAbsolute == true
                      ? item.avatar!
                      : item.avatar ?? '',
                  height: 52.w,
                  width: 52.w,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(26.w)),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              // Name
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${item.firstname ?? ""} ${item.lastname ?? ""}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                      color: AppColors.primaryThirdElementText,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Unfollow Button
          GestureDetector(
            onTap: () {
              //controller.unfollow(item.token ?? "");
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(24.w),
                boxShadow: [
                  BoxShadow(
                    color: Colors.redAccent.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: Text(
                "Unfollow",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
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

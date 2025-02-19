import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:beehive/features/following/controller.dart';
import 'package:beehive/features/following/widgets/following_list_item.dart';

class FollowingList extends GetView<FollowingController> {
  const FollowingList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 0.w, horizontal: 10.w),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  var item = controller.state.followingList[index];
                  return FollowingListItem(item: item);
                },
                childCount: controller.state.followingList.length,
              ),
            ),
          )
        ],
      );
    });
  }
}

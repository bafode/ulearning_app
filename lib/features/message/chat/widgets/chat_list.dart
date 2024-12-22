
import 'package:beehive/common/utils/app_colors.dart';
import 'package:beehive/features/message/chat/controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'chat_left_list.dart';
import 'chat_right_list.dart';
class ChatList extends GetView<ChatController> {
  const ChatList({super.key}) ;

  @override
  Widget build(BuildContext context) {
    return Obx(()=> Container(
      color: AppColors.primaryBackground,
      padding: EdgeInsets.only(bottom: 70.h),
      child: GestureDetector(
        child: CustomScrollView(
          controller: controller.myScrollController,
          reverse: true,
          slivers: [

            SliverPadding(
              padding: EdgeInsets.symmetric(
                vertical: 0.w,
                horizontal: 0.w,

              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                    (context, index){

                      var item = controller.state.msgcontentList[index];
                      if(controller.token==item.token){ //user token with msglist token
                        return ChatRightList(item:item);

                      }
                      return ChatLeftList(item:item);
                    },
                  childCount: controller.state.msgcontentList.length
                ),

              ),

            ),
            SliverPadding(padding: EdgeInsets.symmetric(
              vertical: 0.w, horizontal: 0.w
            ),

            sliver: SliverToBoxAdapter(
              child: controller.state.isloading.value?const Align(
                alignment: Alignment.center, child: Text('loading...'),
              ):Container(),
            ),
            )
          ],
        ),
        onTap: (){
          controller.closeAllPop();
        },
      ),
    ));
  }
}


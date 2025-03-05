import 'package:beehive/common/routes/names.dart';
import 'package:beehive/common/utils/app_colors.dart';
import 'package:beehive/features/application/provider/application_nav_notifier.dart';
import 'package:beehive/features/message/chat/widgets/chat_list.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'controller.dart';

class ChatPage extends GetView<ChatController> {
  const ChatPage({super.key});

  AppBar _buildAppBar(){
    return AppBar(
      backgroundColor: AppColors.primaryElement,
      leading: GestureDetector(
        child: Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
          size: 20.sp,
        ),
        onTap: (){
          final container = ProviderContainer();
         container.read(applicationNavNotifierProvider.notifier).changeIndex(2);
          Get.toNamed(AppRoutes.APPLICATION);
        },
      ),
      title:Obx((){
        return Container(
          child: Text(
            "${controller.state.to_firstname??""}  ${controller.state.to_lastname??""}",
            overflow: TextOverflow.clip,
            maxLines: 1,
            style: TextStyle(
              fontFamily: "Avenir",
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 16.sp
            ),
          ),
        );
      }),

      actions: [
        Container(
          margin: EdgeInsets.only(right: 20.w),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Hero(
                tag: 'avatar_${controller.state.to_token.value}',
                child: Container(
                  width: 50.w,
                  height: 50.w,
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
                    imageUrl:
                        Uri.tryParse(controller.state.to_avatar.value ??
                                    '')?.isAbsolute == true
                            ? controller.state.to_avatar.value
                            : controller.state.to_avatar.value ?? '',
                    height: 50.w,
                    width: 50.w,
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
              Positioned(
                bottom: 5.w,
                right: 0.w,
                height: 14.w,
                child: Container(
                  width: 14.w,
                    height: 14.w,
                  decoration: BoxDecoration(
                    color:controller.state.to_online.value=="1"?
                    AppColors.primaryElementStatus:
                        AppColors.primarySecondaryElementText,
                    borderRadius: BorderRadius.circular(12.w),
                    border: Border.all(width: 2, color: AppColors.primaryElementText)
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(),
        body: Obx(()=>SafeArea(
          child: ConstrainedBox(
            constraints: const BoxConstraints.expand(),
            child: Stack(
              children: [
                const ChatList(),
                Positioned(
                  bottom: 0.h,
                  child: Container(

                      width: 360.w,
                      padding: EdgeInsets.only(left: 20.w, bottom: 10.h, right: 20.w),
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //for text fileds and send messages
                          Container(
                            width: 270.w,
                            constraints: BoxConstraints(
                                maxHeight: 220.h,
                                minHeight: 50.h
                            ),
                          //  padding: EdgeInsets.only(top:10.h, bottom: 10.h),
                            decoration: BoxDecoration(
                                borderRadius:  BorderRadius.circular(5.w),
                                color: AppColors.primaryBackground,
                                border: Border.all(color: AppColors.primarySecondaryElementText)
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 220.w,
                                  constraints: BoxConstraints(
                                      maxHeight: 170.h,
                                      minHeight: 30.h
                                  ),
                                  child:  TextField(
                                    controller: controller.myInputController,
                                    maxLines: null,
                                    keyboardType: TextInputType.multiline,
                                    autofocus: false,
                                    decoration: InputDecoration(
                                        hintText: "Message....",
                                        contentPadding: EdgeInsets.only(
                                          left:15.w, top:0, bottom: 0,
                                        ),
                                        border: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.transparent,
                                            )
                                        ),
                                        enabledBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.transparent,
                                            )
                                        ),
                                        disabledBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.transparent,
                                            )
                                        ),
                                        focusedBorder:  const OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.transparent,
                                            )
                                        ),
                                        hintStyle: const TextStyle(
                                            color:AppColors.primarySecondaryElementText
                                        )
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  child: SizedBox(
                                    width: 40.w,
                                    height: 40.w,

                                    child: Image.asset("assets/icons/send.png"),
                                  ),
                                  onTap: (){
                                    //send message
                                    controller.sendMessage();
                                  },
                                )
                              ],
                            ),
                          ),
                          GestureDetector(
                            child: Container(
                              height: 40.w,
                              width: 40.w,

                              padding: EdgeInsets.all(8.w),
                              decoration: BoxDecoration(
                                  color:AppColors.primaryElement,
                                  borderRadius: BorderRadius.circular(40.w),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 2,
                                        offset: const Offset(1, 1)
                                    )
                                  ]
                              ),
                              child: Image.asset("assets/icons/add.png"),
                            ),
                            onTap: (){
                              controller.goMore();
                            },
                          ),

                        ],
                      )
                  ),
                ),
                controller.state.more_status.value?Positioned(
                  right: 20.w,
                  bottom: 70.h,
                  height: 200.h,
                  width: 40.w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        child: Container(
                          height: 40.h,
                          width: 40.h,
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40.w),
                              color: AppColors.primaryBackground,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 2,
                                    offset: const Offset(1, 1)
                                )
                              ]
                          ),
                          child: Image.asset(
                              "assets/icons/file.png"
                          ),
                        ),
                        onTap: (){

                        },
                      ),
                      GestureDetector(
                        child: Container(
                          height: 40.h,
                          width: 40.h,
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40.w),
                              color: AppColors.primaryBackground,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 2,
                                    offset: const Offset(1, 1)
                                )
                              ]
                          ),
                          child: Image.asset(
                              "assets/icons/photo.png"
                          ),
                        ),
                        onTap: (){
                          controller.imgFromGallery();
                        },
                      ),
                      GestureDetector(
                        child: Container(
                          height: 40.h,
                          width: 40.h,
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40.w),
                              color: AppColors.primaryBackground,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 2,
                                    offset: const Offset(1, 1)
                                )
                              ]
                          ),
                          child: Image.asset(
                              "assets/icons/call.png"
                          ),
                        ),
                        onTap: (){
                          controller.audioCall();
                        },
                      ),
                      GestureDetector(
                        child: Container(
                          height: 40.h,
                          width: 40.h,
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40.w),
                              color: AppColors.primaryBackground,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 2,
                                    offset: const Offset(1, 1)
                                )
                              ]
                          ),
                          child: Image.asset(
                              "assets/icons/video.png"
                          ),
                        ),
                        onTap: (){
                          controller.videoCall();
                        },
                      )
                    ],
                  ),
                ):Container()
              ],
            ),
          ),
        )),

    );
  }
}

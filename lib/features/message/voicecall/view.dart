
import 'package:beehive/common/utils/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'controller.dart';

class VoiceCallPage extends GetView<VoiceCallController> {
  const VoiceCallPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBg,
      body: SafeArea(
      top: false,
        bottom: false,
        child: Obx(() {
          return Stack(children: [
              Positioned(
                  top: 10.h,
                  left: 30.w,
                  right: 30.w,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 6.h),
                          child: Text(
                            controller.state.callTime.value,
                            style: TextStyle(
                              color: AppColors.primaryElementText,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        Container(
                          width: 70.w,
                          height: 70.w,
                          margin: EdgeInsets.only(top: 150.h),
                          padding: EdgeInsets.all(0.w),
                          decoration: BoxDecoration(
                            color: AppColors.primaryElementText,
                            borderRadius:
                            BorderRadius.all(Radius.circular(10.w)),
                          ),
                          child: CachedNetworkImage(
                          imageUrl:
                              Uri.tryParse(
                                          controller.state.to_avatar.value )?.isAbsolute ==
                                      true
                                  ? controller.state.to_avatar.value
                                  : controller.state.to_avatar.value,
                          height: 50.w,
                          width: 50.w,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(28.w)),
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
                        Container(
                          margin: EdgeInsets.only(top: 6.h),
                          child: Text(
                            "${controller.state.to_firstname.value??""}"" ${controller.state.to_lastname.value??""}",
                            style: TextStyle(
                              color: AppColors.primaryElementText,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        )
                      ])),
              Positioned(
                  bottom: 80.h,
                  left: 30.w,
                  right: 30.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          GestureDetector(
                             onTap: controller.state.isJoined.value
                                  ? controller.switchMicrophone
                                  : null,
                            child: Container(
                                width: 60.w,
                                height: 60.w,
                                padding: EdgeInsets.all(15.w),
                                decoration: BoxDecoration(
                                  color: controller.state.openMicrophone.value
                                      ? AppColors.primaryElementText
                                      : AppColors.primaryText,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(30.w)),
                                ),
                                child: controller.state.openMicrophone.value
                                    ? Image.asset(
                                    "assets/icons/b_microphone.png")
                                    : Image.asset(
                                    "assets/icons/a_microphone.png"))
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10.h),
                            child: Text(
                              "Microphone",
                              style: TextStyle(
                                color: AppColors.primaryElementText,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          )
                        ],
                      ),
                      Column(children: [
                        GestureDetector(
                           onTap: controller.state.isJoined.value
                              ? controller.leaveChannel
                              : controller.joinChannel,
                          child: Container(
                            width: 60.w,
                            height: 60.w,
                            padding: EdgeInsets.all(15.w),
                            decoration: BoxDecoration(
                              color: controller.state.isJoined.value
                                  ? AppColors.primaryElementBg
                                  : AppColors.primaryElementStatus,
                              borderRadius:
                              BorderRadius.all(Radius.circular(30.w)),
                            ),
                            child: controller.state.isJoined.value
                                ? Image.asset("assets/icons/a_phone.png")
                                : Image.asset("assets/icons/a_telephone.png"),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10.h),
                          child: Text(
                            controller.state.isJoined.value
                                ? "Disconnect"
                                : "Connected",
                            style: TextStyle(
                              color: AppColors.primaryElementText,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ]),
                      Column(children: [
                        GestureDetector(
                          onTap: controller.state.isJoined.value
                              ? controller.switchSpeakerphone
                              : null,
                          child: Container(
                            width: 60.w,
                            height: 60.w,
                            padding: EdgeInsets.all(15.w),
                            decoration: BoxDecoration(
                              color: controller.state.enableSpeakerphone.value
                                  ? AppColors.primaryElementText
                                  : AppColors.primaryText,
                              borderRadius:
                              BorderRadius.all(Radius.circular(30.w)),
                            ),
                            child: controller.state.enableSpeakerphone.value
                                ? Image.asset("assets/icons/b_trumpet.png")
                                : Image.asset("assets/icons/a_trumpet.png"),
                          ),
                          
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10.h),
                          child: Text(
                            "Speakerphone",
                            style: TextStyle(
                              color: AppColors.primaryElementText,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        )
                      ]),
                    ],
                  ))
            ]
          );
        }),
      ),
    );
  }
}

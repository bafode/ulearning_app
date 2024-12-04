import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ulearning_app/common/utils/app_colors.dart';
import 'package:ulearning_app/features/message/voicecall/notifiers/voicecall_notifier.dart';
import 'package:ulearning_app/features/message/voicecall/voice_logic.dart';
class VoiceCall extends ConsumerStatefulWidget {
  const VoiceCall({super.key});

  @override
  ConsumerState<VoiceCall> createState() => _VoiceCallPage();
}

class _VoiceCallPage extends ConsumerState<VoiceCall> {
  late VoiceLogic voiceLogic;
  @override
  void initState() {
    super.initState();
    voiceLogic = VoiceLogic(ref: ref);
    Future.delayed(Duration.zero,(){
      voiceLogic.init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(voiceCallProvider);
          return WillPopScope(
              child:Scaffold(
              backgroundColor: AppColors.primaryBackground,
              body: SafeArea(
                  child: Container(
                color: AppColors.primaryElement,
                child: Stack(children: [
                  Positioned(
                      top: 0.h,
                      left: 0.w,
                      right: 0.w,
                      bottom: 130.h,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primaryBackground,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(40.h),
                              bottomRight: Radius.circular(40.h)),
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 6.h),
                                child: Text(
                                  state.callTime,
                                  style: TextStyle(
                                    color: AppColors.primaryText,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                              Container(
                                width: 100.w,
                                height: 100.w,
                                margin: EdgeInsets.only(top: 150.h),
                                padding: EdgeInsets.all(15.w),
                                decoration: BoxDecoration(
                                  image: const DecorationImage(
                                    image:
                                        AssetImage('assets/icons/element.png'),
                                    fit: BoxFit.fill,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.w)),
                                ),
                                child: Image.network(
                                  state.toAvatar,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 15.h),
                                child: Text(
                                  state.toName,
                                  style: TextStyle(
                                    color: AppColors.primaryText,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ]),
                      )),
                  Positioned(
                      bottom: 20.h,
                      left: 30.w,
                      right: 30.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              GestureDetector(
                                onTap: state.isJoined
                                    ? voiceLogic
                                        .switchMicrophone
                                    : null,
                                child: Container(
                                    width: 50.w,
                                    height: 50.w,
                                    padding: EdgeInsets.all(10.w),
                                    decoration: BoxDecoration(
                                      color: state.openMicrophone
                                          ? AppColors.primaryElementText
                                          : AppColors.primaryText,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.w)),
                                    ),
                                    child: state.openMicrophone
                                        ? Image.asset(
                                            "assets/icons/b_microphone.png")
                                        : Image.asset(
                                            "assets/icons/a_microphone.png")),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5.h),
                                child: Text(
                                  "Microphone",
                                  style: TextStyle(
                                    color: AppColors.primaryElementText,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              )
                            ],
                          ),
                          Column(children: [
                            GestureDetector(
                              child: Container(
                                width: 50.w,
                                height: 50.w,
                                padding: EdgeInsets.all(10.w),
                                decoration: BoxDecoration(
                                  color: state.isJoined
                                      ? AppColors.primaryElementBg
                                      : AppColors.primaryElementStatus,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.w)),
                                ),
                                child: state.isJoined
                                    ? Image.asset("assets/icons/a_phone.png")
                                    : Image.asset(
                                        "assets/icons/a_telephone.png"),
                              ),
                              onTap: (){
                                if(state.isJoined){
                                  voiceLogic.leaveChannel(true);
                                }
                              },
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 5.h),
                              child: Text(
                                state.isJoined ? "Disconnect" : "Connected",
                                style: TextStyle(
                                  color: AppColors.primaryElementText,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ]),
                          Column(children: [
                            GestureDetector(
                              onTap: state.isJoined
                                  ? voiceLogic.switchSpeakerphone
                                  : null,
                              child: Container(
                                width: 50.w,
                                height: 50.w,
                                padding: EdgeInsets.all(10.w),
                                decoration: BoxDecoration(
                                  color: state.enableSpeakerphone
                                      ? AppColors.primaryElementText
                                      : AppColors.primaryText,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.w)),
                                ),
                                child: state.enableSpeakerphone
                                    ? Image.asset("assets/icons/bo_trumpet.png")
                                    : Image.asset("assets/icons/a_trumpet.png"),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 5.h),
                              child: Text(
                                "Speakerphone",
                                style: TextStyle(
                                  color: AppColors.primaryElementText,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            )
                          ]),
                        ],
                      ))
                ]),
              ))),
            onWillPop: () async {
                print("onWillPop----");
              return false;
            },
          );

  }
}

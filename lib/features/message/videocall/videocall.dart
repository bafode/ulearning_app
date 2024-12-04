import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ulearning_app/common/utils/app_colors.dart';
import 'package:ulearning_app/features/message/videocall/notifiers/videocall_notifier.dart';
import 'package:ulearning_app/features/message/videocall/video_logic.dart';

class VideoCall extends ConsumerStatefulWidget {
  const VideoCall({super.key});

  @override
  ConsumerState<VideoCall> createState() => _VideoCallPage();
}

class _VideoCallPage extends ConsumerState<VideoCall> {
  late VideoLogic videoLogic;
  @override
  void initState() {
    super.initState();
    videoLogic = VideoLogic(ref: ref);
    Future.delayed(Duration.zero,(){
      videoLogic.init();
    });
  }


  @override
  Widget build(BuildContext context) {
    final state = ref.watch(videoCallProvider);
          return WillPopScope(
              child:Scaffold(
              backgroundColor: AppColors.primaryBg,
              body:SafeArea(
                  child:Container(
                      child: state.isJoined?Stack(
                        children: [
                          state.remoteUid==0?Container():AgoraVideoView(
                            controller: VideoViewController.remote(
                              rtcEngine: videoLogic.engine,
                              canvas: VideoCanvas(uid: state.remoteUid),
                              connection: RtcConnection(channelId: state.channelId),
                            ),
                          ),
                          Positioned(
                            top: 30.h,
                            right: 15.w,
                            child: SizedBox(
                              width: 80.w,
                              height: 120.w,
                              child: AgoraVideoView(
                                controller: VideoViewController(
                                  rtcEngine: videoLogic.engine,
                                  canvas: const VideoCanvas(uid: 0),
                                ),
                              ),
                            ),
                          ),
                          state.isShowAvatar?Container():Positioned(
                              top: 10.h,
                              left: 30.w,
                              right: 30.w,
                              child:Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top:6.h),
                                      child: Text(state.callTime,
                                        style: TextStyle(
                                          color: AppColors.primaryElementText,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.normal,
                                        ),),),
                                  ])),
                          state.isShowAvatar?Positioned(
                              top: 10.h,
                              left: 30.w,
                              right: 30.w,
                              child:Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top:6.h),
                                      child: Text(state.callTime,
                                        style: TextStyle(
                                          color: AppColors.primaryElementText,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.normal,
                                        ),),),
                                    Container(
                                      width: 70.w,
                                      height: 70.w,
                                      margin: EdgeInsets.only(top:150.h),
                                      padding: EdgeInsets.all(0.w),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryElementText,
                                        borderRadius: BorderRadius.all(Radius.circular(10.w)),
                                      ),
                                      child: Image.network(state.toAvatar,fit: BoxFit.fill,),),
                                    Container(
                                      margin: EdgeInsets.only(top:6.h),
                                      child: Text(state.toName,
                                        style: TextStyle(
                                          color: AppColors.primaryElementText,
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.normal,
                                        ),),)
                                  ])):Container(),
                          Positioned(
                              bottom: 80.h,
                              left: 30.w,
                              right: 30.w,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Column(children: [
                                    GestureDetector(child: Container(
                                      width: 50.w,
                                      height: 50.w,
                                      padding: EdgeInsets.all(10.w),
                                      decoration: BoxDecoration(
                                        color: state.isJoined ? AppColors.primaryElementBg:AppColors.primaryElementStatus,
                                        borderRadius: BorderRadius.all(Radius.circular(15.w)),
                                      ),
                                      child: state.isJoined ?Image.asset("assets/icons/a_phone.png"):Image.asset("assets/icons/a_telephone.png"),
                                    ),
                                      onTap: (){
                                        if(state.isJoined){
                                          videoLogic.leaveChannel(true);
                                        }
                                      },
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top:10.h),
                                      child: Text(state.isJoined?"Disconnect":"Connected",style: TextStyle(
                                        color: AppColors.primaryElementText,
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.normal,
                                      ),),),
                                  ]),
                                  Column(children: [
                                    GestureDetector(onTap: videoLogic.switchCamera,child: Container(
                                      width: 50.w,
                                      height: 50.w,
                                      padding: EdgeInsets.all(10.w),
                                      decoration: BoxDecoration(
                                        color: state.switchCameras?AppColors.primaryElementText:AppColors.primaryText,
                                        borderRadius: BorderRadius.all(Radius.circular(15.w)),
                                      ),
                                      child: state.switchCameras?Image.asset("assets/icons/b_photo.png"):Image.asset("assets/icons/a_photo.png"),
                                    ),),
                                    Container(
                                      margin: EdgeInsets.only(top:10.h),
                                      child: Text("switchCamera",style: TextStyle(
                                        color: AppColors.primaryElementText,
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.normal,
                                      ),),)
                                  ]),
                                ],))
                        ],
                      ):Container()
                  )
              )
          ), onWillPop: () async {
            print("onWillPop----");
            return false;
          },
          );

  }
}

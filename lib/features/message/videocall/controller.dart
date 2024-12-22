import 'dart:async';
import 'dart:convert';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:beehive/common/api/chat.dart';
import 'package:beehive/common/models/entities.dart';
import 'package:beehive/common/utils/constants.dart';
import 'package:beehive/features/message/videocall/index.dart';
import 'package:beehive/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoCallController extends GetxController {
  VideoCallController();

  final state = VideoCallState();
  final player = AudioPlayer();
  String appId = AppConstants.APPID;
  final db = FirebaseFirestore.instance;
  final profile_token = Global.storageService.getUserProfile().id;
  late final RtcEngine engine;

  int call_s = 0;
  int call_m = 0;
  int call_h = 0;
  late final Timer callTimer;

  ChannelProfileType channelProfileType =
      ChannelProfileType.channelProfileCommunication;

  @override
  void onInit() {
    super.onInit();
    var data = Get.parameters;
    state.to_firstname.value = data["to_firstname"] ?? "";
    state.to_lastname.value = data["to_lastname"] ?? "";
    state.to_avatar.value = data["to_avatar"] ?? "";
    state.call_role.value = data["call_role"] ?? "";
    state.doc_id.value = data["doc_id"] ?? "";
    state.to_token.value = data['to_token'] ?? "";
    print("...your name id ${state.to_firstname.value}");

    initEngine();
  }

  Future<void> initEngine() async {
    await player.setAsset("assets/voice/Sound_Horizon.mp3");

    engine = createAgoraRtcEngine();
    await engine.initialize(RtcEngineContext(
      appId: appId,
    ));

    engine.registerEventHandler(RtcEngineEventHandler(
        onError: (ErrorCodeType err, String msg) {
      print('[....onError] err: $err, ,msg:$msg');
    }, onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
      print('....onConnection ${connection.toJson()}');
      state.isJoined.value = true;
    }, onUserJoined:
            (RtcConnection connection, int remoteUid, int elasped) async {
      state.onRemoteUID.value = remoteUid;
      //since the other user joined, don't show the avatar anymore
      state.isShowAvatar.value = false;
      await player.pause();
      callTime();
    }, onLeaveChannel: (RtcConnection connection, RtcStats stats) {
      print('...user left the room...');
      state.isJoined.value = false;
      state.onRemoteUID.value = 0;
      state.isShowAvatar.value = true;
    }, onRtcStats: (RtcConnection connection, RtcStats stats) {
      print("time....");
      print(stats.duration);
    }));

    await engine.enableVideo();
    await engine.setVideoEncoderConfiguration(const VideoEncoderConfiguration(
      dimensions: VideoDimensions(width: 640, height: 360),
      frameRate: 15,
      bitrate: 0,
    ));
    await engine.startPreview();
    state.isReadyPreview.value = true;
    await joinChannel();
    if (state.call_role == "anchor") {
      // send notifcation to the other user
      await sendNotification("video");
      await player.play();
    }
  }

  void callTime() {
    callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      call_s = call_s + 1;
      if (call_s >= 60) {
        call_s = 0;
        call_m = call_m + 1;
      }
      if (call_m >= 60) {
        call_m = 0;
        call_h = call_h + 1;
      }
      //  01:20:59 following basic time format
      var h = call_h < 10 ? "0$call_h" : "$call_h";
      var m = call_m < 10 ? "0$call_m" : "$call_m";
      var s = call_s < 10 ? "0$call_s" : "$call_s";
      if (call_h == 0) {
        state.callTime.value = "$m:$s";
        state.callTimeNum.value = "$call_m m and $call_s s";
      } else {
        state.callTime.value = "$h:$m:$s";
        state.callTimeNum.value = "$call_h h $call_m m and $call_s s";
      }
    });
  }

  Future<void> sendNotification(String callType) async {
    CallRequestEntity callRequestEntity = CallRequestEntity();
    callRequestEntity.call_type = callType;
    callRequestEntity.to_token = state.to_token.value;
    callRequestEntity.to_avatar = state.to_avatar.value;
    callRequestEntity.doc_id = state.doc_id.value;
    callRequestEntity.to_firstname = state.to_firstname.value;
    callRequestEntity.to_lastname = state.to_lastname.value;
    print("...the other user's token is ${state.to_token.value}");

    var res = await ChatAPI.call_notifications(params: callRequestEntity);
    if (res.code == 0) {
      print("notification success");
    } else
      print("could not send notification");
  }

  Future<String> getToken() async {
    if (state.call_role == "anchor") {
      state.channelId.value = //12              //13
          md5
              .convert(utf8.encode("${profile_token}_${state.to_token}"))
              .toString();
    } else {
      state.channelId.value = //12               //13
          md5
              .convert(utf8.encode("${state.to_token}_$profile_token"))
              .toString();
    }

    CallTokenRequestEntity callTokenRequestEntity = CallTokenRequestEntity();
    callTokenRequestEntity.channel_name = state.channelId.value;
    print("...channel id is ${state.channelId.value}");
    print("...my access token is ");
    var res = await ChatAPI.call_token(params: callTokenRequestEntity);
    if (res.code == 0) {
      return res.data!;
    } else {
      print("my data is ${res.data}");
      return res.data!;
    }
  }

  Future<void> requestPermissions() async {
    // Demande initiale des permissions
    var permissions =
        await [Permission.microphone, Permission.camera].request();

    // Vérifie si le microphone est accordé
    if (permissions[Permission.microphone] != PermissionStatus.granted) {
      var microphoneStatus = await Permission.microphone.request();
      if (microphoneStatus != PermissionStatus.granted) {
        EasyLoading.dismiss();
        Get.back();
        return;
      }
    }

    // Vérifie si la caméra est accordée
    if (permissions[Permission.camera] != PermissionStatus.granted) {
      var cameraStatus = await Permission.camera.request();
      if (cameraStatus != PermissionStatus.granted) {
        EasyLoading.dismiss();
        Get.back();
        return;
      }
    }

    // Les permissions sont accordées
    EasyLoading.showSuccess('Permissions accordées');
  }

  Future<void> joinChannel() async {
    requestPermissions();
    EasyLoading.show(
        indicator: const CircularProgressIndicator(),
        maskType: EasyLoadingMaskType.clear,
        dismissOnTap: true);

    String token = await getToken();
    if (token.isEmpty) {
      EasyLoading.dismiss();
      Get.back();
      return;
    }

    await engine.joinChannel(
        token: token,
        channelId: state.channelId.value,
        uid: 0,
        options: ChannelMediaOptions(
            channelProfile: channelProfileType,
            clientRoleType: ClientRoleType.clientRoleBroadcaster));
    EasyLoading.dismiss();
  }

  Future<void> leaveChannel() async {
    EasyLoading.show(
        indicator: const CircularProgressIndicator(),
        maskType: EasyLoadingMaskType.clear,
        dismissOnTap: true);
    await player.pause();
    await sendNotification("cancel");
    state.isJoined.value = false;
    state.switchCamera.value = true;

    EasyLoading.dismiss();
    Get.back();
  }

  Future<void> switchCamera() async {
    await engine.switchCamera();
    state.switchCamera.value = !state.switchCamera.value;
  }

  Future<void> addCallTime() async {
    var profile = Global.storageService.getUserProfile();
    var msgData = ChatCall(
        from_token: profile.id,
        to_token: state.to_token.value,
        from_firstname: profile.firstname,
        to_firstname: state.to_firstname.value,
        from_lastname: profile.lastname,
        to_lastname: state.to_lastname.value,
        from_avatar: profile.avatar,
        to_avatar: state.to_avatar.value,
        call_time: state.callTimeNum.value,
        type: "video",
        last_time: Timestamp.now());

    await db
        .collection("chatcall")
        .withConverter(
            fromFirestore: ChatCall.fromFirestore,
            toFirestore: (ChatCall msg, options) => msg.toFirestore())
        .add(msgData);
    String sendContent = "Call time ${state.callTimeNum.value}【video】";
    saveMessage(sendContent);
  }

  saveMessage(String sendContent) async {
    if (state.doc_id.value.isEmpty) {
      return;
    }
    final content = Msgcontent(
        token: profile_token,
        content: sendContent,
        type: "text",
        addtime: Timestamp.now());

    await db
        .collection("message")
        .doc(state.doc_id.value)
        .collection("msglist")
        .withConverter(
            fromFirestore: Msgcontent.fromFirestore,
            toFirestore: (Msgcontent msgContent, options) =>
                msgContent.toFirestore())
        .add(content);
    var messageRes = await db
        .collection("message")
        .doc(state.doc_id.value)
        .withConverter(
        fromFirestore: Msg.fromFirestore,
        toFirestore: (Msg msgContent, options) =>
            msgContent.toFirestore())
        .get();
    if(messageRes.data()!=null){
      var item = messageRes.data()!;
      int toMsgNum = item.to_msg_num==null?0:item.to_msg_num!;
      int fromMsgNum = item.from_msg_num==null?0:item.from_msg_num!;
      if(item.from_token==profile_token){
        fromMsgNum = fromMsgNum + 1;
      }else{
        toMsgNum = toMsgNum + 1;
      }

      await db.collection("message").doc(state.doc_id.value).update({
        "to_msg_num":toMsgNum,
        "from_msg_num":fromMsgNum,
        "last_msg":sendContent, "last_time":Timestamp.now()
      });
    }
  }

  Future<void> _dispose() async {
    if (state.call_role == "anchor") {
      addCallTime();
    }
    await player.pause();
    await engine.leaveChannel();
    await engine.release();
    await player.stop();
  }

  @override
  void onClose() {
    _dispose();
    super.onClose();
  }
}

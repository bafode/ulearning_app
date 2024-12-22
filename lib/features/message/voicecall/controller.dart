import 'dart:async';
import 'dart:convert';
import 'package:beehive/common/api/chat.dart';
import 'package:beehive/common/models/entities.dart';
import 'package:beehive/common/utils/constants.dart';
import 'package:beehive/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:just_audio/just_audio.dart';
import 'state.dart';

class VoiceCallController extends GetxController {
  final VoiceCallState state = VoiceCallState();
  final player = AudioPlayer();
  String appId = AppConstants.APPID;
  String title = "Voice Call";
  final db = FirebaseFirestore.instance;
  final profile_token = Global.storageService.getUserProfile().id;
  late final RtcEngine engine;

  late final Timer calltimer;
  int call_m = 0;
  int call_s = 0;
  int call_h = 0;
  bool is_calltimer = false;
  // 两个人聊天
  ChannelProfileType channelProfileType =
      ChannelProfileType.channelProfileCommunication;

  Future<void> _dispose() async {
    if (is_calltimer) {
      calltimer.cancel();
    }
    if (state.call_role == "anchor") {
      addCallTime();
    }
    await player.pause();
    await engine.leaveChannel();
    await engine.release();
    await player.stop();
  }

  Future<void> _initEngine() async {
    await player.setAsset("assets/voice/Sound_Horizon.mp3");
    engine = createAgoraRtcEngine();
    await engine.initialize(RtcEngineContext(
      appId: appId,
    ));

    engine.registerEventHandler(RtcEngineEventHandler(
      onError: (ErrorCodeType err, String msg) {
        print('[onError] err: $err, msg: $msg');
      },
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        print(
            '[onJoinChannelSuccess] connection: ${connection.toJson()} elapsed: $elapsed');
        state.isJoined.value = true;
      },
      onLeaveChannel: (RtcConnection connection, RtcStats stats) {
        print(
            '[onLeaveChannel] connection: ${connection.toJson()} stats: ${stats.toJson()}');
        state.isJoined.value = false;
      },
      onUserJoined:
          (RtcConnection connection, int remoteUid, int elapsed) async {
        await player.pause();
        if (state.call_role == "anchor") {
          callTime();
          is_calltimer = true;
        }
      },
      onRtcStats: (RtcConnection connection, RtcStats stats) {
        print("time----- ");
        print(stats.duration);
      },
      onUserOffline: (RtcConnection connection, int remoteUid,
          UserOfflineReasonType reason) {
        print("---onUserOffline----- ");
      },
    ));

    await engine.enableAudio();
    await engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await engine.setAudioProfile(
      profile: AudioProfileType.audioProfileDefault,
      scenario: AudioScenarioType.audioScenarioGameStreaming,
    );
    // is anchor joinChannel
    await joinChannel();
    if (state.call_role == "anchor") {
      await sendNotifications("voice");
      await player.play();
    }
  }

  callTime() async {
    calltimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      call_s = call_s + 1;
      if (call_s >= 60) {
        call_s = 0;
        call_m = call_m + 1;
      }
      if (call_m >= 60) {
        call_m = 0;
        call_h = call_h + 1;
      }
      var h = call_h < 10 ? "0$call_h" : "$call_h";
      var m = call_m < 10 ? "0$call_m" : "$call_m";
      var s = call_s < 10 ? "0$call_s" : "$call_s";

      if (call_h == 0) {
        state.callTime.value = "$m:$s";
        state.callStatus.value = "$call_m m and $call_s s";
      } else {
        state.callTime.value = "$h:$m:$s";
        state.callStatus.value = "$call_h h $call_m m and $call_s s";
      }
    });
  }

  Future<String> getToken() async {
    if (state.call_role == "anchor") {
      state.channelId.value = md5
          .convert(utf8.encode("${profile_token}_${state.to_token}"))
          .toString();
    } else {
      state.channelId.value = md5
          .convert(utf8.encode("${state.to_token}_$profile_token"))
          .toString();
    }
    CallTokenRequestEntity callTokenRequestEntity = CallTokenRequestEntity();
    callTokenRequestEntity.channel_name = state.channelId.value;
    var res = await ChatAPI.call_token(params: callTokenRequestEntity);
    if (res.code == 0) {
      return res.data!;
    }
    return "";
  }

  addCallTime() async {
    var profile = Global.storageService.getUserProfile();
    var msgdata = ChatCall(
      from_token: profile.id,
      to_token: state.to_token.value,
      from_firstname: profile.firstname,
      from_lastname: profile.lastname,
      to_firstname: state.to_firstname.value,
      to_lastname: state.to_lastname.value,
      from_avatar: profile.avatar,
      to_avatar: state.to_avatar.value,
      call_time: state.callStatus.value,
      type: "voice",
      last_time: Timestamp.now(),
    );
    var docRes = await db
        .collection("chatcall")
        .withConverter(
          fromFirestore: ChatCall.fromFirestore,
          toFirestore: (ChatCall msg, options) => msg.toFirestore(),
        )
        .add(msgdata);
    String sendcontent = "Call time ${state.callTime.value} 【voice】";
    sendMessage(sendcontent);
  }

  sendMessage(String sendcontent) async {
    if (state.doc_id.value.isEmpty) {
      return;
    }
    final content = Msgcontent(
      token: profile_token,
      content: sendcontent,
      type: "text",
      addtime: Timestamp.now(),
    );

    await db
        .collection("message")
        .doc(state.doc_id.value)
        .collection("msglist")
        .withConverter(
          fromFirestore: Msgcontent.fromFirestore,
          toFirestore: (Msgcontent msgcontent, options) =>
              msgcontent.toFirestore(),
        )
        .add(content);
    var messageRes = await db
        .collection("message")
        .doc(state.doc_id.value)
        .withConverter(
          fromFirestore: Msg.fromFirestore,
          toFirestore: (Msg msg, options) => msg.toFirestore(),
        )
        .get();
    if (messageRes.data() != null) {
      var item = messageRes.data()!;
      int toMsgNum = item.to_msg_num == null ? 0 : item.to_msg_num!;
      int fromMsgNum = item.from_msg_num == null ? 0 : item.from_msg_num!;
      if (item.from_token == profile_token) {
        fromMsgNum = fromMsgNum + 1;
      } else {
        toMsgNum = toMsgNum + 1;
      }
      await db.collection("message").doc(state.doc_id.value).update({
        "to_msg_num": toMsgNum,
        "from_msg_num": fromMsgNum,
        "last_msg": sendcontent,
        "last_time": Timestamp.now()
      });
    }
  }

  joinChannel() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      status = await Permission.microphone.request();
      if (!status.isGranted) {
        EasyLoading.dismiss();
        Get.back();
        return;
      }
    }

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
    try {
      print("channelId: ${state.channelId.value}");

      await engine.joinChannel(
        token: token,
        channelId: state.channelId.value,
        uid: 0,
        options: ChannelMediaOptions(
          channelProfile: channelProfileType,
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
        ),
      );
    } catch (e) {
      print('Error while joining channel: $e');
    }
    if (state.call_role == "audience") {
      callTime();
      is_calltimer = true;
    }
    EasyLoading.dismiss();
  }

  // send notification
  sendNotifications(String callType) async {
    CallRequestEntity callRequestEntity = CallRequestEntity();
    callRequestEntity.call_type = callType;
    callRequestEntity.to_token = state.to_token.value;
    callRequestEntity.to_avatar = state.to_avatar.value;
    callRequestEntity.doc_id = state.doc_id.value;
    callRequestEntity.to_firstname = state.to_firstname.value;
    callRequestEntity.to_lastname = state.to_lastname.value;
    var res = await ChatAPI.call_notifications(params: callRequestEntity);
    print(res);
    if (res.code == 0) {
      print("sendNotifications success");
    } else {
      // Get.snackbar("Tips", "Notification error!");
      // Get.offAllNamed(AppRoutes.Message);
    }
  }

  leaveChannel() async {
    EasyLoading.show(
        indicator: const CircularProgressIndicator(),
        maskType: EasyLoadingMaskType.clear,
        dismissOnTap: true);
    await player.pause();
    await sendNotifications("cancel");
    //await engine.leaveChannel();
    state.isJoined.value = false;
    state.openMicrophone.value = true;
    state.enableSpeakerphone.value = true;
    EasyLoading.dismiss();
    if (Get.isSnackbarOpen) {
      Get.closeAllSnackbars();
    }
    Get.back();
  }

  switchMicrophone() async {
    await engine.enableLocalAudio(!state.openMicrophone.value);
    state.openMicrophone.value = !state.openMicrophone.value;
  }

  switchSpeakerphone() async {
    await engine.setEnableSpeakerphone(!state.enableSpeakerphone.value);
    state.enableSpeakerphone.value = !state.enableSpeakerphone.value;
  }

  @override
  void onInit() {
    super.onInit();
    var data = Get.parameters;
    print(data);
    state.to_token.value = data["to_token"] ?? "";
    state.to_firstname.value = data["to_firstname"] ?? "";
    state.to_lastname.value = data["to_lastname"] ?? "";
    state.to_avatar.value = data["to_avatar"] ?? "";
    state.call_role.value = data["call_role"] ?? "";
    state.doc_id.value = data["doc_id"] ?? "";
    _initEngine();
  }

  @override
  void onClose() {
    super.onClose();
    _dispose();
  }

  @override
  void dispose() {
    super.dispose();
    _dispose();
  }
}

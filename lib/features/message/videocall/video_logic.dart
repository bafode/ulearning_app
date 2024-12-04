import 'dart:async';
import 'dart:convert';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ulearning_app/common/api/chat.dart';
import 'package:ulearning_app/common/entities/user/user.dart';
import 'package:ulearning_app/common/models/chat.dart';
import 'package:ulearning_app/common/models/chatcall.dart';
import 'package:ulearning_app/common/models/entities.dart';
import 'package:ulearning_app/common/utils/constants.dart';
import 'package:ulearning_app/features/message/videocall/notifiers/videocall_notifier.dart';
import 'package:ulearning_app/global.dart';
import 'package:ulearning_app/security.dart';

class VideoLogic {
  final WidgetRef ref;
  final db = FirebaseFirestore.instance;
  User userProfile = Global.storageService.getUserProfile();
  final player = AudioPlayer();
  String appId = AppConstants.APPID;
  late final RtcEngine engine;
  late final Timer calltimer;
  int call_m = 0;
  int call_s = 0;
  int call_h = 0;
  bool is_calltimer = false;
  ChannelProfileType channelProfileType =
      ChannelProfileType.channelProfileCommunication;
  String channel_name = "";
  String _callRole = "";
  String _toToken = "";
  String _toName = "";
  String _toAvatar = "";
  String _docId = "";
  String _callTimeNum = "not connected";


  VideoLogic({
    required this.ref,
  });

  void init() async{
    print("---init----- ");
    final data = ModalRoute.of(ref.context)!.settings.arguments as Map;
    ref.read(videoCallProvider.notifier).onUserInfoChanged(UserInfoChanged(data["to_avatar"] ?? "", data["to_name"] ?? ""));
    print("call_role----->${data["call_role"]}");
    _callRole = data["call_role"];
    _toToken = data["to_token"] ?? "";
    _docId = data["doc_id"] ?? "";
    _callRole = data["call_role"];
    _toName = data["to_name"];
    _toAvatar = data["to_avatar"];
    bool microphoneStatus = await request_permission(Permission.microphone);
    bool cameraStatus = await request_permission(Permission.camera);
    if(microphoneStatus && cameraStatus){
      _initEngine();
    }else{
      Navigator.of(ref.context).pop();
    }
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
        print('[onJoinChannelSuccess] connection: ${connection.toJson()} elapsed: $elapsed');
        ref.read(videoCallProvider.notifier).onIsJoinedChanged(const IsJoinedChanged(true));
      },
      onLeaveChannel: (RtcConnection connection, RtcStats stats) {
        print('[onLeaveChannel] connection: ${connection.toJson()} stats: ${stats.toJson()}');
      },
      onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) async {
        print("onUserJoined----->$remoteUid");
        ref.read(videoCallProvider.notifier).onRemoteUidChanged(RemoteUidChanged(remoteUid));
        ref.read(videoCallProvider.notifier).onIsShowAvatarChanged(const IsShowAvatarChanged(false));
        await player.pause();
        if (_callRole == "anchor") {
          _callTime();
          is_calltimer = true;
        }
      },
      onRtcStats: (RtcConnection connection, RtcStats stats) {
        // print("time----- ");
        // print(stats.duration);
      },
      onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
        print("onUserOffline----->$remoteUid");
        leaveChannel(false);
      },
    ));

    await engine.enableVideo();
    await engine.setVideoEncoderConfiguration(
      const VideoEncoderConfiguration(
        dimensions: VideoDimensions(width: 640, height: 360),
        frameRate: 15,
        bitrate: 0,
      ),
    );
    await engine.startPreview();
    await joinChannel();
    ref.read(videoCallProvider.notifier).onIsReadyPreviewChanged(const IsReadyPreviewChanged(true));
    print("callRole----->$_callRole");
    if (_callRole == "anchor") {
      await _sendNotifications("video");
      await player.play();
    }
  }

  _callTime() async {
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
        ref.read(videoCallProvider.notifier).onCallTimeChanged(CallTimeChanged("$m:$s"));
        _callTimeNum = "$call_m m and $call_s s";
      } else {
        ref.read(videoCallProvider.notifier).onCallTimeChanged(CallTimeChanged("$h:$m:$s"));
        _callTimeNum = "$call_h h $call_m m and $call_s s";
      }
    });
  }

  Future<String> _getToken() async {
    String callToken = "";
    String toToken = "";
    if (_callRole == "anchor") {
      callToken = md5
          .convert(utf8.encode("${userProfile.id}_$_toToken"))
          .toString();
      toToken = _toToken;
    } else {
      callToken = md5
          .convert(utf8.encode("${_toToken}_${userProfile.id}"))
          .toString();
      toToken = "${userProfile.id}";
    }
    CallTokenRequestEntity callTokenRequestEntity =
    CallTokenRequestEntity();
    callTokenRequestEntity.call_token = callToken;
    callTokenRequestEntity.to_token = toToken;
    var res = await ChatAPI.call_token(params: callTokenRequestEntity);
    if (res.code == 0) {
      channel_name = res.msg!;
      ref.read(videoCallProvider.notifier).onChannelIdChanged(ChannelIdChanged(channel_name));
      return res.data!;
    }
    return "";
  }

  addCallTime() async {

    var msgdata = ChatCall(
      from_token: userProfile.id,
      to_token: _toToken,
      from_name: userProfile.firstname,
      to_name: _toName,
      from_avatar: userProfile.avatar,
      to_avatar: _toAvatar,
      call_time: _callTimeNum,
      type: "video",
      last_time: Timestamp.now(),
    );
    await db
        .collection("chatcall")
        .withConverter(
      fromFirestore: ChatCall.fromFirestore,
      toFirestore: (ChatCall msg, options) => msg.toFirestore(),
    )
        .add(msgdata);
    String sendcontent = "Call time $_callTimeNum 【video】";
    _sendMessage(sendcontent);
  }

  _sendMessage(String sendcontent) async {
    if (_docId.isEmpty) {
      return;
    }
    final content = Msgcontent(
      token: userProfile.id,
      content: sendcontent,
      type: "text",
      addtime: Timestamp.now(),
    );

    await db
        .collection("message")
        .doc(_docId)
        .collection("msglist")
        .withConverter(
      fromFirestore: Msgcontent.fromFirestore,
      toFirestore: (Msgcontent msgcontent, options) =>
          msgcontent.toFirestore(),
    )
        .add(content);
    var messageRes = await db
        .collection("message")
        .doc(_docId)
        .withConverter(
      fromFirestore: Msg.fromFirestore,
      toFirestore: (Msg msg, options) => msg.toFirestore(),
    )
        .get();
    if (messageRes.data() != null) {
      var item = messageRes.data()!;
      int toMsgNum = item.to_msg_num == null ? 0 : item.to_msg_num!;
      int fromMsgNum = item.from_msg_num == null ? 0 : item.from_msg_num!;
      if (item.from_token == userProfile.id) {
        fromMsgNum = fromMsgNum + 1;
      } else {
        toMsgNum = toMsgNum + 1;
      }
      await db.collection("message").doc(_docId).update({
        "to_msg_num": toMsgNum,
        "from_msg_num": fromMsgNum,
        "last_msg": sendcontent,
        "last_time": Timestamp.now()
      });
    }
  }


  joinChannel() async {

    EasyLoading.show(
        indicator: const CircularProgressIndicator(),
        maskType: EasyLoadingMaskType.clear,
        dismissOnTap: true);
    String token = await _getToken();
    print("token----->$token");
    if (token.isEmpty) {
      EasyLoading.dismiss();
      Navigator.of(ref.context).pop();
      return;
    }
    await engine.joinChannel(
        token: token,
        channelId: channel_name,
        uid: 0,
        options: ChannelMediaOptions(
          channelProfile: channelProfileType,
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
        ));

    if (_callRole == "audience") {
      _callTime();
      is_calltimer = true;
    }
    EasyLoading.dismiss();
  }

  // send notification
  _sendNotifications(String callType) async {
    CallRequestEntity callRequestEntity = CallRequestEntity();
    callRequestEntity.call_type = callType;
    callRequestEntity.to_token = _toToken;
    callRequestEntity.to_avatar = _toAvatar;
    callRequestEntity.doc_id = _docId;
    callRequestEntity.to_name = _toName;
    var res = await ChatAPI.call_notifications(params: callRequestEntity);
    print(res);
    if (res.code == 0) {
      print("sendNotifications success");
    } else {}
  }

  leaveChannel(bool isSelf) async {
    EasyLoading.show(
        indicator: const CircularProgressIndicator(),
        maskType: EasyLoadingMaskType.clear,
        dismissOnTap: true);
    ref.read(videoCallProvider.notifier).onIsJoinedChanged(const IsJoinedChanged(false));
    ref.read(videoCallProvider.notifier).onSwitchCamerasChanged(const SwitchCamerasChanged(true));
    ref.read(videoCallProvider.notifier).onRemoteUidChanged(const RemoteUidChanged(0));
    ref.read(videoCallProvider.notifier).onIsShowAvatarChanged(const IsShowAvatarChanged(true));

    if (is_calltimer) {
      calltimer.cancel();
    }
    if (_callRole == "anchor") {
      addCallTime();
    }
    await player.pause();
    await engine.leaveChannel();
    await engine.release();
    await player.stop();
    if(isSelf){
      await _sendNotifications("cancel");
    }
    EasyLoading.dismiss();
    Navigator.of(ref.context).pop();
  }

  switchCamera() async {
    print("switchCamera--");
    await engine.switchCamera();
    var stateNew = ref.read(videoCallProvider);
    ref.read(videoCallProvider.notifier).onSwitchCamerasChanged(SwitchCamerasChanged(!stateNew.switchCameras));
  }

}

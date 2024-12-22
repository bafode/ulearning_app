
import 'package:beehive/common/api/chat.dart';
import 'package:beehive/common/models/entities.dart';
import 'package:beehive/common/routes/routes.dart';
import 'package:beehive/features/message/index.dart';
import 'package:beehive/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';


class MessageController extends GetxController {
  MessageController();

  final state = MessageState();
  final db = FirebaseFirestore.instance;
  final token = Global.storageService.getUserProfile().id;

  void goProfile() async {
    await Get.toNamed(AppRoutes.Profile,
        arguments: state.head_detail.value

    );
  }

  goTabStatus() {
    EasyLoading.show(
        indicator: const CircularProgressIndicator(),
        maskType: EasyLoadingMaskType.clear,
        dismissOnTap: true
    );
    state.tabStatus.value = !state.tabStatus.value;
    if (state.tabStatus.value) {
      asyncLoadMsgData();
    } else {

    }

    EasyLoading.dismiss();
  }

  Future<void> asyncLoadMsgData() async {
   // var token = UserStore.to.profile.token;
    var fromMessages = await db.collection("message")
        .withConverter(
        fromFirestore: Msg.fromFirestore,
        toFirestore: (Msg msg, options)=>msg.toFirestore()
        ).where("from_token", isEqualTo: token).get();


    print(fromMessages.docs.length);
    var toMessages = await db.collection("message")
        .withConverter(
        fromFirestore: Msg.fromFirestore,
        toFirestore: (Msg msg, options)=>msg.toFirestore()
    ).where("to_token", isEqualTo: token).get();
    print(toMessages.docs.length);

    state.msgList.clear();

    if(fromMessages.docs.isNotEmpty){
      await addMessage(fromMessages.docs);
    }



    if(toMessages.docs.isNotEmpty){
      await addMessage(toMessages.docs);
    }
    state.msgList.value.sort((a, b) {
      if (b.last_time == null) {
        return 0;
      }
      if (a.last_time == null) {
        return 0;
      }
      return b.last_time!.compareTo(a.last_time!);
    });
  }

   addMessage(List<QueryDocumentSnapshot<Msg>> data){
    for (var element in data) {
      var item = element.data();
      Message message = Message();
      //saves the commom proterties
      message.doc_id = element.id;
      message.last_time = item.last_time;

      message.msg_num = item.msg_num;
      message.last_msg = item.last_msg;
      if(item.from_token==token){
          message.firstname = item.to_firstname;
          message.lastname = item.to_lastname;
          message.avatar = item.to_avatar;
          message.token = item.to_token;
          message.online = item.to_online;
          message.msg_num = item.to_msg_num??0;
      }else{
        message.firstname = item.from_firstname;
        message.lastname = item.from_lastname;
        message.avatar = item.from_avatar;
        message.token = item.from_token;
        message.online = item.from_online;
        message.msg_num = item.from_msg_num??0;
      }
      state.msgList.add(message);

    }
  }

  @override
  void onReady() {
    super.onReady();
    firebaseMessageSetup();
  }

  @override
  void onInit() {
    super.onInit();
    getProfile();
    _snapShots();
  }

  _snapShots(){
    var token = Global.storageService.getUserProfile().id;
    final toMessageRef = db
                          .collection("message")
                          ..withConverter(
                              fromFirestore: Msg.fromFirestore,
                              toFirestore: (Msg msg, options)=>msg.toFirestore()
                          ).where("to_token", isEqualTo: token);
    final fromMessageRef = db
        .collection("message")
      ..withConverter(
          fromFirestore: Msg.fromFirestore,
          toFirestore: (Msg msg, options)=>msg.toFirestore()
      ).where("from_token", isEqualTo: token);

    toMessageRef.snapshots().listen((event) {
      asyncLoadMsgData();
    });

    fromMessageRef.snapshots().listen((event) {
      asyncLoadMsgData();
    });
  }


  void getProfile() async {
    var profile = Global.storageService.getUserProfile();
    state.head_detail.value = profile;
    state.head_detail.refresh();
    print("oninit profile ${state.head_detail.value.avatar}");
  }

  firebaseMessageSetup() async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    print("...my device token is $fcmToken");
    if (fcmToken != null) {
      BindFcmTokenRequestEntity bindFcmTokenRequestEntity = BindFcmTokenRequestEntity();
      bindFcmTokenRequestEntity.fcmtoken = fcmToken;
      await ChatAPI.bind_fcmtoken(params: bindFcmTokenRequestEntity);
    }
  }

}

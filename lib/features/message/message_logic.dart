import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ulearning_app/common/entities/user/user.dart';
import 'package:ulearning_app/common/models/entities.dart';
import 'package:ulearning_app/common/routes/routes.dart';
import 'package:ulearning_app/features/message/notifiers/message_notifier.dart';
import 'package:ulearning_app/global.dart';
class MessageLogic {
  final WidgetRef ref;
  final db = FirebaseFirestore.instance;
  User userProfile = Global.storageService.getUserProfile();

  StreamSubscription<QuerySnapshot<Object?>>? listener1;
  StreamSubscription<QuerySnapshot<Object?>>? listener2;

  MessageLogic({
    required this.ref,
  });

  void init() {
    _snapshots();
  }

  _asyncLoadMsgData() async {
    var fromMessages = await db
        .collection("message")
        .withConverter(
          fromFirestore: Msg.fromFirestore,
          toFirestore: (Msg msg, options) => msg.toFirestore(),
        )
        .where("from_token", isEqualTo: userProfile.id)
        .get();
    print(fromMessages.docs.length);

    var toMessages = await db
        .collection("message")
        .withConverter(
          fromFirestore: Msg.fromFirestore,
          toFirestore: (Msg msg, options) => msg.toFirestore(),
        )
        .where("to_token", isEqualTo: userProfile.id)
        .get();
    print("to_messages.docs.length------------");
    print(toMessages.docs.length);
    List<Message> messageList = <Message>[];
    if (fromMessages.docs.isNotEmpty) {
      var message = await _addMessage(fromMessages.docs);
      messageList.addAll(message);
    }
    if (toMessages.docs.isNotEmpty) {
      var message = await _addMessage(toMessages.docs);
      messageList.addAll(message);
    }
    // sort
    messageList.sort((a, b) {
      if (b.last_time == null) {
        return 0;
      }
      if (a.last_time == null) {
        return 0;
      }
      return b.last_time!.compareTo(a.last_time!);
    });
   ref.read(messageProvider.notifier).onMessageChanged(MessageChanged(messageList));
    ref.read(messageProvider.notifier).onLoadStatusChanged(const LoadStatusChanged(false));

  }

  Future<List<Message>> _addMessage(
      List<QueryDocumentSnapshot<Msg>> data) async {
    List<Message> messageList = <Message>[];
    for (var element in data) {
      var item = element.data();
      Message message = Message();
      message.doc_id = element.id;
      message.last_time = item.last_time;
      message.msg_num = item.msg_num;
      message.last_msg = item.last_msg;
      if (item.from_token == userProfile.id) {
        message.name = item.to_name;
        message.avatar = item.to_avatar;
        message.token = item.to_token;
        message.online = item.to_online;
        message.msg_num = item.to_msg_num ?? 0;
      } else {
        message.name = item.from_name;
        message.avatar = item.from_avatar;
        message.token = item.from_token;
        message.online = item.from_online;
        message.msg_num = item.from_msg_num ?? 0;
      }
      messageList.add(message);
    }
    return messageList;
  }

  _snapshots() async {
    var token = userProfile.id;
    print("token--------");
    print(token);

    final toMessageRef = db
        .collection("message")
        .withConverter(
          fromFirestore: Msg.fromFirestore,
          toFirestore: (Msg msg, options) => msg.toFirestore(),
        )
        .where("to_token", isEqualTo: token);
    final fromMessageRef = db
        .collection("message")
        .withConverter(
          fromFirestore: Msg.fromFirestore,
          toFirestore: (Msg msg, options) => msg.toFirestore(),
        )
        .where("from_token", isEqualTo: token);
    listener1 = toMessageRef.snapshots().listen(
      (event) async {
        print("message_start_snapshotslisten-----------");
        print(event.metadata.isFromCache);
        await _asyncLoadMsgData();
        print("message_end_snapshotslisten-----------");
      },
      onError: (error) => print("Listen failed: $error"),
    );
    listener2 = fromMessageRef.snapshots().listen(
      (event) async {
        print("message_snapshotslisten-----------");
        print(event.metadata.isFromCache);
        await _asyncLoadMsgData();
        print("snapshotslisten-----------");
      },
      onError: (error) => print("Listen failed: $error"),
    );
  }

  goChat(Message item) async{
    if (item.doc_id != null) {
      if(listener1!=null && listener2!=null){
        await listener1?.cancel();
        await listener2?.cancel();
      }

     Navigator.of(ref.context).pushNamed(AppRoutes.Chat,arguments: {
        "doc_id": item.doc_id!,
        "to_token": item.token!,
        "to_name": item.name!,
        "to_avatar": item.avatar!,
        "to_online": item.online.toString()
      }).then((completion){
      _snapshots();
    });

    }
  }

}

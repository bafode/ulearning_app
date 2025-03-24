import 'package:beehive/common/api/contact.dart';
import 'package:beehive/common/entities/contact/contactResponse/contact_response_entity.dart';
import 'package:beehive/common/models/entities.dart';
import 'package:beehive/features/contact/index.dart';
import 'package:beehive/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';



class ContactController extends GetxController {
  ContactController();

  final title = "Contacts .";
  final state = ContactState();
  final token = Global.storageService.getUserProfile().id;
  final db = FirebaseFirestore.instance;


  @override
  void onReady()  {
    super.onReady();
    asyncLoadAllData();

  }


  Future<void> goChat(ContactItem contactItem) async {
   var fromMessages =  await db.collection("message").withConverter(
        fromFirestore: Msg.fromFirestore,
        toFirestore: (Msg msg, options)=>msg.toFirestore(),
    ).where("from_token", isEqualTo: token).where("to_token",
        isEqualTo: contactItem.token )
    .get();

   print("....from_messages ${fromMessages.docs.isNotEmpty}");


  var toMessages =  await db.collection("message").withConverter(
  fromFirestore: Msg.fromFirestore,
  toFirestore: (Msg msg, options)=>msg.toFirestore(),
  ).where("from_token", isEqualTo: contactItem.token).where("to_token",
  isEqualTo: token )
      .get();
   print("....to_messages ${toMessages.docs.isNotEmpty}");

  if(fromMessages.docs.isEmpty&&toMessages.docs.isEmpty){
    var profile = Global.storageService.getUserProfile();
    if(kDebugMode){
      print("profile $profile");
    }
    var msgdata = Msg(
      from_token: profile.id,
      to_token: contactItem.token,
      from_firstname: profile.firstname,
      from_lastname: profile.lastname,
      to_firstname: contactItem.firstname,
      to_lastname: contactItem.lastname,
      from_avatar: profile.avatar??"https://res.cloudinary.com/dtqimnssm/image/upload/v1730063749/images/media-1730063756706.jpg",
      to_avatar: contactItem.avatar??"https://res.cloudinary.com/dtqimnssm/image/upload/v1730063749/images/media-1730063756706.jpg",
      from_online: profile.online??0,
      to_online: contactItem.online??0,
      last_msg: "",
      last_time: Timestamp.now(),
      msg_num: 0,
    );

    var docId = await db.collection("message").withConverter(
        fromFirestore: Msg.fromFirestore,
        toFirestore: (Msg msg, options)=>msg.toFirestore()
    ).add(msgdata);
    Get.offAllNamed("/chat",
      parameters: {
          "doc_id":docId.id,
          "to_token":contactItem.token??"",
          "to_firstname":contactItem.firstname??"",
          "to_lastname":contactItem.lastname??"",
          "to_avatar":contactItem.avatar??"https://res.cloudinary.com/dtqimnssm/image/upload/v1730063749/images/media-1730063756706.jpg",
          "to_online":"${contactItem.online??0}"
      }

    );

  }else{
    if(fromMessages.docs.isNotEmpty){
      Get.offAllNamed("/chat",
          parameters: {
            "doc_id":fromMessages.docs.first.id,
            "to_token":contactItem.token??"",
            "to_firstname":contactItem.firstname??"",
            "to_lastname":contactItem.lastname??"",
            "to_avatar":contactItem.avatar??"https://res.cloudinary.com/dtqimnssm/image/upload/v1730063749/images/media-1730063756706.jpg",
            "to_online":"${contactItem.online??0}"
          }

      );
    }

    if(toMessages.docs.isNotEmpty){
      Get.offAllNamed("/chat",
          parameters: {
            "doc_id":toMessages.docs.first.id,
            "to_token":contactItem.token??"",
            "to_firstname":contactItem.firstname??"",
            "to_lastname":contactItem.lastname??"",
            "to_avatar":contactItem.avatar??"https://res.cloudinary.com/dtqimnssm/image/upload/v1730063749/images/media-1730063756706.jpg",
            "to_online":"${contactItem.online??0}"
          }

      );
    }


  }

}

  asyncLoadAllData() async {
    EasyLoading.show(
        indicator: const CircularProgressIndicator(),
        maskType: EasyLoadingMaskType.clear,
        dismissOnTap: true
    );
    state.contactList.clear();

    var result = await ContactAPI.post_contact();
    if (kDebugMode) {
      print(result.data!);
    }
    if(result.code==0){
      state.contactList.addAll(result.data!);
    }
    EasyLoading.dismiss();
  }
}

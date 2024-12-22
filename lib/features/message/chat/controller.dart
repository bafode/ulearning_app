
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:beehive/common/api/chat.dart';
import 'package:beehive/common/models/entities.dart';
import 'package:beehive/common/routes/names.dart';
import 'package:beehive/common/widgets/popup_messages.dart';
import 'package:beehive/features/message/chat/index.dart';
import 'package:beehive/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ChatController extends GetxController {
  ChatController();

  final state = ChatState();
   late String doc_id;
   final myInputController = TextEditingController();
   //get the user or sender's token
   final userProfile = Global.storageService.getUserProfile();
   final token = Global.storageService.getUserProfile().id;

   //firebase data intance
   final db = FirebaseFirestore.instance;
   var listener;
   var isLoadmore = true;
   File? _photo;
   final ImagePicker _picker = ImagePicker();

   ScrollController myScrollController =  ScrollController();

  void goMore(){
     state.more_status.value = state.more_status.value?false:true;
   }

   void audioCall(){
     state.more_status.value=false;
     Get.toNamed(AppRoutes.VoiceCall,
      parameters: {
       "to_token":state.to_token.value,
       "to_firstname":state.to_firstname.value,
        "to_lastname":state.to_lastname.value,
       "to_avatar":state.to_avatar.value,
        "call_role":"anchor",
        "doc_id":doc_id
      }
     );
   }

Future <bool> requestPermission(Permission permission) async {
    var permissionStatus = await permission.status;
    if(permissionStatus!=PermissionStatus.granted){
      var status = await permission.request();
      if(status != PermissionStatus.granted){
        toastInfo( "Please enable permission have video call");
        if(GetPlatform.isAndroid){
          await openAppSettings();
        }
        return false;
      }
    }
    return true;

}


  void videoCall()async{

    state.more_status.value=false;
    bool micStatus = await requestPermission(Permission.microphone);
    bool camStatus = await requestPermission(Permission.camera);

    if(GetPlatform.isAndroid&&micStatus&&camStatus){
      Get.toNamed(AppRoutes.VideoCall,
          parameters: {
            "to_token":state.to_token.value,
            "to_firstname":state.to_firstname.value,
            "to_lastname":state.to_lastname.value,
            "to_avatar":state.to_avatar.value,
            "call_role":"anchor",
            "doc_id":doc_id
          }
      );
    }else{
      Get.toNamed(AppRoutes.VideoCall,
          parameters: {
            "to_token":state.to_token.value,
            "to_firstname":state.to_firstname.value,
            "to_lastname":state.to_lastname.value,
            "to_avatar":state.to_avatar.value,
            "call_role":"anchor",
            "doc_id":doc_id
          }
      );
    }
  }



  @override
  void onInit(){
    super.onInit();
    print("This is onInit");
    var data = Get.parameters;
    doc_id = data['doc_id']!;
    state.to_token.value = data['to_token']??"";
    state.to_firstname.value = data['to_firstname']??"";
    state.to_lastname.value = data['to_lastname']??"";
    state.to_avatar.value = data['to_avatar']??"";
    state.to_online.value  = data['to_online']??"1";
    //clearning red dots
    clearMsgNum(doc_id);
  }


  Future<void> clearMsgNum(String docId) async {
    var messageResult = await db.collection("message").doc(docId).withConverter(
        fromFirestore: Msg.fromFirestore,
        toFirestore: (Msg msg, options)=>msg.toFirestore()
    ).get();
    //to know if we have any unread messages or calls
    if(messageResult.data()!=null){
      var  item = messageResult.data()!;
      int toMsgNum = item.to_msg_num==null?0:item.to_msg_num!;
      int fromMsgNum = item.from_msg_num==null?0:item.from_msg_num!;
      // this is your phone
      if(item.from_token==token){
        toMsgNum = 0;
      }else{
        fromMsgNum = 0;
      }
      await db.collection("message")
          .doc(docId)
          .update({
        "to_msg_num":toMsgNum,
        "from_msg_num":fromMsgNum,

      });

    }
  }




  @override
  void onReady(){
     super.onReady();
     state.msgcontentList.clear();
     final messages = db.collection("message")
                      .doc(doc_id)
                      .collection("msglist")
                      .withConverter(
                      fromFirestore: Msgcontent.fromFirestore,
                      toFirestore: (Msgcontent msg, options)=>msg.toFirestore())
                      .orderBy("addtime", descending: true).limit(15);
    listener = messages.snapshots().listen((event) {

      List<Msgcontent>  temgMsgList = <Msgcontent>[];
      for(var change in event.docChanges) {
            switch(change.type){

              case DocumentChangeType.added:
                // TODO: Handle this case.
                  if(change.doc.data()!=null){
                    temgMsgList.add(change.doc.data()!);

                  }
                break;
              case DocumentChangeType.modified:
                // TODO: Handle this case.
                break;
              case DocumentChangeType.removed:
                // TODO: Handle this case.
                break;
            }

      }

      //4, 3, 2, 1   //1, 2, 3, 4

      for (var element in temgMsgList.reversed) {
        state.msgcontentList.value.insert(0, element);
      }
      state.msgcontentList.refresh();

      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (myScrollController.hasClients){
          myScrollController.animateTo(
            myScrollController.position.minScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,);
        }

      });

    });

    myScrollController.addListener(() {
      if((myScrollController.offset+10)>(myScrollController.position.maxScrollExtent)){
        if(isLoadmore){
          state.isloading.value = true;
          //to stop unnecessary reauest to firaasebase
          isLoadmore = false;
          asyncLoadMoreData();
          print("...loading...");
        }
      }
    });


  }

  Future imgFromGallery()async{

     final pickedFile= await _picker.pickImage(source: ImageSource.gallery);
     if(pickedFile!=null){
       _photo = File(pickedFile.path);
       uploadFile();
     }else{
       print("No image selected");
     }
  }

  Future uploadFile() async{
    print("ok");
    var result = await ChatAPI.upload_img(file:_photo);
    print(result.data);
    if(result.code==0){
      sendImageMessage(result.data!);
    }else{
      toastInfo("sending image error");
    }
  }

  Future<void> sendMessage() async {
    String sendContent = myInputController.text;
    // print("...$sendContent...");
    if(sendContent.isEmpty){
      toastInfo("content is empty");
      return;
    }
    //created an object to send  to firebase
    final content = Msgcontent(
        token: token,
        content: sendContent,
        type: "text",
        addtime: Timestamp.now()
    );

    await db.collection("message").doc(doc_id).collection("msglist")
        .withConverter(
        fromFirestore: Msgcontent.fromFirestore,
        toFirestore: (Msgcontent msg, options)=>msg.toFirestore()
    ).add(content).then((DocumentReference doc) {
      // print("...base id is ${doc_id}..new message doc id is ${doc.id}");
      myInputController.clear();
    });


    //collection().get().docs.data()
    var messageResult = await db.collection("message").doc(doc_id).withConverter(
        fromFirestore: Msg.fromFirestore,
        toFirestore: (Msg msg, options)=>msg.toFirestore()
    ).get();
    //to know if we have any unread messages or calls
    if(messageResult.data()!=null){
      print("--I am here--");
      print(doc_id);
      var  item = messageResult.data()!;
      int toMsgNum = item.to_msg_num==null?0:item.to_msg_num!;
      int fromMsgNum = item.from_msg_num==null?0:item.from_msg_num!;
      if(item.from_token==token){
        fromMsgNum = fromMsgNum+1;
      }else{
        toMsgNum = toMsgNum+1;
      }
      await db.collection("message")
          .doc(doc_id)
          .update({
        "to_msg_num":toMsgNum,
        "from_msg_num":fromMsgNum,
        "last_msg":sendContent,
        "last_time":Timestamp.now()
      });

    }

  }

  Future<void> asyncLoadMoreData() async {
    final messages = await db.collection("message")
        .doc(doc_id)
        .collection("msglist")
        .withConverter(
        fromFirestore: Msgcontent.fromFirestore,
        toFirestore: (Msgcontent msg, options)=> msg.toFirestore()
    ).orderBy("addtime", descending: true).where(
      'addtime', isLessThan:state.msgcontentList.value.last.addtime
    ).limit(10).get();

    if(messages.docs.isNotEmpty){
      for (var element in messages.docs) {
        var data = element.data();
        state.msgcontentList.value.add(data);
      }
      print(state.msgcontentList.value.length);
    }

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      isLoadmore = true;
    });
    state.isloading.value = false;
  }

  Future<void> sendImageMessage(String url) async {

     //created an object to send  to firebase
     final content = Msgcontent(
       token: token,
       content: url,
       type: "image",
       addtime: Timestamp.now()
     );

     await db.collection("message").doc(doc_id).collection("msglist")
     .withConverter(
         fromFirestore: Msgcontent.fromFirestore,
         toFirestore: (Msgcontent msg, options)=>msg.toFirestore()
     ).add(content).then((DocumentReference doc) {
       print("...base id is $doc_id..new image doc id is ${doc.id}");

     });


     //collection().get().docs.data()
    var messageResult = await db.collection("message").doc(doc_id).withConverter(
        fromFirestore: Msg.fromFirestore,
        toFirestore: (Msg msg, options)=>msg.toFirestore()
    ).get();
    //to know if we have any unread messages or calls
    if(messageResult.data()!=null){
      var  item = messageResult.data()!;
      int toMsgNum = item.to_msg_num==null?0:item.to_msg_num!;
      int fromMsgNum = item.from_msg_num==null?0:item.from_msg_num!;
      if(item.from_token==token){
        fromMsgNum = fromMsgNum+1;
      }else{
        toMsgNum = toMsgNum+1;
      }
      await db.collection("message")
      .doc(doc_id)
      .update({
        "to_msg_num":toMsgNum,
        "from_msg_num":fromMsgNum,
        "last_msg":"【image】",
        "last_time":Timestamp.now()
      });

    }

  }

  void closeAllPop() async{
   // Get.focusScope?.unfocus();
    state.more_status.value = false;
  }


  @override
  void dispose(){
     super.dispose();
     listener.cancel();
     myInputController.dispose();
     myScrollController.dispose();
     clearMsgNum(doc_id);

  }




}

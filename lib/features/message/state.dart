
import 'package:beehive/common/entities/user/user.dart';
import 'package:beehive/common/models/message.dart';
import 'package:beehive/common/models/chatcall.dart';
import 'package:get/get.dart';
class MessageState{
  var head_detail = const User().obs;
  RxBool  tabStatus = true.obs;
  RxList<Message> msgList = <Message>[].obs;
  RxList<ChatCall> callList = <ChatCall>[].obs;
}

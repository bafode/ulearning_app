import 'package:get/get.dart';

class VoiceCallState {
  RxString url = "".obs;
  RxBool isJoined = false.obs;
  RxBool openMicrophone = true.obs;
  RxBool enableSpeakerphone = true.obs;
  RxString callTime = "00:00".obs;
  RxString callStatus= "not connected".obs;


  var channelId = "".obs;

  var to_token = "".obs;
  var to_firstname = "".obs;
  var to_lastname = "".obs;
  var to_avatar = "".obs;
  var doc_id = "".obs;
  var call_role = "audience".obs;// 1，anchor 2，audience

}

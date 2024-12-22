
import 'package:get/get.dart';
class VideoCallState{

  RxBool isJoined = false.obs;
  RxBool openMicrophone = true.obs;
  RxBool enableSpeaker = true.obs;
  RxString callTime = "00.00".obs;
  RxString callStatus = "not connected".obs;
  RxString callTimeNum = "not connected".obs;

  var to_token = "".obs;
  var to_firstname = "".obs;
  var to_lastname = "".obs;
  var to_avatar = "".obs;
  var doc_id = "".obs;
  //receiver audience
  //anchor is caller
  var call_role = "audience".obs;
  var channelId = "".obs;

  RxBool isReadyPreview = false.obs;
  //if user did not join show avatar, otherwise don't show
  RxBool isShowAvatar = true.obs;
  //change camera front and back
  RxBool switchCamera = true.obs;

  //remembers remote id of the user from Agora
  RxInt onRemoteUID = 0.obs;

}
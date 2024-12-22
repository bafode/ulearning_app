import 'package:beehive/common/models/entities.dart';
import 'package:get/get.dart';

class ChatState{
  //for holding our data from firebase firestore
  RxList<Msgcontent> msgcontentList =<Msgcontent>[].obs;

  var to_token = "".obs;
  var to_firstname = "".obs;
  var to_lastname = "".obs;
  var to_avatar = "".obs;
  var to_online="".obs;
  RxBool more_status = false.obs;
  RxBool isloading = false.obs;

}
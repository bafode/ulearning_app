
import 'package:beehive/common/entities/contact/contactResponse/contact_response_entity.dart';
import 'package:get/get.dart';

class FollowingState{
 RxList<ContactItem> followingList = <ContactItem>[].obs;
 final RxMap<String, bool> followingStatus = <String, bool>{}.obs;
}
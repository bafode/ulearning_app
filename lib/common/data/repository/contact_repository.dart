import 'package:beehive/common/entities/contact/contactResponse/contact_response_entity.dart';

abstract class ContactRepository {
  Future<ContactResponseEntity> getContacts();
  Future<ContactResponseEntity> getFollowers(String userId);
  Future<ContactResponseEntity> getFollowings(String userId);
  Future<void> toggleFollow(String targetId);
}

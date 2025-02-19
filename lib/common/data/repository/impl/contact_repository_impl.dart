import 'package:beehive/common/data/remote/rest_client_api.dart';
import 'package:beehive/common/data/repository/contact_repository.dart';
import 'package:beehive/common/entities/contact/contactResponse/contact_response_entity.dart';

class ContactRepositoryImpl implements ContactRepository {
  final RestClientApi api;

  ContactRepositoryImpl(this.api);

  @override
  Future<ContactResponseEntity> getContacts() async {
    return await api.getContacts();
  }

  @override
  Future<ContactResponseEntity> getFollowers(String userId) async {
    return await api.getFollowers(userId);
  }

  @override
  Future<ContactResponseEntity> getFollowings(String userId) async {
    return await api.getFollowings(userId);
  }

  @override
  Future<void> toggleFollow(String targetId) async {
    await api.toggleUserFollow(targetId);
  }
}

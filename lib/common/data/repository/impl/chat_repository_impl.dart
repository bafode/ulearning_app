import 'dart:io';
import 'package:beehive/common/data/remote/rest_client_api.dart';
import 'package:beehive/common/data/repository/chat_repository.dart';
import 'package:beehive/common/entities/base/base_response_entity.dart';
import 'package:beehive/common/entities/auth/bindFcmTokenRequest/bind_fcm_token_request.dart';
import 'package:beehive/common/models/chat.dart';
import 'package:beehive/common/entities/user/user.dart';

class ChatRepositoryImpl implements ChatRepository {
  final RestClientApi api;

  ChatRepositoryImpl(this.api);

  @override
  Future<BaseResponseEntity> bindFcmToken(BindFcmTokenRequestEntity params) {
    return api.bindFcmToken(params);
  }

  @override
  Future<BaseResponseEntity> sendCallNotification(CallRequestEntity params) {
    return api.sendCallNotification(params);
  }

  @override
  Future<BaseResponseEntity> getRtcToken(CallTokenRequestEntity params) {
    return api.getRtcToken(params);
  }

  @override
  Future<BaseResponseEntity> sendMessage(ChatRequestEntity params) {
    return api.sendMessage(params);
  }

  @override
  Future<BaseResponseEntity> uploadImage(File file) {
    return api.uploadImage(file);
  }

  @override
  Future<User> uploadProfileImage(String userId, File image) async {
    return await api.uploadProfileImage(userId, image);
  }

  @override
  Future<SyncMessageResponseEntity> syncMessage(SyncMessageRequestEntity params) async {
    return await api.syncMessage(params);
  }
}

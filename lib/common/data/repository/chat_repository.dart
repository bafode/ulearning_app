import 'dart:io';
import 'package:beehive/common/entities/base/base_response_entity.dart';
import 'package:beehive/common/entities/auth/bindFcmTokenRequest/bind_fcm_token_request.dart';
import 'package:beehive/common/models/chat.dart';
import 'package:beehive/common/entities/user/user.dart';

abstract class ChatRepository {
  Future<BaseResponseEntity> bindFcmToken(BindFcmTokenRequestEntity params);
  Future<BaseResponseEntity> sendCallNotification(CallRequestEntity params);
  Future<BaseResponseEntity> getRtcToken(CallTokenRequestEntity params);
  Future<BaseResponseEntity> sendMessage(ChatRequestEntity params);
  Future<BaseResponseEntity> uploadImage(File file);
  Future<User> uploadProfileImage(String userId, File image);
  Future<SyncMessageResponseEntity> syncMessage(SyncMessageRequestEntity params);
}

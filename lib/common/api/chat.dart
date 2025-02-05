import 'dart:convert';
import 'dart:io';

import 'package:beehive/common/entities/user/user.dart';
import 'package:beehive/common/utils/constants.dart';
import 'package:beehive/global.dart';
import 'package:dio/dio.dart';
import 'package:beehive/common/models/base.dart';
import 'package:beehive/common/models/chat.dart';
import 'package:beehive/common/services/http_util.dart';

class ChatAPI {
  static Future<BaseResponseEntity> bind_fcmtoken(
      {BindFcmTokenRequestEntity? params}) async {
    var response = await HttpUtil().post(
      'v1/auth/bind_fcmtoken',
      queryParameters: params?.toJson(),
    );
    return BaseResponseEntity.fromJson(response);
  }

  static Future<BaseResponseEntity> call_notifications(
      {CallRequestEntity? params}) async {
    var response = await HttpUtil().post(
      'v1/notifications/send_notice',
      data: params?.toJson(),
    );
    return BaseResponseEntity.fromJson(response);
  }

  static Future<BaseResponseEntity> call_token(
      {CallTokenRequestEntity? params}) async {
    var response = await HttpUtil().post(
      'v1/auth/get_rtc_token',
      queryParameters: params?.toJson(),
    );
    return BaseResponseEntity.fromJson(response);
  }

  static Future<BaseResponseEntity> send_message(
      {ChatRequestEntity? params}) async {
    var response = await HttpUtil().post(
      'api/message',
      queryParameters: params?.toJson(),
    );
    return BaseResponseEntity.fromJson(response);
  }

  static Future<BaseResponseEntity> upload_img({File? file}) async {
    String fileName = file!.path.split('/').last;

    FormData data = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
    });
    var response = await HttpUtil().post(
      'v1/notifications/upload_photo',
      data: data,
    );
    return BaseResponseEntity.fromJson(response);
  }

  static Future<User> uploadProfileImage({File? file,String? id}) async {
    String fileName = file!.path.split('/').last;

    FormData data = FormData.fromMap({
      "image": await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
    });
    final response = await HttpUtil().patch(
      "v1/users/$id",
      data: data,
    );
    User user= User.fromJson(response);
   
   await Global.storageService.setString(
        AppConstants.STORAGE_USER_PROFILE_KEY, jsonEncode(response));
    return user;
  }

  static Future<SyncMessageResponseEntity> sync_message(
      {SyncMessageRequestEntity? params}) async {
    var response = await HttpUtil().post(
      'api/sync_message',
      queryParameters: params?.toJson(),
    );
    return SyncMessageResponseEntity.fromJson(response);
  }
}

import 'package:beehive/common/entities/base/base_response_entity.dart';
import 'package:beehive/common/services/http_util.dart';
import 'package:beehive/global.dart';

class NotificationAPI {
  // Send a social notification (like, comment, follow)
  static Future<BaseResponseEntity> sendSocialNotification({
    required String type, // "like", "comment", "follow"
    required String receiverId,
    String? postId,
    String? commentId,
    String? message,
  }) async {
    Map<String, dynamic> data = {
      "type": type,
      "receiver_id": receiverId,
      "sender_id": Global.storageService.getUserProfile().id,
    };

    if (postId != null) data["post_id"] = postId;
    if (commentId != null) data["comment_id"] = commentId;
    if (message != null) data["message"] = message;

    var response = await HttpUtil().post(
      'v1/notifications/social',
      data: data,
    );
    return BaseResponseEntity.fromJson(response);
  }

  // Get all notifications for the current user
  static Future<BaseResponseEntity> getUserNotifications({
    int page = 1,
    int limit = 20,
  }) async {
    var response = await HttpUtil().get(
      'v1/notifications',
      queryParameters: {
        "page": page,
        "limit": limit,
      },
    );
    return BaseResponseEntity.fromJson(response);
     // Parse the response to extract notifications
    // var responseData = BaseResponseEntity.fromJson(response);
    // if (responseData.data != null &&
    //     responseData.data['notifications'] != null) {
    //   responseData.data['notifications'] =
    //       List<Map<String, dynamic>>.from(responseData.data['notifications']);
    // }
    // return responseData.data['notifications'];
  }

  // Mark a notification as read
  static Future<BaseResponseEntity> markAsRead(dynamic notificationId) async {
    var response = await HttpUtil().post(
      'v1/notifications/mark-read',
      data: {
        "notification_ids": notificationId,
      },
    );
    return BaseResponseEntity.fromJson(response);
  }

  // Mark all notifications as read
  static Future<BaseResponseEntity> markAllAsRead() async {
    var response = await HttpUtil().post(
      'v1/notifications/mark-all-read',
      data: {},
    );
    return BaseResponseEntity.fromJson(response);
  }

  // Delete a notification
  static Future<BaseResponseEntity> deleteNotification(String notificationId) async {
    var response = await HttpUtil().post(
      'v1/notifications/delete',
      data: {
        "notification_id": notificationId,
      },
    );
    return BaseResponseEntity.fromJson(response);
  }

  // Get the count of unread notifications
  static Future<BaseResponseEntity> getUnreadCount() async {
    var response = await HttpUtil().get(
      'v1/notifications/unread-count',
    );
    return BaseResponseEntity.fromJson(response);
  }
}

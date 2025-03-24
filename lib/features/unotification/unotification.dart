import 'package:beehive/common/routes/names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:beehive/common/models/notification.dart';
import 'package:beehive/common/utils/app_colors.dart';
import 'package:beehive/common/utils/date.dart';
import 'package:beehive/features/message/controller.dart';
import 'package:beehive/features/unotification/controller.dart';

class Unotification extends StatelessWidget {
  const Unotification({super.key});

  List<AppNotification> _getNotifications() {
    final messageController = Get.find<MessageController>();
    final notificationController = Get.find<NotificationController>();
    final messageState = messageController.state;
    List<AppNotification> notifications = [];

    // Add message notifications
    // notifications.addAll(
    //   messageState.msgList.map((msg) => AppNotification.fromMessage(msg))
    // );

    // Add call notifications
    // notifications.addAll(
    //   messageState.callList.map((call) => AppNotification.fromCall(call))
    // );

    // Add social notifications
    notifications.addAll(notificationController.socialNotifications);

    // Sort by timestamp, most recent first
    notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return notifications;
  }

  Widget _buildNotificationItem(
      AppNotification notification, BuildContext context) {
    IconData iconData;
    Color iconColor;

    switch (notification.type) {
      case NotificationType.text:
        iconData = Icons.message;
        iconColor = AppColors.primaryElement;
        break;
      case NotificationType.voiceCall:
        iconData = Icons.call;
        iconColor = Colors.green;
        break;
      case NotificationType.videoCall:
        iconData = Icons.videocam;
        iconColor = Colors.green;
        break;
      case NotificationType.callCanceled:
        iconData = Icons.call_end;
        iconColor = Colors.red;
        break;
      case NotificationType.acceptCall:
        iconData = Icons.call_made;
        iconColor = Colors.green;
        break;
      case NotificationType.like:
        iconData = Icons.favorite;
        iconColor = Colors.red;
        break;
      case NotificationType.comment:
        iconData = Icons.comment;
        iconColor =AppColors.primaryText;
        break;
      case NotificationType.follow:
        iconData = Icons.person_add;
        iconColor = AppColors.primaryElement;
        break;
      case NotificationType.mention:
        iconData = Icons.alternate_email;
        iconColor = Colors.blue;
        break;
      case NotificationType.tag:
        iconData = Icons.tag;
        iconColor = Colors.blue;
        break;
      case NotificationType.share:
        iconData = Icons.share;
        iconColor = Colors.green;
        break;
      case NotificationType.newPost:
        iconData = Icons.post_add;
        iconColor = Colors.blue;
        break;
      case NotificationType.friendRequest:
        iconData = Icons.person_add;
        iconColor = Colors.purple;
        break;
      case NotificationType.friendAccept:
        iconData = Icons.how_to_reg;
        iconColor = Colors.green;
        break;
      case NotificationType.system:
        iconData = Icons.notifications;
        iconColor = Colors.grey;
        break;
    }

    return InkWell(
      onTap: () async {
        print("targetRoute: ${notification.targetRoute}");
        print("routeParams: ${notification.routeParams}");
        final notificationController = Get.find<NotificationController>();
        await notificationController.markAsRead(notification.id);
        if (notification.targetRoute != null) {
          if (notification.targetRoute == AppRoutes.Chat||
              notification.targetRoute == AppRoutes.Profile) {
            Get.toNamed(notification.targetRoute!,
                parameters: notification.routeParams);
          }else {
            Navigator.of(context).pushNamed(
              notification.targetRoute!,
              arguments: notification.routeParams,
            );
          }
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        decoration: BoxDecoration(
          color:
              notification.isRead ? Colors.white : Colors.blue.withOpacity(0.1),
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                iconData,
                color: iconColor,
                size: 20.w,
              ),
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    notification.message,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.primarySecondaryElementText,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    duTimeLineFormat(notification.timestamp),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.primaryThirdElementText,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Load both messages and calls
    final messageController = Get.find<MessageController>();
    final notificationController = Get.find<NotificationController>();

    messageController.asyncLoadMsgData();
    messageController.asyncLoadCallData();
    notificationController.fetchNotifications();
    notificationController.fetchUnreadCount();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryElement,
        elevation: 0,
        title: Text(
          'Notifications',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () => Get.back(),
        ),
        actions: [
         
          if (notificationController.unreadCount > 0)
            IconButton(
              icon: const Icon(
                Icons.mark_chat_read,
                color: Colors.white,
              ),
              onPressed: () async {
                await notificationController.markAllAsRead();
              },
            ),
        ],
      ),
      body: Obx(() {
        final notifications = _getNotifications();
        return notifications.isEmpty
            ? Center(
                child: Text(
                  'Aucune notification',
                  style: TextStyle(
                    color: AppColors.primaryThirdElementText,
                    fontSize: 16.sp,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  return _buildNotificationItem(notifications[index], context);
                },
              );
      }),
    );
  }
}

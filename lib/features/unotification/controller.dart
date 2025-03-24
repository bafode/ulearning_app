import 'dart:async';
import 'package:beehive/common/api/notification_api.dart';
import 'package:beehive/common/models/notification.dart';
import 'package:beehive/common/routes/names.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  final RxList<AppNotification> socialNotifications = <AppNotification>[].obs;
  final RxInt unreadCount = 0.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
    fetchUnreadCount();

    // Set up a timer to periodically fetch the unread count
    Timer.periodic(const Duration(seconds: 30), (timer) {
      fetchUnreadCount();
    });
  }

  // Fetch all notifications for the current user
  Future<void> fetchNotifications() async {
    isLoading.value = true;
    try {
      final response = await NotificationAPI.getUserNotifications();
      if (response.code == 0 && response.data != null) {
        // Clear existing notifications
        socialNotifications.clear();

        // Add new notifications from response
        final List<dynamic> notificationsData =
            response.data['notifications'] as List<dynamic>;

        for (var data in notificationsData) {
          NotificationType getType(String backendType) {
            switch (backendType) {
              // Types d'appels uniformisés avec les contrôleurs
              case 'voice':
                return NotificationType.voiceCall;
              case 'video':
                return NotificationType.videoCall;
              case 'text':
                return NotificationType.text;
              case 'cancel':
                return NotificationType.callCanceled;
              case 'accept':
                return NotificationType.acceptCall;

              // Pour la compatibilité avec les anciens types
              case 'voice_call':
                return NotificationType.voiceCall;
              case 'video_call':
                return NotificationType.videoCall;
              case 'call_canceled':
                return NotificationType.callCanceled;
              case 'accept_call':
                return NotificationType.acceptCall;

              // Types de notifications sociales
              case 'like':
                return NotificationType.like;
              case 'comment':
                return NotificationType.comment;
              case 'follow':
                return NotificationType.follow;
              case 'mention':
                return NotificationType.mention;
              case 'tag':
                return NotificationType.tag;
              case 'share':
                return NotificationType.share;
              case 'new_post':
                return NotificationType.newPost;
              case 'friend_request':
                return NotificationType.friendRequest;
              case 'friend_accept':
                return NotificationType.friendAccept;
              case 'system':
                return NotificationType.system;
              default:
                return NotificationType.system;
            }
          }

          String getMessage(NotificationType type){
            switch (type) {
              case NotificationType.text:
                return "Vous avez un nouveau message";
              case NotificationType.voiceCall:
                return "Appel vocal entrant";
              case NotificationType.videoCall:
                return "Appel vidéo entrant";
              case NotificationType.callCanceled:
                return "Appel annulé";
              case NotificationType.acceptCall:
                return "Appel accepté";
              case NotificationType.like:
                return "A aimé votre publication";
              case NotificationType.comment:
                return "A commenté votre publication";
              case NotificationType.follow:
                return "A commencé à vous suivre";
              case NotificationType.mention:
                return "Vous a mentionné";
              case NotificationType.tag:
                return "Vous a identifié";
              case NotificationType.share:
                return "A partagé votre publication";
              case NotificationType.newPost:
                return "Nouvelle publication";
              case NotificationType.friendRequest:
                return "Demande d'ami";
              case NotificationType.friendAccept:
                return "Demande d'ami acceptée";
              case NotificationType.system:
                return "Notification système";
              default:
                return "Nouvelle notification";
            }
          }

          // Determine target route based on notification type
          String? targetRoute;
          Map<String, String>? routeParams;

          final type = getType(data['type'] as String);

          if (type == NotificationType.text ||
              type == NotificationType.voiceCall ||
              type == NotificationType.videoCall) {
            targetRoute = AppRoutes.Chat;
            routeParams = {
              "doc_id": data['docId'] ?? "",
              "to_token": data['sender']['id'] ?? "",
              "to_firstname": data['sender']['firstname'] ?? "",
              "to_lastname": data['sender']['lastname'] ?? "",
              "to_avatar": data['sender']['avatar'] ?? "",
              "to_online": "1",
            };
          } else if (type == NotificationType.like ||
              type == NotificationType.comment) {
            targetRoute = AppRoutes
                .POST_DETAIL; // Utilisez la constante au lieu de "/post_detail"
            routeParams = {
              "id": data['docId']?.toString() ??
                  "", // Assurez-vous que c'est une chaîne
            };
          } else if (type == NotificationType.follow ||
              type == NotificationType.friendRequest ||
              type == NotificationType.friendAccept) {
                print("user_id: ${data['sender']['id']}");
            targetRoute = AppRoutes
                .Profile; // Utilisez la constante au lieu de "/profile"
            routeParams = {
              "id": data['sender']['id']?.toString() ??
                  "", // Assurez-vous que c'est une chaîne
            };
          }
          if (type == NotificationType.like ||
              type == NotificationType.comment) {
            targetRoute = AppRoutes
                .POST_DETAIL; // Utilisez la constante au lieu de "/post_detail"
            routeParams = {
              "id": data['docId']?.toString() ??
                  "", // Assurez-vous que c'est une chaîne
            };
          } else if (type == NotificationType.follow ||
              type == NotificationType.friendRequest ||
              type == NotificationType.friendAccept) {
            targetRoute = AppRoutes
                .Profile; // Utilisez la constante au lieu de "/profile"
            routeParams = {
              "id": data['sender']['docId']?.toString() ??
                  "", // Assurez-vous que c'est une chaîne
            };
          }
          // Create AppNotification from data
          // This depends on the structure of your notification data
          // You may need to adjust this based on your backend response
          final notification = AppNotification(
            id: data['id'],
            type: type,
            title: data['sender'] != null
                ? "${data['sender']['firstname'] ?? ''} ${data['sender']['lastname'] ?? ''}"
                : "Notification",
            message: getMessage(type),
            targetRoute: targetRoute,
            routeParams: routeParams,
            timestamp: data['createdAt'] != null
                ? DateTime.parse(data['createdAt'])
                : DateTime.now(),
            isRead: data['status'] == 'read',
            targetId: data['docId'],
            targetType: data['targetType'],
          );

          socialNotifications.add(notification);
        }
      }
    } catch (e) {
      print('Error fetching notifications: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch the count of unread notifications
  Future<void> fetchUnreadCount() async {
    try {
      final response = await NotificationAPI.getUnreadCount();
      print("Unread count response: ${response.data}");
      if (response.code == 0 && response.data != null) {
        unreadCount.value = response.data['unreadCount'] ?? 0;
      }
    } catch (e) {
      print('Error fetching unread count: $e');
    }
  }

  // Mark a notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      final response = await NotificationAPI.markAsRead(notificationId);
      if (response.code == 0) {
        // Update the notification in the list
        final index =
            socialNotifications.indexWhere((n) => n.id == notificationId);
        if (index != -1) {
          final notification = socialNotifications[index];
          socialNotifications[index] = AppNotification(
            id: notification.id,
            type: notification.type,
            title: notification.title,
            message: notification.message,
            targetRoute: notification.targetRoute,
            routeParams: notification.routeParams,
            timestamp: notification.timestamp,
            isRead: true,
          );
        }

        // Update unread count
        fetchUnreadCount();
      }
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }

  // Mark all notifications as read
  Future<void> markAllAsRead() async {
    try {
      final response = await NotificationAPI.markAllAsRead();
      if (response.code == 0) {
        // Update all notifications in the list
        for (int i = 0; i < socialNotifications.length; i++) {
          final notification = socialNotifications[i];
          socialNotifications[i] = AppNotification(
            id: notification.id,
            type: notification.type,
            title: notification.title,
            message: notification.message,
            targetRoute: notification.targetRoute,
            routeParams: notification.routeParams,
            timestamp: notification.timestamp,
            isRead: true,
          );
        }

        // Update unread count
        unreadCount.value = 0;
      }
    } catch (e) {
      print('Error marking all notifications as read: $e');
    }
  }

  // Delete a notification
  Future<void> deleteNotification(String notificationId) async {
    try {
      final response = await NotificationAPI.deleteNotification(notificationId);
      if (response.code == 0) {
        // Remove the notification from the list
        socialNotifications.removeWhere((n) => n.id == notificationId);

        // Update unread count
        fetchUnreadCount();
      }
    } catch (e) {
      print('Error deleting notification: $e');
    }
  }

  // Helper method to convert string type to NotificationType enum
  NotificationType _getNotificationType(String type) {
    switch (type) {
      // Types d'appels uniformisés avec les contrôleurs
      case 'text':
        return NotificationType.text;
      case 'voice':
        return NotificationType.voiceCall;
      case 'video':
        return NotificationType.videoCall;
      case 'cancel':
        return NotificationType.callCanceled;
      case 'accept':
        return NotificationType.acceptCall;

      // Pour la compatibilité avec les anciens types
      case 'voice_call':
        return NotificationType.voiceCall;
      case 'video_call':
        return NotificationType.videoCall;
      case 'call_canceled':
        return NotificationType.callCanceled;
      case 'accept_call':
        return NotificationType.acceptCall;

      // Types de notifications sociales
      case 'like':
        return NotificationType.like;
      case 'comment':
        return NotificationType.comment;
      case 'follow':
        return NotificationType.follow;
      case 'mention':
        return NotificationType.mention;
      case 'tag':
        return NotificationType.tag;
      case 'share':
        return NotificationType.share;
      case 'new_post':
        return NotificationType.newPost;
      case 'friend_request':
        return NotificationType.friendRequest;
      case 'friend_accept':
        return NotificationType.friendAccept;
      case 'system':
        return NotificationType.system;
      default:
        return NotificationType.system;
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

enum NotificationType {
  message,
  call,
  like,
  comment,
  follow
}

class AppNotification {
  final String id;
  final NotificationType type;
  final String title;
  final String message;
  final String? targetRoute;
  final Map<String, String>? routeParams;
  final DateTime timestamp;
  final bool isRead;

  AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    this.targetRoute,
    this.routeParams,
    required this.timestamp,
    this.isRead = false,
  });

  factory AppNotification.fromMessage(dynamic message) {
    return AppNotification(
      id: message.doc_id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      type: NotificationType.message,
      title: "${message.firstname} ${message.lastname}",
      message: message.last_msg ?? "Nouveau message",
      targetRoute: "/chat",
      routeParams: {
        "doc_id": message.doc_id ?? "",
        "to_token": message.token ?? "",
        "to_firstname": message.firstname ?? "",
        "to_lastname": message.lastname ?? "",
        "to_avatar": message.avatar ?? "",
        "to_online": message.online.toString(),
      },
      timestamp: message.last_time != null 
        ? (message.last_time as Timestamp).toDate()
        : DateTime.now(),
    );
  }

  factory AppNotification.fromCall(dynamic call) {
    return AppNotification(
      id: call.doc_id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      type: NotificationType.call,
      title: "${call.from_firstname} ${call.from_lastname}",
      message: call.type == "voice" ? "Appel vocal" : "Appel vidéo",
      timestamp: call.last_time != null 
        ? (call.last_time as Timestamp).toDate()
        : DateTime.now(),
    );
  }
}

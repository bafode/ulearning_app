import 'package:cloud_firestore/cloud_firestore.dart';

enum NotificationType {
  // Call notification types
  voiceCall,
  videoCall,
  callCanceled,
  acceptCall,
  text,
  
  // Social notification types
  like,
  comment,
  follow,
  mention,
  tag,
  share,
  newPost,
  friendRequest,
  friendAccept,
  system
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
  final String? targetId;
  final String? targetType;

  AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    this.targetRoute,
    this.routeParams,
    required this.timestamp,
    this.isRead = false,
    this.targetId,
    this.targetType,
  });

  factory AppNotification.fromMessage(dynamic message) {
    return AppNotification(
      id: message.doc_id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      type: NotificationType.text,
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
      targetId: message.doc_id,
      targetType: "message",
    );
  }

  factory AppNotification.fromCall(dynamic call) {
    NotificationType callType;
    if (call.type == "voice") {
      callType = NotificationType.voiceCall;
    } else if (call.type == "video") {
      callType = NotificationType.videoCall;
    } else if (call.type == "cancel") {
      callType = NotificationType.callCanceled;
    } else if (call.type == "accept") {
      callType = NotificationType.acceptCall;
    } else {
      callType = NotificationType.text;
    }
    
    return AppNotification(
      id: call.doc_id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      type: callType,
      title: "${call.from_firstname} ${call.from_lastname}",
      message: call.type == "voice" ? "Appel vocal" : 
               call.type == "video" ? "Appel vidéo" : 
               call.type == "cancel" ? "Appel manqué" : 
               call.type == "accept" ? "Appel accepté" : "Message",
      timestamp: call.last_time != null 
        ? (call.last_time as Timestamp).toDate()
        : DateTime.now(),
      targetId: call.doc_id,
      targetType: "call",
    );
  }
  
  // Create a notification from the backend response
  factory AppNotification.fromBackend(Map<String, dynamic> data) {
    // Convert backend type to frontend enum
    NotificationType getType(String backendType) {
      switch (backendType) {
        // Types d'appels uniformisés avec les contrôleurs
        case 'voice': return NotificationType.voiceCall;
        case 'video': return NotificationType.videoCall;
        case 'text': return NotificationType.text;
        case 'cancel': return NotificationType.callCanceled;
        case 'accept': return NotificationType.acceptCall;
        
        // Pour la compatibilité avec les anciens types
        case 'voice_call': return NotificationType.voiceCall;
        case 'video_call': return NotificationType.videoCall;
        case 'text_message': return NotificationType.text;
        case 'call_canceled': return NotificationType.callCanceled;
        case 'accept_call': return NotificationType.acceptCall;
        
        // Types de notifications sociales
        case 'like': return NotificationType.like;
        case 'comment': return NotificationType.comment;
        case 'follow': return NotificationType.follow;
        case 'mention': return NotificationType.mention;
        case 'tag': return NotificationType.tag;
        case 'share': return NotificationType.share;
        case 'new_post': return NotificationType.newPost;
        case 'friend_request': return NotificationType.friendRequest;
        case 'friend_accept': return NotificationType.friendAccept;
        case 'system': return NotificationType.system;
        default: return NotificationType.system;
      }
    }
    
    // Determine target route based on notification type
    String? targetRoute;
    Map<String, String>? routeParams;
    
    final type = getType(data['type'] as String);
    
    if (type == NotificationType.text || 
        type == NotificationType.voiceCall || 
        type == NotificationType.videoCall) {
      targetRoute = "/chat";
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
      targetRoute = "/post_detail";
      routeParams = {
        "post_id": data['targetId'] ?? "",
      };
    } else if (type == NotificationType.follow || 
               type == NotificationType.friendRequest || 
               type == NotificationType.friendAccept) {
      targetRoute = "/profile";
      routeParams = {
        "user_id": data['sender']['id'] ?? "",
      };
    }
    print("data: $data");
    return AppNotification(
      id: data['_id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      type: type,
      title: data['sender'] != null 
          ? "${data['sender']['firstname'] ?? ''} ${data['sender']['lastname'] ?? ''}"
          : "Notification",
      message: data['message'] ?? "Nouvelle notification",
      targetRoute: targetRoute,
      routeParams: routeParams,
      timestamp: data['createdAt'] != null 
          ? DateTime.parse(data['createdAt']) 
          : DateTime.now(),
      isRead: data['status'] == 'read',
      targetId: data['targetId'] ?? data['targetStringId'],
      targetType: data['targetType'],
    );
  }
}

import 'package:intl/intl.dart';

class SyncMessageRequestEntity {
  int? msgid;
  SyncMessageRequestEntity({
    this.msgid,
  });

  Map<String, dynamic> toJson() => {
        "msgid": msgid,
      };
}

class CallRequestEntity {
  String? call_type; //1. voice 2. video
  String? to_token;
  String? to_firstname;
  String? to_lastname;
  String? to_avatar;
  String? doc_id;

  CallRequestEntity({
    this.call_type,
    this.to_token,
    this.to_firstname,
    this.to_lastname,
    this.to_avatar,
    this.doc_id,
  });

  Map<String, dynamic> toJson() => {
        "call_type": call_type,
        "to_token": to_token,
        "to_firstname": to_firstname,
        "to_lastname": to_lastname,
        "to_avatar": to_avatar,
        "doc_id": doc_id,
      };
}

class CallTokenRequestEntity {
 
  String? channel_name;

  CallTokenRequestEntity({
    this.channel_name,
  });

  Map<String, dynamic> toJson() => {
        "channel_name": channel_name,
      };
}

class ChatRequestEntity {
  String? content;
  String? type;
  String? to_token;

  ChatRequestEntity({
    this.content,
    this.type,
    this.to_token,
  });

  Map<String, dynamic> toJson() => {
        "content": content,
        "type": type,
        "to_token": to_token,
      };
}

class Chat {
  String? from_token;
  String? to_token;
  int? msgid;
  String? content;
  String? type;
  int? status;
  String? created_at;

  Chat({
    this.from_token,
    this.to_token,
    this.msgid,
    this.content,
    this.type,
    this.status,
    this.created_at,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        from_token: json["from_token"],
        to_token: json["to_token"],
        msgid: json["msgid"],
        content: json["content"],
        type: json["type"],
        status: json["status"],
        created_at: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "from_token": from_token,
        "to_token": to_token,
        "msgid": msgid,
        "content": content,
        "type": type,
        "status": status,
        "created_at": created_at,
      };
}

class MsgListcontent {
  int? msgid;
  String? from_token;
  String? from_firstname;
  String? from_lastname;
  String? from_avatar;
  String? to_token;
  String? content;
  String? type;
  int? status;
  String? created_at;

  MsgListcontent({
    this.msgid,
    this.from_token,
    this.from_firstname,
    this.from_lastname,
    this.from_avatar,
    this.to_token,
    this.content,
    this.type,
    this.status,
    this.created_at,
  });

  factory MsgListcontent.fromJson(Map<String, dynamic> json) => MsgListcontent(
        from_token: json["from_token"],
        from_avatar: json["from_avatar"],
        from_firstname: json["from_firstname"],
        from_lastname: json["from_lastname"],
        to_token: json["to_token"],
        msgid: json["msgid"],
        content: json["content"],
        type: json["type"],
        status: json["status"],
        created_at: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "from_token": from_token,
        "from_firstname": from_firstname,
        "from_lastname": from_lastname,
        "from_avatar": from_avatar,
        "to_token": to_token,
        "msgid": msgid,
        "content": content,
        "type": type,
        "status": status,
        "created_at": created_at,
      };
}

class SyncMessageResponseEntity {
  int? code;
  String? msg;
  List<MsgListcontent>? data;

  SyncMessageResponseEntity({
    this.code,
    this.msg,
    this.data,
  });

  factory SyncMessageResponseEntity.fromJson(Map<String, dynamic> json) =>
      SyncMessageResponseEntity(
        code: json["code"],
        msg: json["msg"],
        data: json["data"] == null
            ? []
            : List<MsgListcontent>.from(
                json["data"].map((x) => MsgListcontent.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "counts": code,
        "msg": msg,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

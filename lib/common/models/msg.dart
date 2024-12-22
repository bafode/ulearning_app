import 'package:cloud_firestore/cloud_firestore.dart';

class Msg {
  final String? from_token;
  final String? to_token;
  final String? from_firstname;
  final String? from_lastname;
  final String? to_firstname;
  final String? to_lastname;
  final String? from_avatar;
  final String? to_avatar;
  final int? from_online;
  final int? to_online;
  final int? from_msg_num;
  final int? to_msg_num;
  final String? last_msg;
  final Timestamp? last_time;
  final int? msg_num;

  Msg({
    this.from_token,
    this.to_token,
    this.from_firstname,
    this.from_lastname,
    this.to_firstname,
    this.to_lastname,
    this.from_avatar,
    this.to_avatar,
    this.from_online,
    this.to_online,
    this.from_msg_num,
    this.to_msg_num,
    this.last_msg,
    this.last_time,
    this.msg_num,
  });

  factory Msg.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return Msg(
      from_token: data?['from_token'],
      to_token: data?['to_token'],
      from_firstname: data?['from_firstname'],
      from_lastname: data?['from_lastname'],
      to_firstname: data?['to_firstname'],
      to_lastname: data?['to_lastname'],
      from_avatar: data?['from_avatar'],
      to_avatar: data?['to_avatar'],
      from_online: data?['from_online'],
      to_online: data?['to_online'],
      from_msg_num: data?['from_msg_num'],
      to_msg_num: data?['to_msg_num'],
      last_msg: data?['last_msg'],
      last_time: data?['last_time'],
      msg_num: data?['msg_num'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (from_token != null) "from_token": from_token,
      if (to_token != null) "to_token": to_token,
      if (from_firstname != null) "from_firstname": from_firstname,
      if (from_lastname != null) "from_lastname": from_lastname,
      if (to_firstname != null) "to_firstname": to_firstname,
      if (to_lastname != null) "to_lastname": to_lastname,
      if (from_avatar != null) "from_avatar": from_avatar,
      if (to_avatar != null) "to_avatar": to_avatar,
      if (from_online != null) "from_online": from_online,
      if (to_online != null) "to_online": to_online,
      if (from_msg_num != null) "from_msg_num": from_msg_num,
      if (to_msg_num != null) "to_msg_num": to_msg_num,
      if (last_msg != null) "last_msg": last_msg,
      if (last_time != null) "last_time": last_time,
      if (msg_num != null) "msg_num": msg_num,
    };
  }
}

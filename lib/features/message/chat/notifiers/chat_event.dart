part of 'chat_notifier.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class ProfileChanged extends ChatEvent {
  const ProfileChanged(this.to_token,this.to_name,this.to_avatar,this.to_online);

  final String to_token;
  final String to_name;
  final String to_avatar;
  final String to_online;

  @override
  List<Object> get props => [to_token,to_name,to_avatar,to_online];
}
class MsgContentListChanged extends ChatEvent {
  const MsgContentListChanged(this.msgContentList);

  final Msgcontent msgContentList;

  @override
  List<Object> get props => [msgContentList];
}
class MsgContentAdd extends ChatEvent {
  const MsgContentAdd(this.msgContent);

  final Msgcontent msgContent;

  @override
  List<Object> get props => [msgContent];
}

class MsgContentClear extends ChatEvent {
  const MsgContentClear();
  @override
  List<Object> get props => [];
}

class isloadingChanged extends ChatEvent {
  const isloadingChanged(this.isloading);

  final bool isloading;

  @override
  List<Object> get props => [isloading];
}

class moreStatusChanged extends ChatEvent {
  const moreStatusChanged(this.more_status);

  final bool more_status;

  @override
  List<Object> get props => [more_status];
}



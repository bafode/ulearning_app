part of 'chat_notifier.dart';

class ChatState extends Equatable {
  const ChatState({
    this.to_token="",
    this.to_name="",
    this.to_avatar="",
    this.to_online="",
    this.isloading = false,
    this.more_status = false,
    this.msgcontentList = const <Msgcontent>[],
  });

  final String to_token;
  final String to_name;
  final String to_avatar;
  final String to_online;
  final bool isloading;
  final bool more_status;
  final List<Msgcontent> msgcontentList;


  ChatState copyWith({
    String? to_token,
    String? to_name,
    String? to_avatar,
    String? to_online,
    bool? isloading,
    bool? more_status,
    List<Msgcontent>? msgcontentList,
  }) {
    return ChatState(
      to_token: to_token ?? this.to_token,
      to_name: to_name ?? this.to_name,
      to_avatar: to_avatar ?? this.to_avatar,
      to_online: to_online ?? this.to_online,

      isloading: isloading ?? this.isloading,
      more_status: more_status ?? this.more_status,
      msgcontentList: msgcontentList ?? this.msgcontentList,
    );
  }


  @override
  List<Object> get props => [to_token,to_name,to_avatar,to_online,msgcontentList,isloading,more_status];
}

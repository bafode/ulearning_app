import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ulearning_app/common/models/entities.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatNotifier extends StateNotifier<ChatState> {
  ChatNotifier() : super(const ChatState());

  void onProfileChanged(
      ProfileChanged event,
      ) {
    //to_token,to_name,to_avatar,to_online
    state = state.copyWith(to_token: event.to_token,to_name:event.to_name,to_avatar:event.to_avatar,to_online:event.to_online);
  }

  void onMsgContentListChanged(
      MsgContentListChanged event,
      ) {
    var res = state.msgcontentList.toList();
    res.insert(0, event.msgContentList);
    state = state.copyWith(msgcontentList: res);
  }

  void onMsgContentAdd(
      MsgContentAdd event,
      ) {
       var res = state.msgcontentList.toList();
       res.add(event.msgContent);
       state = state.copyWith(msgcontentList: res);
  }
  void onMsgContentClear(
      MsgContentClear event,
      ) {
    state = state.copyWith(msgcontentList: []);
  }

  void onIsloadingChanged(
      isloadingChanged event,
      ) {
    state = state.copyWith(isloading: event.isloading);
  }

  void onMoreStatusChanged(
      moreStatusChanged event,
      ) {
    state = state.copyWith(more_status: event.more_status);
  }




}

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier();
});

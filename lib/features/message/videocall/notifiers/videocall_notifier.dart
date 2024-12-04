
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'videocall_event.dart';
part 'videocall_state.dart';

class VideoCallNotifier extends StateNotifier<VideoCallState> {
  VideoCallNotifier() : super(const VideoCallState()) {

  }

  void onUserInfoChanged(
      UserInfoChanged event,
      ) {
    state = state.copyWith(toAvatar: event.toAvatar,toName:event.toName);
  }

  void onCallTimeChanged(
      CallTimeChanged event,
      ) {
    state = state.copyWith(callTime: event.callTime);
  }

  void onIsJoinedChanged(
      IsJoinedChanged event,
      ) {
    state = state.copyWith(isJoined: event.isJoined);
  }


  void onIsReadyPreviewChanged(
      IsReadyPreviewChanged event,
      ) {
    state = state.copyWith(isReadyPreview: event.isReadyPreview);
  }

  void onIsShowAvatarChanged(
      IsShowAvatarChanged event,
      ) {
    state = state.copyWith(isShowAvatar: event.isShowAvatar);
  }

  void onSwitchCamerasChanged(
      SwitchCamerasChanged event,
      ) {
      state = state.copyWith(switchCameras: event.switchCameras);
  }

  void onSwitchviewChanged(
      SwitchviewChanged event,
      ) {
    state = state.copyWith(switchview: event.switchview);
  }

  void onSwitchRenderChanged(
      SwitchRenderChanged event,
      ) {
     state = state.copyWith(switchRender: event.switchRender);
  }
  void onRemoteUidChanged(
      RemoteUidChanged event,
      ) {
    state = state.copyWith(remoteUid: event.remoteUid);
  }

  void onChannelIdChanged(
      ChannelIdChanged event,
      ) {
    state = state.copyWith(channelId: event.channelId);
  }

}


final videoCallProvider = StateNotifierProvider<VideoCallNotifier, VideoCallState>((ref) {
  return VideoCallNotifier();
});
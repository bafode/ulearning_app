import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'voicecall_event.dart';
part 'voicecall_state.dart';

class VoiceCallNotifier extends StateNotifier<VoiceCallState> {
  VoiceCallNotifier() : super(const VoiceCallState()) {

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

  void onOpenMicrophoneChanged(
      OpenMicrophoneChanged event,
      ) {
    state = state.copyWith(openMicrophone: event.openMicrophone);
  }

  void onIsJoinedChanged(
      IsJoinedChanged event,
      ) {
    state = state.copyWith(isJoined: event.isJoined);
  }

  void onEnableSpeakerphoneChanged(
      EnableSpeakerphoneChanged event,
      ) {
    state = state.copyWith(enableSpeakerphone: event.enableSpeakerphone);
  }

}
final voiceCallProvider = StateNotifierProvider<VoiceCallNotifier, VoiceCallState>((ref) {
  return VoiceCallNotifier();
});

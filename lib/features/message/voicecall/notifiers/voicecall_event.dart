part of 'voicecall_notifier.dart';

abstract class VoiceCallEvent extends Equatable {
  const VoiceCallEvent();

  @override
  List<Object> get props => [];
}

class UserInfoChanged extends VoiceCallEvent {
  const UserInfoChanged(this.toAvatar,this.toName);

  final String toAvatar;
  final String toName;

  @override
  List<Object> get props => [toAvatar,toName];
}

class CallTimeChanged extends VoiceCallEvent {
  const CallTimeChanged(this.callTime);

  final String callTime;

  @override
  List<Object> get props => [callTime];
}

class OpenMicrophoneChanged extends VoiceCallEvent {
  const OpenMicrophoneChanged(this.openMicrophone);

  final bool openMicrophone;

  @override
  List<Object> get props => [openMicrophone];
}

class IsJoinedChanged extends VoiceCallEvent {
  const IsJoinedChanged(this.isJoined);

  final bool isJoined;

  @override
  List<Object> get props => [isJoined];
}

class EnableSpeakerphoneChanged extends VoiceCallEvent {
  const EnableSpeakerphoneChanged(this.enableSpeakerphone);

  final bool enableSpeakerphone;

  @override
  List<Object> get props => [enableSpeakerphone];
}

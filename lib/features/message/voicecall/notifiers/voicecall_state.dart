part of 'voicecall_notifier.dart';

class VoiceCallState extends Equatable {
  const VoiceCallState({
    this.callTime="00:00",
    this.toAvatar="",
    this.toName="",
    this.openMicrophone=true,
    this.isJoined=false,
    this.enableSpeakerphone=true,
  });

  final String callTime;
  final String toAvatar;
  final String toName;
  final bool openMicrophone;
  final bool isJoined;
  final bool enableSpeakerphone;

  VoiceCallState copyWith({
    String? callTime,
    String? toAvatar,
    String? toName,
    bool? openMicrophone,
    bool? isJoined,
    bool? enableSpeakerphone,
  }) {
    return VoiceCallState(
      callTime: callTime ?? this.callTime,
      toAvatar: toAvatar ?? this.toAvatar,
      toName: toName ?? this.toName,
      openMicrophone: openMicrophone ?? this.openMicrophone,
      isJoined: isJoined ?? this.isJoined,
      enableSpeakerphone: enableSpeakerphone ?? this.enableSpeakerphone,
    );
  }

  @override
  List<Object> get props => [callTime,toAvatar,toName,openMicrophone,isJoined,enableSpeakerphone];
}

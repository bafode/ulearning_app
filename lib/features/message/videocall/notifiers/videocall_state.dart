part of 'videocall_notifier.dart';

class VideoCallState extends Equatable {
  const VideoCallState({
    this.callTime="00:00",
    this.toAvatar="",
    this.toName="",
    this.isJoined=false,
    this.isReadyPreview=false,
    this.isShowAvatar=true,
    this.switchCameras=true,
    this.switchview=true,
    this.switchRender=true,
    this.remoteUid=0,
    this.channelId="",
  });

  final String callTime;
  final String toAvatar;
  final String toName;
  final bool isJoined;
  final bool isReadyPreview;
  final bool isShowAvatar;
  final bool switchCameras;
  final bool switchview;
  final bool switchRender;
  final int remoteUid;
  final String channelId;
// = <int>{}
  VideoCallState copyWith({
    String? callTime,
    String? toAvatar,
    String? toName,
    bool? isJoined,
    bool? isReadyPreview,
    bool? isShowAvatar,
    bool? switchCameras,
    bool? switchview,
    bool? switchRender,
    int? remoteUid,
    String? channelId,
  }) {
    return VideoCallState(
      callTime: callTime ?? this.callTime,
      toAvatar: toAvatar ?? this.toAvatar,
      toName: toName ?? this.toName,
      isJoined: isJoined ?? this.isJoined,
      isReadyPreview: isReadyPreview ?? this.isReadyPreview,
      isShowAvatar: isShowAvatar ?? this.isShowAvatar,
      switchCameras: switchCameras ?? this.switchCameras,
      switchview: switchview ?? this.switchview,
      switchRender: switchRender ?? this.switchRender,
      remoteUid: remoteUid ?? this.remoteUid,
      channelId: channelId ?? this.channelId,
    );
  }

  @override
  List<Object> get props => [callTime,toAvatar,toName,isJoined,isReadyPreview,isShowAvatar,switchCameras,switchview,switchRender,remoteUid,channelId];
}
part of 'videocall_notifier.dart';

abstract class VideoCallEvent extends Equatable {
  const VideoCallEvent();

  @override
  List<Object> get props => [];
}

class UserInfoChanged extends VideoCallEvent {
  const UserInfoChanged(this.toAvatar,this.toName);

  final String toAvatar;
  final String toName;

  @override
  List<Object> get props => [toAvatar,toName];
}

class CallTimeChanged extends VideoCallEvent {
  const CallTimeChanged(this.callTime);

  final String callTime;

  @override
  List<Object> get props => [callTime];
}

class IsJoinedChanged extends VideoCallEvent {
  const IsJoinedChanged(this.isJoined);

  final bool isJoined;

  @override
  List<Object> get props => [isJoined];
}


class IsReadyPreviewChanged extends VideoCallEvent {
  const IsReadyPreviewChanged(this.isReadyPreview);

  final bool isReadyPreview;

  @override
  List<Object> get props => [isReadyPreview];
}

class IsShowAvatarChanged extends VideoCallEvent {
  const IsShowAvatarChanged(this.isShowAvatar);

  final bool isShowAvatar;

  @override
  List<Object> get props => [isShowAvatar];
}

class SwitchCamerasChanged extends VideoCallEvent {
  const SwitchCamerasChanged(this.switchCameras);

  final bool switchCameras;

  @override
  List<Object> get props => [switchCameras];
}

class SwitchviewChanged extends VideoCallEvent {
  const SwitchviewChanged(this.switchview);

  final bool switchview;

  @override
  List<Object> get props => [switchview];
}

class SwitchRenderChanged extends VideoCallEvent {
  const SwitchRenderChanged(this.switchRender);

  final bool switchRender;

  @override
  List<Object> get props => [switchRender];
}

class RemoteUidChanged extends VideoCallEvent {
  const RemoteUidChanged(this.remoteUid);

  final int remoteUid;

  @override
  List<Object> get props => [remoteUid];
}

class ChannelIdChanged extends VideoCallEvent {
  const ChannelIdChanged(this.channelId);

  final String channelId;

  @override
  List<Object> get props => [channelId];
}
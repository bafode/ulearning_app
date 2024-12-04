part of 'message_notifier.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object> get props => [];
}

class MessageChanged extends MessageEvent {
  const MessageChanged(this.message);

  final List<Message> message;

  @override
  List<Object> get props => [message];
}
class LoadStatusChanged extends MessageEvent {
  const LoadStatusChanged(this.loadStatus);

  final bool loadStatus;

  @override
  List<Object> get props => [loadStatus];
}


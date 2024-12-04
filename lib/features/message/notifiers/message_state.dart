part of 'message_notifier.dart';

class MessageState extends Equatable {
  const MessageState({
    this.message = const <Message>[],
    this.loadStatus = true,
  });

  final List<Message> message;
  final bool loadStatus;

  MessageState copyWith({
    List<Message>? message,
    bool? loadStatus,
  }) {
    return MessageState(
      message: message ?? this.message,
      loadStatus: loadStatus ?? this.loadStatus,
    );
  }

  @override
  List<Object> get props => [message,loadStatus];
}

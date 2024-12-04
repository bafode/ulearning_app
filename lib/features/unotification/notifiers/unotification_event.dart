part of 'unotification_notifier.dart';

abstract class UnotificationEvent extends Equatable {
  const UnotificationEvent();

  @override
  List<Object> get props => [];
}

class PageChanged extends UnotificationEvent {
  const PageChanged(this.page);

  final int page;

  @override
  List<Object> get props => [page];
}


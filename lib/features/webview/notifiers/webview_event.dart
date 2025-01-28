part of 'webview_notifier.dart';

abstract class WebviewEvent extends Equatable {
  const WebviewEvent();

  @override
  List<Object> get props => [];
}

class UrlChanged extends WebviewEvent {
  const UrlChanged(this.url);

  final String url;

  @override
  List<Object> get props => [url];
}

part of 'webview_notifier.dart';

class WebviewState extends Equatable {
  const WebviewState({
    this.url="",
  });

  final String url;

  WebviewState copyWith({
    String? url,
  }) {
    return WebviewState(
      url: url ?? this.url,
    );
  }

  @override
  List<Object> get props => [url];
}

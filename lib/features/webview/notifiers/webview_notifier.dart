import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'webview_event.dart';
part 'webview_state.dart';

class WebviewNotifier extends StateNotifier<WebviewState> {
  WebviewNotifier() : super(const WebviewState());

  void onUrlChanged(
    UrlChanged event,
  ) {
    state = state.copyWith(url: event.url);
  }
}

final webviewProvider =
    StateNotifierProvider<WebviewNotifier, WebviewState>((ref) {
  return WebviewNotifier();
});

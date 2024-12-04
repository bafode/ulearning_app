import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'photoview_event.dart';
part 'photoview_state.dart';

class PhotoViewNotifier extends StateNotifier<PhotoViewState> {
  PhotoViewNotifier() : super(const PhotoViewState()) {
  }

  void onPhotoViewChanged(
      PhotoViewChanged event,
      ) {
    state = state.copyWith(url: event.url);
  }

}
final photoViewProvider = StateNotifierProvider<PhotoViewNotifier, PhotoViewState>((ref) {
  return PhotoViewNotifier();
});

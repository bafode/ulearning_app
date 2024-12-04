part of 'photoview_notifier.dart';

class PhotoViewState extends Equatable {
  const PhotoViewState({
    this.url="",
  });

  final String url;

  PhotoViewState copyWith({
    String? url,
  }) {
    return PhotoViewState(
      url: url ?? this.url,
    );
  }

  @override
  List<Object> get props => [url];
}

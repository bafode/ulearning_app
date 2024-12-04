part of 'photoview_notifier.dart';

abstract class PhotoViewEvent extends Equatable {
  const PhotoViewEvent();

  @override
  List<Object> get props => [];
}

class PhotoViewChanged extends PhotoViewEvent {
  const PhotoViewChanged(this.url);

  final String url;

  @override
  List<Object> get props => [url];
}


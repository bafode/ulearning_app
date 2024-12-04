part of 'unotification_notifier.dart';

class UnotificationState extends Equatable {
  const UnotificationState({
    this.page=0,
  });

  final int page;

  UnotificationState copyWith({
    int? page,
  }) {
    return UnotificationState(
      page: page ?? this.page,
    );
  }

  @override
  List<Object> get props => [page];
}

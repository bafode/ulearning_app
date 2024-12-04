import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'unotification_event.dart';
part 'unotification_state.dart';

class UnotificationNotifier extends StateNotifier<UnotificationState> {
  UnotificationNotifier() : super(const UnotificationState()) {
  }

  void onPageChanged(
      PageChanged event,
      ) {
    state = state.copyWith(page: event.page);
  }

}

final unotificationProvider = StateNotifierProvider<UnotificationNotifier, UnotificationState>((ref) {
  return UnotificationNotifier();
});

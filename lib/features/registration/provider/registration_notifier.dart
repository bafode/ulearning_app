import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'registration_notifier.g.dart';

@riverpod
class RegistrationIndexDot extends _$RegistrationIndexDot {
  @override
  int build() {
    return 0;
  }

  void changeIndex(int value) {
    state = value;
  }
}

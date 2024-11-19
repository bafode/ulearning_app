import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'step_notifier.g.dart';

@riverpod
class RegistrationCurrentStep extends _$RegistrationCurrentStep {
  @override
  int build() {
    return 0;
  }

  void setCurrentStep(int value) {
    state = value;
  }
}

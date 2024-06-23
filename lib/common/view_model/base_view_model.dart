import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:developer' as dev;

abstract class BaseViewModel {
  BaseViewModel(this._ref);

  final anyUseCaseInProgress = StateProvider<bool>((_) => false);
  final anyUseCaseFailed = StateProvider<Object?>((_) => null);

  final ProviderRef _ref;

  executeUseCase(
      {Future<dynamic> Function()? useCase,
      Function(bool)? inProgress,
      Function(Object?)? onError}) async {
    if (inProgress != null) {
      inProgress(true);
    } else {
      _ref.read(anyUseCaseInProgress.notifier).state = true;
    }
    try {
      await useCase?.call();
    } catch (error) {
      dev.log(error.toString());
      if (onError != null) {
        onError(error);
      } else {
        _ref.read(anyUseCaseFailed.notifier).state = error;
      }
    } finally {
      if (inProgress != null) {
        inProgress(false);
      } else {
        _ref.read(anyUseCaseInProgress.notifier).state = false;
      }
    }
  }

  updateState<T>(StateProvider<T> state, T value) {
    _ref.read(state.notifier).state = value;
  }
}

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension AsyncErrorExceptionExtension on AsyncValue {
  DioException? get dioException {
    final err = error;
    if (err is DioException) {
      return err;
    }
    return null;
  }
}


extension DioErrorExtension on Object? {
  String get errorMessage {
    if (this is DioException) {
      final dioError = this as DioException;
      return switch (dioError.type) {
        DioExceptionType.cancel => 'Request to API server was cancelled',
        DioExceptionType.connectionTimeout =>
          'Connection timeout with API server',
        DioExceptionType.unknown => 'Please check your internet connection',
        DioExceptionType.receiveTimeout =>
          'Receive timeout in connection with API server',
        DioExceptionType.badResponse =>
          'Something went wrong. Please try again',
        DioExceptionType.sendTimeout =>
          'Send timeout in connection with API server',
        DioExceptionType.badCertificate => 'Unexpected error occured',
        DioExceptionType.connectionError => 'Unexpected error occured',
      };
    }
    return 'An unexpected error occurred.';
  }
}


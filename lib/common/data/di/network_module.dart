import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beehive/common/data/remote/auth_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:beehive/common/utils/constants.dart';

final dioProvider = Provider((ref) {
  final options = BaseOptions(baseUrl: AppConstants.SERVER_API_URL);
  final dio = Dio(options);
  dio.interceptors.add(ref.read(authInterceptorProvider));
  if (!kReleaseMode) {
    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
    ));
  }
  return dio;
});

final authInterceptorProvider = Provider((ref) => AuthInterceptor());

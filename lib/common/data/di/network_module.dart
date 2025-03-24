import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beehive/common/data/remote/auth_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:beehive/common/utils/constants.dart';

final dioProvider = Provider((ref) {
  final options = BaseOptions(
    baseUrl: AppConstants.SERVER_API_URL,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 10),
    sendTimeout: const Duration(seconds: 10),
    // Permettre aux réponses 401 de ne pas lever d'exception
    // pour pouvoir les traiter correctement dans le code
    validateStatus: (status) {
      return status != null && (status >= 200 && status < 300 || status == 401 || status == 400);
    },
  );
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

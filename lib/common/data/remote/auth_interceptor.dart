import 'package:dio/dio.dart';
import 'package:beehive/common/entities/auth/token/tokens.dart';
import 'package:beehive/global.dart';

class AuthInterceptor extends Interceptor {
  @override
  Future onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    Tokens? tokens = Global.storageService.getTokens();
    if (tokens != null) {
      options.headers['Authorization'] = 'Bearer ${tokens.access.token}';
    }
    options.headers['Content-Type'] = 'application/json';
    return super.onRequest(options, handler);
  }
}

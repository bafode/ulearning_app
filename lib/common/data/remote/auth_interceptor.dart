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
    
    // Ne pas écraser le Content-Type s'il est déjà défini dans les options
    // Cela permet aux requêtes multipart de conserver leur Content-Type approprié
    if (options.contentType == null && !options.headers.containsKey('Content-Type')) {
      options.headers['Content-Type'] = 'application/json';
    }
    
    return super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String errorMessage = 'Une erreur est survenue';
    
    if (err.type == DioExceptionType.connectionTimeout) {
      errorMessage = 'Le délai de connexion au serveur a expiré';
    } else if (err.type == DioExceptionType.receiveTimeout) {
      errorMessage = 'Le délai de réception des données a expiré';
    } else if (err.type == DioExceptionType.sendTimeout) {
      errorMessage = 'Le délai d\'envoi des données a expiré';
    }

    final error = DioException(
      requestOptions: err.requestOptions,
      error: errorMessage,
      type: err.type,
      response: err.response,
    );
    
    handler.reject(error);
  }
}

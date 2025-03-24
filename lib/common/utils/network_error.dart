import 'package:beehive/common/entities/error/api_error_detail.dart';
import 'package:beehive/common/entities/error/api_error_response.dart';
import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart'; 
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

// Assurez-vous d'importer dartz




class DioErrorHandler {
  /// Traite les exceptions Dio et les convertit en ApiErrorResponse
  static Either<ApiErrorResponse, T> handleDioException<T>(DioException e) {
    if (e.response != null && e.response!.data != null) {
      try {
        final errorData = e.response!.data;
        int? code = e.response!.statusCode;
        String? message = errorData['message'] ?? 'Erreur inconnue';
        List<ApiErrorDetail> details = [];
        
        // Extraire les détails d'erreur si disponibles
        if (errorData['details'] != null && errorData['details'] is List) {
          details = (errorData['details'] as List)
              .map((detail) => ApiErrorDetail(
                    field: detail['field'],
                    message: detail['message'],
                  ))
              .toList();
        }
        
        return Left(ApiErrorResponse(
          code: code,
          message: message,
          details: details,
          stack: errorData['stack'],
        ));
      } catch (_) {
        // Si l'extraction échoue, utiliser les informations de base
        return Left(ApiErrorResponse(
          code: e.response?.statusCode,
          message: 'Erreur de serveur: ${e.message}',
          details: [],
        ));
      }
    }
    
    // Gérer le cas où e.response est null
    return Left(ApiErrorResponse(
      code: 500,
      message: 'Erreur de connexion: ${e.message}',
      details: [],
    ));
  }
  
  /// Méthode d'aide pour créer un Right (succès)
  static Either<ApiErrorResponse, T> success<T>(T data) {
    return Right(data);
  }
}


import 'package:beehive/common/data/remote/rest_client_api.dart';
import 'package:beehive/common/data/repository/auth_repository.dart';
import 'package:beehive/common/entities/auth/forgotPasswordRequest/forgot_password_request.dart';
import 'package:beehive/common/entities/auth/loginRequest/login_request.dart';
import 'package:beehive/common/entities/auth/loginResponse/login_response.dart';
import 'package:beehive/common/entities/auth/logoutRequest/logout_request.dart';
import 'package:beehive/common/entities/auth/logoutResponse/logout_response.dart';
import 'package:beehive/common/entities/auth/registrationRequest/registration_request.dart';
import 'package:beehive/common/entities/auth/registrationResponse/registration_response.dart';
import 'package:beehive/common/entities/auth/resetPasswordRequest/reset_password_request.dart';
import 'package:beehive/common/entities/auth/updateUserInfoRequest/update_user_info_request.dart';
import 'package:beehive/common/entities/auth/verifyEmailRequest/verify_email_request.dart';
import 'package:beehive/common/entities/contact/contactResponse/contact_response_entity.dart';
import 'package:beehive/common/entities/error/api_error_response.dart';
import 'package:beehive/common/entities/user/editProfileRequest/edit_profil_request.dart';
import 'package:beehive/common/entities/user/user.dart';
import 'package:beehive/common/utils/network_error.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class AuthRepositoryImpl extends AuthRepository {
  final RestClientApi api;

  AuthRepositoryImpl(this.api);

  @override
  Future<Either<ApiErrorResponse, LoginResponse>> login(LoginRequest params) async {
    try {
      final response = await api.login(loginRequest: params);
      if (response.code! >= 400) {
        return Left(ApiErrorResponse(
            code: response.code,
            message: response.message,
            details: response.details,
            stack: response.stack));
      } else {
        return Right(response);
      }
    } catch (e) {
      // Gérer les exceptions non liées à la réponse de l'API
      if (e is DioException) {
        // Extraire les informations d'erreur de la réponse Dio
        return DioErrorHandler.handleDioException(e);
      }
      
      // Fallback pour les autres types d'erreurs
      return Left(ApiErrorResponse(
          code: 500,
          message: 'Erreur de connexion: ${e.toString()}',
          details: []));
    }
  }

  @override
  Future<Either<ApiErrorResponse, LoginResponse>> register(
      RegistrationRequest params) async {
    try {
      final response = await api.register(registrationRequest: params);

      if (response.code! >= 400) {
        return Left(ApiErrorResponse(
          code: response.code,
          message: response.message,
          details: response.details, 
          stack: response.stack
        ));
      }
      else {
        return Right(response);
      }
    } catch (e) {
      // Gérer les exceptions non liées à la réponse de l'API
      if (e is DioException) {
        return DioErrorHandler.handleDioException(e);
      }
      
      // Fallback pour les autres types d'erreurs
      return Left(ApiErrorResponse(
          code: 500,
          message: 'Erreur de connexion: ${e.toString()}',
          details: []));
    }
  }


  @override
  Future<void> sendEmailVerificationToken() async {
    await api.sendEmailVerificationToken();
  }
 
  @override
  Future<RegistrationResponse> verifyEmail(VerifyEmailRequest token) async {
    final response = await api.verifyEmail(verifyEmailRequest: token);
    return response;
  }

  @override
  Future<RegistrationResponse> forgotPassword(ForgotPasswordRequest forgotPasswordRequest) async {
    final response = await api.forgotPassword(forgotPasswordRequest: forgotPasswordRequest);
    return response;
  }

  @override
  Future<RegistrationResponse> resetPassword(
      ResetPasswordRequest resetPasswordRequest) async {
    final response =
        await api.resetPassword(resetPasswordRequest: resetPasswordRequest);
    return response;
  }

  @override
  Future<LogoutResponse> logout(LogoutRequest refreshToken) async {
    final response = await api.logout(refreshToken: refreshToken);
    return response;
  }

  @override
  Future<LogoutResponse> deleteAccount(String userId) async {
    final response = await api.deleteAccount(userId);
    return response;
  }

  @override
  Future<User> updateUserInfo(String userId, UpdateUserInfoRequest userInfo) async {
    try {
      final response = await api.updateUser(userId, userInfo);
      return response;
    } catch (e) {
      // Gérer les exceptions et les convertir en un format utilisable
      if (e is DioException) {
        // Extraire les informations d'erreur de la réponse Dio
        if (e.response != null && e.response!.data != null) {
          final errorData = e.response!.data;
          String errorMessage = 'Erreur lors de la mise à jour du profil';
          
          // Essayer d'extraire un message plus spécifique
          if (errorData is Map<String, dynamic>) {
            if (errorData.containsKey('message')) {
              errorMessage = errorData['message'];
            }
            
            // Vérifier les détails pour des erreurs spécifiques
            if (errorData.containsKey('details') && errorData['details'] is List) {
              final details = errorData['details'] as List;
              if (details.isNotEmpty && details[0] is Map<String, dynamic>) {
                final detail = details[0] as Map<String, dynamic>;
                if (detail.containsKey('message')) {
                  errorMessage = detail['message'];
                }
              }
            }
          }
          
          throw Exception(errorMessage);
        }
      }
      
      // Rethrow pour les autres types d'erreurs
      throw Exception('Erreur lors de la mise à jour du profil: ${e.toString()}');
    }
  }

  @override
  Future<User> getUserById(String userId) async {
    final response = await api.getUserById(userId);
    return response;
  }

  @override
  Future<User> updateUserProfile(String userId, EditProfilRequest userInfo) async {
    try {
      final response = await api.updateUserProfile(userId, userInfo);
      return response;
    } catch (e) {
      // Gérer les exceptions et les convertir en un format utilisable
      if (e is DioException) {
        // Extraire les informations d'erreur de la réponse Dio
        if (e.response != null && e.response!.data != null) {
          final errorData = e.response!.data;
          String errorMessage = 'Erreur lors de la mise à jour du profil';
          
          // Essayer d'extraire un message plus spécifique
          if (errorData is Map<String, dynamic>) {
            if (errorData.containsKey('message')) {
              errorMessage = errorData['message'];
            }
            
            // Vérifier les détails pour des erreurs spécifiques
            if (errorData.containsKey('details') && errorData['details'] is List) {
              final details = errorData['details'] as List;
              if (details.isNotEmpty && details[0] is Map<String, dynamic>) {
                final detail = details[0] as Map<String, dynamic>;
                if (detail.containsKey('message')) {
                  errorMessage = detail['message'];
                }
              }
            }
          }
          
          throw Exception(errorMessage);
        }
      }
      
      // Rethrow pour les autres types d'erreurs
      throw Exception('Erreur lors de la mise à jour du profil: ${e.toString()}');
    }
  }

  @override
  Future<ContactResponseEntity> getContacts() async {
    final response = await api.getContacts();
    return response;
  }

  @override
  Future<ContactResponseEntity> getFollowers(String userId) async {
    final response = await api.getFollowers(userId);
    return response;
  }

  @override
  Future<ContactResponseEntity> getFollowings(String userId) async {
    final response = await api.getFollowings(userId);
    return response;
  }
}

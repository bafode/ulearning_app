import 'package:ulearning_app/common/data/remote/rest_client_api.dart';
import 'package:ulearning_app/common/data/repository/auth_repository.dart';
import 'package:ulearning_app/common/entities/auth/loginRequest/login_request.dart';
import 'package:ulearning_app/common/entities/auth/loginResponse/login_response.dart';
import 'package:ulearning_app/common/entities/auth/logoutRequest/logout_request.dart';
import 'package:ulearning_app/common/entities/auth/logoutResponse/logout_response.dart';
import 'package:ulearning_app/common/entities/auth/registrationRequest/registration_request.dart';
import 'package:ulearning_app/common/entities/auth/registrationResponse/registration_response.dart';
import 'package:ulearning_app/common/entities/auth/updateUserInfoRequest/update_user_info_request.dart';
import 'package:ulearning_app/common/entities/auth/verifyEmailRequest/verify_email_request.dart';
import 'package:ulearning_app/common/models/entities.dart';

class AuthRepositoryImpl extends AuthRepository {
  final RestClientApi api;

  AuthRepositoryImpl(this.api);

  @override
  Future<LoginResponse> login(LoginRequest params) async {
    final response = await api.login(loginRequest: params);
    return response;
  }

  @override
  Future<LoginResponse> register(RegistrationRequest params) async {
    final response = await api.register(registrationRequest: params);
    return response;
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
  Future<LogoutResponse> logout(LogoutRequest refreshToken) async {
    final response = await api.logout(refreshToken: refreshToken);
    return response;
  }

  @override
  Future<User> updateUserInfo(String userId, UpdateUserInfoRequest userInfo) async {
      final response = await api.updateUser(
      userId: userId,
      updateUserInfoRequest: userInfo,
    );
    return response;
  }
}

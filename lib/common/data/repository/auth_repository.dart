import 'package:ulearning_app/common/entities/auth/loginRequest/login_request.dart';
import 'package:ulearning_app/common/entities/auth/loginResponse/login_response.dart';
import 'package:ulearning_app/common/entities/auth/logoutRequest/logout_request.dart';
import 'package:ulearning_app/common/entities/auth/logoutResponse/logout_response.dart';
import 'package:ulearning_app/common/entities/auth/registrationRequest/registration_request.dart';
import 'package:ulearning_app/common/entities/auth/registrationResponse/registration_response.dart';
import 'package:ulearning_app/common/entities/auth/verifyEmailRequest/verify_email_request.dart';

abstract class AuthRepository {
  Future<LoginResponse?> login(LoginRequest params);
  Future<RegistrationResponse> register(RegistrationRequest params);
  Future<RegistrationResponse> verifyEmail(VerifyEmailRequest token);
  Future<LogoutResponse> logout(LogoutRequest refreshToken);
}

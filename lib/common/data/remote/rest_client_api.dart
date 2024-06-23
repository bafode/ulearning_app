import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';
import 'package:ulearning_app/common/data/di/network_module.dart';
import 'package:ulearning_app/common/data/remote/models/paginated_post_response.dart';
import 'package:ulearning_app/common/entities/auth/loginRequest/login_request.dart';
import 'package:ulearning_app/common/entities/auth/loginResponse/login_response.dart';
import 'package:ulearning_app/common/entities/auth/logoutRequest/logout_request.dart';
import 'package:ulearning_app/common/entities/auth/logoutResponse/logout_response.dart';
import 'package:ulearning_app/common/entities/auth/registrationRequest/registration_request.dart';
import 'package:ulearning_app/common/entities/auth/registrationResponse/registration_response.dart';
import 'package:ulearning_app/common/entities/auth/verifyEmailRequest/verify_email_request.dart';
import 'package:ulearning_app/common/entities/post/createPostResponse/post_create_response.dart';
import 'package:ulearning_app/common/utils/constants.dart';

part 'rest_client_api.g.dart';

final restClientApiProvider =
    Provider((ref) => RestClientApi(ref.watch(dioProvider)));

@RestApi()
abstract class RestClientApi {
  factory RestClientApi(Dio dio, {String baseUrl}) = _RestClientApi;

  @GET(AppConstants.postEndPointUrl)
  Future<PostResponse> getPosts({
    // @Query("q") required String query,
    @Query("sort") String? sort,
    @Query("order") String? order,
    @Query("page") int? page,
    @Query("limit") int? limit,
  });

  @POST(AppConstants.loginEndPointUrl)
  Future<LoginResponse> login({
    @Body() required LoginRequest loginRequest,
  });

  @POST(AppConstants.registrationEndPointUrl)
  Future<RegistrationResponse> register({
    @Body() required RegistrationRequest registrationRequest,
  });

  @POST(AppConstants.emailVerificationUrl)
  Future<RegistrationResponse> verifyEmail({
    @Body() required VerifyEmailRequest verifyEmailRequest,
  });

  @POST(AppConstants.logoutEndPointUrl)
  Future<LogoutResponse> logout({
    @Body() required LogoutRequest refreshToken,
  });

  @POST(AppConstants.postEndPointUrl)
  @MultiPart()
  Future<PostCreateResponse> createPost(
      @Part(name: 'title') String title,
      @Part(name: 'content') String content,
      @Part(name: 'category') String category,
      @Part() List<MultipartFile>? media,
      {@SendProgress() ProgressCallback? onSendProgress});
}

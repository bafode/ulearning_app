// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) => LoginRequest(
      email: json['email'] as String?,
      password: json['password'] as String?,
    );

Map<String, dynamic> _$LoginRequestToJson(LoginRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
    };

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      code: (json['code'] as num).toInt(),
      message: json['message'] as String,
      user: UserG.fromJson(json['user'] as Map<String, dynamic>),
      tokens: TokensG.fromJson(json['tokens'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'user': instance.user,
      'tokens': instance.tokens,
    };

UserG _$UserGFromJson(Map<String, dynamic> json) => UserG(
      firstname: json['firstname'] as String,
      lastname: json['lastname'] as String,
      email: json['email'] as String,
      avatar: json['avatar'] as String,
      description: json['description'] as String,
      role: json['role'] as String,
      isEmailVerified: json['isEmailVerified'] as bool,
      accountClosed: json['accountClosed'] as bool,
      id: json['id'] as String,
    );

Map<String, dynamic> _$UserGToJson(UserG instance) => <String, dynamic>{
      'firstname': instance.firstname,
      'lastname': instance.lastname,
      'email': instance.email,
      'avatar': instance.avatar,
      'description': instance.description,
      'role': instance.role,
      'isEmailVerified': instance.isEmailVerified,
      'accountClosed': instance.accountClosed,
      'id': instance.id,
    };

TokensG _$TokensGFromJson(Map<String, dynamic> json) => TokensG(
      access: AccessTokenG.fromJson(json['access'] as Map<String, dynamic>),
      refresh: RefreshTokenG.fromJson(json['refresh'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TokensGToJson(TokensG instance) => <String, dynamic>{
      'access': instance.access,
      'refresh': instance.refresh,
    };

AccessTokenG _$AccessTokenGFromJson(Map<String, dynamic> json) => AccessTokenG(
      token: json['token'] as String,
      expires: json['expires'] as String,
    );

Map<String, dynamic> _$AccessTokenGToJson(AccessTokenG instance) =>
    <String, dynamic>{
      'token': instance.token,
      'expires': instance.expires,
    };

RefreshTokenG _$RefreshTokenGFromJson(Map<String, dynamic> json) =>
    RefreshTokenG(
      token: json['token'] as String,
      expires: json['expires'] as String,
    );

Map<String, dynamic> _$RefreshTokenGToJson(RefreshTokenG instance) =>
    <String, dynamic>{
      'token': instance.token,
      'expires': instance.expires,
    };

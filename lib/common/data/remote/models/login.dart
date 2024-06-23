import 'package:json_annotation/json_annotation.dart';

part 'login.g.dart';

@JsonSerializable()
class LoginRequest {
  const LoginRequest({this.email, this.password});

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  final String? email;
  final String? password;

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

@JsonSerializable()
class LoginResponse {
  @JsonKey(name: 'code')
  final int code;
  @JsonKey(name: 'message')
  final String message;
  @JsonKey(name: 'user')
  final UserG user;
  @JsonKey(name: 'tokens')
  final TokensG tokens;

  LoginResponse({
    required this.code,
    required this.message,
    required this.user,
    required this.tokens,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

@JsonSerializable()
class UserG {
  @JsonKey(name: 'firstname')
  final String firstname;
  @JsonKey(name: 'lastname')
  final String lastname;
  @JsonKey(name: 'email')
  final String email;
  @JsonKey(name: 'avatar')
  final String avatar;
  @JsonKey(name: 'description')
  final String description;
  @JsonKey(name: 'role')
  final String role;
  @JsonKey(name: 'isEmailVerified')
  final bool isEmailVerified;
  @JsonKey(name: 'accountClosed')
  final bool accountClosed;
  @JsonKey(name: 'id')
  final String id;

  UserG({
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.avatar,
    required this.description,
    required this.role,
    required this.isEmailVerified,
    required this.accountClosed,
    required this.id,
  });

  factory UserG.fromJson(Map<String, dynamic> json) => _$UserGFromJson(json);
}

@JsonSerializable()
class TokensG {
  @JsonKey(name: 'access')
  final AccessTokenG access;
  @JsonKey(name: 'refresh')
  final RefreshTokenG refresh;

  TokensG({
    required this.access,
    required this.refresh,
  });

  factory TokensG.fromJson(Map<String, dynamic> json) =>
      _$TokensGFromJson(json);
}

@JsonSerializable()
class AccessTokenG {
  @JsonKey(name: 'token')
  final String token;
  @JsonKey(name: 'expires')
  final String expires;

  AccessTokenG({
    required this.token,
    required this.expires,
  });

  factory AccessTokenG.fromJson(Map<String, dynamic> json) =>
      _$AccessTokenGFromJson(json);
}

@JsonSerializable()
class RefreshTokenG {
  @JsonKey(name: 'token')
  final String token;
  @JsonKey(name: 'expires')
  final String expires;

  RefreshTokenG({
    required this.token,
    required this.expires,
  });

  factory RefreshTokenG.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenGFromJson(json);
}

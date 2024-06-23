import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
class User with _$User {
  const factory User({
    required String firstname,
    required String lastname,
    required String email,
    required String avatar,
    required String description,
    required String role,
    required bool isEmailVerified,
    required bool accountClosed,
    required String id,
  }) = _User;
}

@freezed
class Tokens with _$Tokens {
  const factory Tokens({
    required AccessToken access,
    required RefreshToken refresh,
  }) = _Tokens;
}

@freezed
class AccessToken with _$AccessToken {
  const factory AccessToken({
    required String token,
    required String expires,
  }) = _AccessToken;
}

@freezed
class RefreshToken with _$RefreshToken {
  const factory RefreshToken({
    required String token,
    required String expires,
  }) = _RefreshToken;
}

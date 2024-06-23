import 'dart:convert';

class LoginRequestEntity {
  String? email;
  String? password;

  LoginRequestEntity({
    this.email,
    this.password,
  });

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
      };
}

UserLoginResponseEntity userLoginResponseEntityFromJson(String str) =>
    UserLoginResponseEntity.fromJson(json.decode(str));

String userLoginResponseEntityToJson(UserLoginResponseEntity data) =>
    json.encode(data.toJson());

class UserLoginResponseEntity {
  int code;
  String message;
  User user;
  Tokens tokens;

  UserLoginResponseEntity({
    required this.code,
    required this.message,
    required this.user,
    required this.tokens,
  });

  factory UserLoginResponseEntity.fromJson(Map<String, dynamic> json) =>
      UserLoginResponseEntity(
        code: json["code"],
        message: json["message"],
        user: User.fromJson(json["user"]),
        tokens: Tokens.fromJson(json["tokens"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "user": user.toJson(),
        "tokens": tokens.toJson(),
      };
}

class Tokens {
  Access access;
  Access refresh;

  Tokens({
    required this.access,
    required this.refresh,
  });

  factory Tokens.fromJson(Map<String, dynamic> json) => Tokens(
        access: Access.fromJson(json["access"]),
        refresh: Access.fromJson(json["refresh"]),
      );

  Map<String, dynamic> toJson() => {
        "access": access.toJson(),
        "refresh": refresh.toJson(),
      };
}

class Access {
  String token;
  DateTime expires;

  Access({
    required this.token,
    required this.expires,
  });

  factory Access.fromJson(Map<String, dynamic> json) => Access(
        token: json["token"],
        expires: DateTime.parse(json["expires"]),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "expires": expires.toIso8601String(),
      };
}

class User {
  String firstname;
  String lastname;
  String description;
  String avatar;
  String email;
  String role;
  bool isEmailVerified;
  bool accountClosed;
  String id;
  List? following;
  List? followers;

  User({
    required this.firstname,
    required this.lastname,
    required this.description,
    required this.avatar,
    required this.email,
    required this.role,
    required this.isEmailVerified,
    required this.accountClosed,
    required this.id,
    this.followers,
    this.following,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        firstname: json["firstname"],
        lastname: json["lastname"],
        description: json["description"],
        avatar: json["avatar"],
        email: json["email"],
        role: json["role"],
        isEmailVerified: json["isEmailVerified"],
        accountClosed: json["accountClosed"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "firstname": firstname,
        "lastname": lastname,
        "description": description,
        "avatar": avatar,
        "email": email,
        "role": role,
        "isEmailVerified": isEmailVerified,
        "accountClosed": accountClosed,
        "id": id,
      };
}

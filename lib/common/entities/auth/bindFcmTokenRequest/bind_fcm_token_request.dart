class BindFcmTokenRequestEntity {
  String? fcmToken;

  BindFcmTokenRequestEntity({
    this.fcmToken,
  });

  Map<String, dynamic> toJson() => {
    "fcm_token": fcmToken,
  };
}

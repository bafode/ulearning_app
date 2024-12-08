// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      id: json['id'] as String?,
      firstname: json['firstname'] as String?,
      lastname: json['lastname'] as String?,
      email: json['email'] as String?,
      avatar: json['avatar'] as String?,
      gender: json['gender'] as String?,
      status: json['status'] as String?,
      description: json['description'] as String?,
      role: json['role'] as String?,
      isEmailVerified: json['isEmailVerified'] as bool?,
      accountClosed: json['accountClosed'] as bool?,
      phone: json['phone'] as String?,
      online: json['online'] as bool?,
      open_id: json['open_id'] as String?,
      authType: json['authType'] as String?,
      city: json['city'] as String?,
      school: json['school'] as String?,
      fieldOfStudy: json['fieldOfStudy'] as String?,
      levelOfStudy: json['levelOfStudy'] as String?,
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      favorites: (json['favorites'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      followers: (json['followers'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      following: (json['following'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstname': instance.firstname,
      'lastname': instance.lastname,
      'email': instance.email,
      'avatar': instance.avatar,
      'gender': instance.gender,
      'status': instance.status,
      'description': instance.description,
      'role': instance.role,
      'isEmailVerified': instance.isEmailVerified,
      'accountClosed': instance.accountClosed,
      'phone': instance.phone,
      'online': instance.online,
      'open_id': instance.open_id,
      'authType': instance.authType,
      'city': instance.city,
      'school': instance.school,
      'fieldOfStudy': instance.fieldOfStudy,
      'levelOfStudy': instance.levelOfStudy,
      'categories': instance.categories,
      'favorites': instance.favorites,
      'followers': instance.followers,
      'following': instance.following,
    };

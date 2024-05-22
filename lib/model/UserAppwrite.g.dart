// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserAppwrite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserAppwrite _$UserAppwriteFromJson(Map<String, dynamic> json) => UserAppwrite(
      userId: json['userId'] as String?,
      name: json['name'] as String?,
      profilePictureStorageId: json['profilePictureStorageId'] as String?,
      firebaseToken: json['firebaseToken'] as String?,
    );

Map<String, dynamic> _$UserAppwriteToJson(UserAppwrite instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'name': instance.name,
      'profilePictureStorageId': instance.profilePictureStorageId,
      'firebaseToken': instance.firebaseToken,
    };

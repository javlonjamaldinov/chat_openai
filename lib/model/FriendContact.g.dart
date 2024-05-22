// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FriendContact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FriendContact _$FriendContactFromJson(Map<String, dynamic> json) =>
    FriendContact(
      userId: json['userId'] as String?,
      mobileNumber: json['mobileNumber'] as String?,
      displayName: json['displayName'] as String?,
    );

Map<String, dynamic> _$FriendContactToJson(FriendContact instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'mobileNumber': instance.mobileNumber,
      'displayName': instance.displayName,
    };

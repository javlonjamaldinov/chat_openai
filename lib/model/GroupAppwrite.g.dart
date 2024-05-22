// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GroupAppwrite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupAppwrite _$GroupAppwriteFromJson(Map<String, dynamic> json) =>
    GroupAppwrite(
      id: json['id'] as String?,
      message: json['message'] as String?,
      messageType: json['messageType'] as String?,
      messageId: json['messageId'] as String?,
      sendDate: json['sendDate'] == null
          ? null
          : DateTime.parse(json['sendDate'] as String),
      createdDate: json['createdDate'] == null
          ? null
          : DateTime.parse(json['createdDate'] as String),
      name: json['name'] as String?,
      description: json['description'] as String?,
      creatorUserId: json['creatorUserId'] as String?,
      delivered: json['delivered'] as bool?,
      read: json['read'] as bool?,
      pictureName: json['pictureName'] as String?,
      pictureStorageId: json['pictureStorageId'] as String?,
      sendUserId: json['sendUserId'] as String?,
    );

Map<String, dynamic> _$GroupAppwriteToJson(GroupAppwrite instance) =>
    <String, dynamic>{
      'id': instance.id,
      'message': instance.message,
      'messageType': instance.messageType,
      'messageId': instance.messageId,
      'sendDate': instance.sendDate?.toIso8601String(),
      'createdDate': instance.createdDate?.toIso8601String(),
      'name': instance.name,
      'description': instance.description,
      'creatorUserId': instance.creatorUserId,
      'pictureName': instance.pictureName,
      'pictureStorageId': instance.pictureStorageId,
      'delivered': instance.delivered,
      'read': instance.read,
      'sendUserId': instance.sendUserId,
    };

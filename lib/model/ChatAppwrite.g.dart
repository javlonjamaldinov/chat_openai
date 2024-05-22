// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ChatAppwrite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatAppwrite _$ChatAppwriteFromJson(Map<String, dynamic> json) => ChatAppwrite(
      senderUserId: json['senderUserId'] as String?,
      receiverUserId: json['receiverUserId'] as String?,
      message: json['message'] as String?,
      type: json['type'] as String?,
      sendDate: json['sendDate'] == null
          ? null
          : DateTime.parse(json['sendDate'] as String),
      read: json['read'] as bool?,
      key: json['key'] as String?,
      displayName: json['displayName'] as String?,
      count: json['count'] as int?,
      messageIdUpstream: json['messageIdUpstream'] as String?,
      delivered: json['delivered'] as bool?,
      userId: json['userId'] as String?,
    );

Map<String, dynamic> _$ChatAppwriteToJson(ChatAppwrite instance) =>
    <String, dynamic>{
      'senderUserId': instance.senderUserId,
      'receiverUserId': instance.receiverUserId,
      'message': instance.message,
      'type': instance.type,
      'sendDate': instance.sendDate?.toIso8601String(),
      'read': instance.read,
      'key': instance.key,
      'displayName': instance.displayName,
      'count': instance.count,
      'messageIdUpstream': instance.messageIdUpstream,
      'delivered': instance.delivered,
      'userId': instance.userId,
    };

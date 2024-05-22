// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GroupMessageInfoAppwrite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupMessageInfoAppwrite _$GroupMessageInfoAppwriteFromJson(
        Map<String, dynamic> json) =>
    GroupMessageInfoAppwrite(
      groupId: json['groupId'] as String?,
      id: json['id'] as String?,
      messageId: json['messageId'] as String?,
      memberUserId: json['memberUserId'] as String?,
      delivered: json['delivered'] as bool?,
      read: json['read'] as bool?,
      deliveredTime: json['deliveredTime'] == null
          ? null
          : DateTime.parse(json['deliveredTime'] as String),
      readTime: json['readTime'] == null
          ? null
          : DateTime.parse(json['readTime'] as String),
    );

Map<String, dynamic> _$GroupMessageInfoAppwriteToJson(
        GroupMessageInfoAppwrite instance) =>
    <String, dynamic>{
      'id': instance.id,
      'groupId': instance.groupId,
      'messageId': instance.messageId,
      'memberUserId': instance.memberUserId,
      'delivered': instance.delivered,
      'read': instance.read,
      'deliveredTime': instance.deliveredTime?.toIso8601String(),
      'readTime': instance.readTime?.toIso8601String(),
    };

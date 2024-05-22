// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GroupMemberAppwrite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupMemberAppwrite _$GroupMemberAppwriteFromJson(Map<String, dynamic> json) =>
    GroupMemberAppwrite(
      memberUserId: json['memberUserId'] as String?,
      name: json['name'] as String?,
      admin: json['admin'] as bool?,
      blocked: json['blocked'] as bool?,
      createdUserId: json['createdUserId'] as String?,
      dateJoined: json['dateJoined'] == null
          ? null
          : DateTime.parse(json['dateJoined'] as String),
      groupId: json['groupId'] as String?,
    );

Map<String, dynamic> _$GroupMemberAppwriteToJson(
        GroupMemberAppwrite instance) =>
    <String, dynamic>{
      'memberUserId': instance.memberUserId,
      'name': instance.name,
      'admin': instance.admin,
      'blocked': instance.blocked,
      'createdUserId': instance.createdUserId,
      'groupId': instance.groupId,
      'dateJoined': instance.dateJoined?.toIso8601String(),
    };

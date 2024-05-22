// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'StoryAppwrite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryAppwrite _$StoryAppwriteFromJson(Map<String, dynamic> json) =>
    StoryAppwrite(
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      friendId: json['friendId'] as String?,
      storyType: json['storyType'] as String?,
      storageId: json['storageId'] as String?,
      seen: json['seen'] as bool?,
    );

Map<String, dynamic> _$StoryAppwriteToJson(StoryAppwrite instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'friendId': instance.friendId,
      'storyType': instance.storyType,
      'storageId': instance.storageId,
      'seen': instance.seen,
    };

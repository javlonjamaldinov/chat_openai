// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RoomAppwrite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoomAppwrite _$RoomAppwriteFromJson(Map<String, dynamic> json) => RoomAppwrite(
      roomId: json['roomId'] as String?,
      groupCall: json['groupCall'] as bool?,
      callType: json['callType'] as String?,
      rtcSessionDescription: json['rtcSessionDescription'] as String?,
      callerUserId: json['callerUserId'] as String?,
      calleeUserId: json['calleeUserId'] as String?,
      status: json['status'] as String?,
      presentingUserId: json['presentingUserId'] as String?,
    );

Map<String, dynamic> _$RoomAppwriteToJson(RoomAppwrite instance) =>
    <String, dynamic>{
      'roomId': instance.roomId,
      'groupCall': instance.groupCall,
      'callType': instance.callType,
      'rtcSessionDescription': instance.rtcSessionDescription,
      'callerUserId': instance.callerUserId,
      'calleeUserId': instance.calleeUserId,
      'status': instance.status,
      'presentingUserId': instance.presentingUserId,
    };

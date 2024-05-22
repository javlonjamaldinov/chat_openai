// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MessageAppwrite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageAppwrite _$MessageAppwriteFromJson(Map<String, dynamic> json) =>
    MessageAppwrite(
      senderUserId: json['senderUserId'] as String?,
      receiverUserId: json['receiverUserId'] as String?,
      message: json['message'] as String?,
      type: json['type'] as String?,
      sendDate: json['sendDate'] == null
          ? null
          : DateTime.parse(json['sendDate'] as String),
      read: json['read'] as bool?,
      fileName: json['fileName'] as String?,
      delivered: json['delivered'] as bool?,
    );

Map<String, dynamic> _$MessageAppwriteToJson(MessageAppwrite instance) =>
    <String, dynamic>{
      'senderUserId': instance.senderUserId,
      'receiverUserId': instance.receiverUserId,
      'message': instance.message,
      'type': instance.type,
      'sendDate': instance.sendDate?.toIso8601String(),
      'read': instance.read,
      'fileName': instance.fileName,
      'delivered': instance.delivered,
    };

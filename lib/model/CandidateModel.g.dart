// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CandidateModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CandidateModel _$CandidateModelFromJson(Map<String, dynamic> json) =>
    CandidateModel(
      id: json['id'] as String?,
      candidate: json['candidate'] as String?,
      sdpMLineIndex: json['sdpMLineIndex'] as int?,
      sdpMid: json['sdpMid'] as String?,
      roomId: json['roomId'] as String?,
    );

Map<String, dynamic> _$CandidateModelToJson(CandidateModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'candidate': instance.candidate,
      'sdpMLineIndex': instance.sdpMLineIndex,
      'sdpMid': instance.sdpMid,
      'roomId': instance.roomId,
    };

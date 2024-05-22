import 'package:json_annotation/json_annotation.dart';

part 'RoomAppwrite.g.dart';

@JsonSerializable()
class RoomAppwrite {

  String? roomId;
  bool? groupCall;
  String? callType;
  String? rtcSessionDescription;
  String? callerUserId;
  String? calleeUserId;
  String? status;
  String? presentingUserId;


  RoomAppwrite({this.roomId,this.groupCall, this.callType, this.rtcSessionDescription,this.callerUserId,this.calleeUserId,this.status,this.presentingUserId});

  factory RoomAppwrite.fromJson(Map<String, dynamic> json) =>
      _$RoomAppwriteFromJson(json);

  Map<String, dynamic> toJson() => _$RoomAppwriteToJson(this);


}

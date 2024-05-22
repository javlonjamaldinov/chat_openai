import 'package:json_annotation/json_annotation.dart';

part 'GroupMemberAppwrite.g.dart';

@JsonSerializable()
class GroupMemberAppwrite {

  String? memberUserId;
  String? name;
  bool? admin;
  bool? blocked;
  String? createdUserId;
  String? groupId;
  DateTime? dateJoined;

  GroupMemberAppwrite({this.memberUserId,this.name,this.admin,this.blocked,this.createdUserId,this.dateJoined,this.groupId});

  factory GroupMemberAppwrite.fromJson(Map<String, dynamic> json) =>
      _$GroupMemberAppwriteFromJson(json);

  Map<String, dynamic> toJson() => _$GroupMemberAppwriteToJson(this);

}

import 'package:json_annotation/json_annotation.dart';

part 'GroupMessageInfoAppwrite.g.dart';

@JsonSerializable()
class GroupMessageInfoAppwrite {
  String? id;
  String? groupId;
  String? messageId;
  String? memberUserId;
  bool? delivered;
  bool? read;
  DateTime? deliveredTime;
  DateTime? readTime;

  GroupMessageInfoAppwrite(
      {this.groupId,
        this.id,
        this.messageId,
        this.memberUserId,
        this.delivered,
        this.read,
        this.deliveredTime,
        this.readTime});

  factory GroupMessageInfoAppwrite.fromJson(Map<String, dynamic> json) =>
      _$GroupMessageInfoAppwriteFromJson(json);

  Map<String, dynamic> toJson() => _$GroupMessageInfoAppwriteToJson(this);
}

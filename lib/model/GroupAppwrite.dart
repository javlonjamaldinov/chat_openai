import 'package:json_annotation/json_annotation.dart';
part 'GroupAppwrite.g.dart';
@JsonSerializable()
class GroupAppwrite {

  String? id;
  String? message;
  String? messageType;
  String? messageId;
  DateTime? sendDate;
  DateTime? createdDate;
  String? name;
  String? description;
  String? creatorUserId;
  String? pictureName;
  String? pictureStorageId;
  bool? delivered;
  bool? read;
  String? sendUserId;


  GroupAppwrite({this.id,this.message,this.messageType,this.messageId,
    this.sendDate, this.createdDate, this.name, this.description, this.creatorUserId,
    this.delivered, this.read,this.pictureName, this.pictureStorageId,this.sendUserId});

  factory GroupAppwrite.fromJson(Map<String, dynamic> json) =>
      _$GroupAppwriteFromJson(json);

  Map<String, dynamic> toJson() => _$GroupAppwriteToJson(this);


}

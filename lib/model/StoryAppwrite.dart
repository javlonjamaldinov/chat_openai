import 'package:json_annotation/json_annotation.dart';
part 'StoryAppwrite.g.dart';
@JsonSerializable()
class StoryAppwrite {

  String? id;
  String? userId;
  String? friendId;
  String? storyType;
  String? storageId;
  bool? seen;


  StoryAppwrite({this.id, this.userId, this.friendId, this.storyType, this.storageId,this.seen});

  factory StoryAppwrite.fromJson(Map<String, dynamic> json) =>
      _$StoryAppwriteFromJson(json);

  Map<String, dynamic> toJson() => _$StoryAppwriteToJson(this);


}

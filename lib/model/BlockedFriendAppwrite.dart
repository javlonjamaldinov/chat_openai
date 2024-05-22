
import 'package:json_annotation/json_annotation.dart';

part 'BlockedFriendAppwrite.g.dart';

@JsonSerializable()
class BlockedFriendAppwrite{
  String? userId;
  String? friendId;
  String? id;

  BlockedFriendAppwrite({this.userId, this.friendId,this.id});

  factory BlockedFriendAppwrite.fromJson(Map<String,dynamic> json)=>
      _$BlockedFriendAppwriteFromJson(json);


  Map<String,dynamic> toJson() => _$BlockedFriendAppwriteToJson(this);
}
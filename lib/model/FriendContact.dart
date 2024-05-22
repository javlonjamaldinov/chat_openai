import 'package:json_annotation/json_annotation.dart';

part 'FriendContact.g.dart';

@JsonSerializable()
class FriendContact{

  String? userId;
  String? mobileNumber;
  String? displayName;

  FriendContact({this.userId, this.mobileNumber, this.displayName});

  factory FriendContact.fromJson(Map<String,dynamic> json)=>
      _$FriendContactFromJson(json);


  Map<String,dynamic> toJson() => _$FriendContactToJson(this);
}

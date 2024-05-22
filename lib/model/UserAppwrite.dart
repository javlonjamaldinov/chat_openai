import 'package:json_annotation/json_annotation.dart';

part 'UserAppwrite.g.dart';

@JsonSerializable()
class UserAppwrite{

  String? userId;
  String? name;
  String? profilePictureStorageId;
  String? firebaseToken;

  UserAppwrite({this.userId, this.name, this.profilePictureStorageId,this.firebaseToken});

  factory UserAppwrite.fromJson(Map<String,dynamic> json)=>
      _$UserAppwriteFromJson(json);


  Map<String,dynamic> toJson() => _$UserAppwriteToJson(this);
}

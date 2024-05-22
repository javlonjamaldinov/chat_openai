import 'package:json_annotation/json_annotation.dart';

part 'GroupUserModel.g.dart';

@JsonSerializable()
class GroupUserModel {

  String? memberUserId;
  bool? selected;
  String? base64Image;
  String? name;

  GroupUserModel({this.memberUserId, this.base64Image,this.selected,this.name});

  factory GroupUserModel.fromJson(Map<String, dynamic> json) =>
      _$GroupUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$GroupUserModelToJson(this);


}

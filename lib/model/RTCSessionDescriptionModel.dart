import 'package:json_annotation/json_annotation.dart';

part 'RTCSessionDescriptionModel.g.dart';

@JsonSerializable()
class RTCSessionDescriptionModel {

  String? type;
  String? description;


  RTCSessionDescriptionModel({this.type,this.description});

  factory RTCSessionDescriptionModel.fromJson(Map<String, dynamic> json) =>
      _$RTCSessionDescriptionModelFromJson(json);

  Map<String, dynamic> toJson() => _$RTCSessionDescriptionModelToJson(this);


}

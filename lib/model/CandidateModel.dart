import 'package:json_annotation/json_annotation.dart';

part 'CandidateModel.g.dart';

@JsonSerializable()
class CandidateModel {

  String? id;
  String? candidate;
  int? sdpMLineIndex;
  String? sdpMid;
  String? roomId;


  CandidateModel({this.id,this.candidate, this.sdpMLineIndex, this.sdpMid,this.roomId});

  factory CandidateModel.fromJson(Map<String, dynamic> json) =>
      _$CandidateModelFromJson(json);

  Map<String, dynamic> toJson() => _$CandidateModelToJson(this);


}

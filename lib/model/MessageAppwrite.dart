import 'package:freezed_annotation/freezed_annotation.dart';

part 'MessageAppwrite.g.dart';

@JsonSerializable()
class MessageAppwrite {
  String? senderUserId;
  String? receiverUserId;
  String? message;
  String? type;
  DateTime? sendDate;
  bool? read;
  String? fileName;
  bool? delivered;

  MessageAppwrite({
    this.senderUserId,
    this.receiverUserId,
    this.message,
    this.type,
    this.sendDate,
    this.read,
    this.fileName,
    this.delivered,
  });

  factory MessageAppwrite.fromJson(Map<String, dynamic> json) =>
      _$MessageAppwriteFromJson(json);

  Map<String, dynamic> toJson() => _$MessageAppwriteToJson(this);
}

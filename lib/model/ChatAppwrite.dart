import 'package:freezed_annotation/freezed_annotation.dart';

part 'ChatAppwrite.g.dart';

@JsonSerializable()
class ChatAppwrite {
  String? senderUserId;
  String? receiverUserId;
  String? message;
  String? type;
  DateTime? sendDate;
  bool? read;
  String? key;
  String? displayName;
  int? count;
  String? messageIdUpstream;
  bool? delivered;
  String? userId;

  ChatAppwrite({
    this.senderUserId,
    this.receiverUserId,
    this.message,
    this.type,
    this.sendDate,
    this.read,
    this.key,
    this.displayName,
    this.count,
    this.messageIdUpstream,
    this.delivered,
    this.userId,
  });

  factory ChatAppwrite.fromJson(Map<String, dynamic> json) =>
      _$ChatAppwriteFromJson(json);

  Map<String, dynamic> toJson() => _$ChatAppwriteToJson(this);
}

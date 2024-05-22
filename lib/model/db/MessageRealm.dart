import 'package:realm/realm.dart';

part 'MessageRealm.g.dart';

@RealmModel()
class _MessageRealm {

  @PrimaryKey()
  late ObjectId id;
  String? senderUserId;
  String? receiverUserId;
  String? message;
  String? type;
  DateTime? sendDate;
  bool? read;
  String? localPath;
  String? previewBase64;
  String? fileName;
  String? messageIdUpstream;
  bool? delivered;

}

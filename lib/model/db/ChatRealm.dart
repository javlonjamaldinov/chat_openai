import 'package:realm/realm.dart';

part 'ChatRealm.g.dart';

@RealmModel()
class _ChatRealm {
  @PrimaryKey()
  late ObjectId id;
  late String? senderUserId;
  late String? receiverUserId;
  late String? message;
  late String? type;
  late DateTime? sendDate;
  late bool? read;
  late String? key;
  late String? displayName;
  late String? base64Image;
  late int? count;
  late String? messageIdUpstream;
  late bool? delivered;
  late String? userId;
  }

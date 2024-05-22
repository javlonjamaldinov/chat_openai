import 'package:json_annotation/json_annotation.dart';
import 'package:realm/realm.dart';

part 'FriendContactRealm.g.dart';


@RealmModel()
class _FriendContactRealm {
  @PrimaryKey()
  late ObjectId id;
  late String? userId;
  late String? mobileNumber;
  late String? displayName;
  late String? base64Image;
}

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:chat_with_bisky/constant/strings.dart';
import 'package:chat_with_bisky/model/UserAppwrite.dart';
import 'package:chat_with_bisky/service/AppwriteClient.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';
import 'package:chat_with_bisky/core/util/Util.dart';
class FriendImage extends StatelessWidget {
  final String? base64;
  final AppWriteClientService _clientService =
  KiwiContainer().resolve<AppWriteClientService>();

  FriendImage(this.base64, {super.key});

  @override
  Widget build(BuildContext context) {
    return getProfilePicture(base64);
  }

  getProfilePicture(String? base64) {


    return base64 != null ?CircleAvatar(
        backgroundImage: MemoryImage(base64ToUint8List(base64))):
    const CircleAvatar(
      backgroundImage: NetworkImage(Strings.avatarImageUrl),
    );
  }
}

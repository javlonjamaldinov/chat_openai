import 'dart:io';

import 'package:chat_with_bisky/constant/strings.dart';
import 'package:chat_with_bisky/core/providers/FileTempProvider.dart';
import 'package:chat_with_bisky/model/UserAppwrite.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../core/providers/GetUserProvider.dart';

class UserImage extends HookWidget{


  String userId;
  double? radius;

  UserImage(this.userId, {this.radius,super.key});

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      child: Consumer(builder: (context, ref, child) {
        final userAsync = ref.watch(getUserProvider((userId)));
        return userAsync.when(
          data: (user) => userDetail(user),
          error: (error, stackTrace) {
            return defaultImage();
          },
          loading: () =>
          const SizedBox(width: 20, child: LinearProgressIndicator()),
        );
      },),
    );
  }

  CircleAvatar defaultImage() {
    return const CircleAvatar(
      radius: 20.0,
      backgroundImage: NetworkImage(Strings.avatarImageUrl),
    );
  }

  userDetail(UserAppwrite? user) {
    if(user != null){
      return Consumer(builder: (context, ref, child) {
        final fileAsync = ref.watch(fileTempProvider(Strings.profilePicturesBucketId,user.profilePictureStorageId??""));
        return fileAsync.when(
          data: (file) => memberProfilePicture(file,user),
          error: (error, stackTrace) {
            return defaultImage();
          },
          loading: () =>
          const SizedBox(width: 20, child: LinearProgressIndicator()),
        );
      });
    }
    return  defaultImage();
  }

  memberProfilePicture(File file, UserAppwrite user) {

    Uint8List uint8list = Uint8List.fromList(file.readAsBytesSync());
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
            radius: radius,
            backgroundImage: MemoryImage(uint8list)
        ),
      ],
    );
  }



}

import 'dart:io';

import 'package:chat_with_bisky/app_decoration.dart';
import 'package:chat_with_bisky/constant/strings.dart';
import 'package:chat_with_bisky/core/extensions/extensions.dart';
import 'package:chat_with_bisky/core/providers/FileTempProvider.dart';
import 'package:chat_with_bisky/core/providers/StoryRepositoryProvider.dart';
import 'package:chat_with_bisky/core/util/Util.dart';
import 'package:chat_with_bisky/model/StoryAppwrite.dart';
import 'package:chat_with_bisky/model/UserAppwrite.dart';
import 'package:chat_with_bisky/widget/UserImage.dart';
import 'package:chat_with_bisky/widget/story_custom_image_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../core/providers/GetUserProvider.dart';

// ignore: must_be_immutable
class UserImageNameItemWidget extends HookConsumerWidget {
  String? userId;
  double? radius;
  ValueChanged<UserAppwrite>? onSelected;



  UserImageNameItemWidget({super.key, required this.userId, this.radius = 30,this.onSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {


    return  Consumer(builder: (context, ref, child) {
      final userAsync = ref.read(GetUserProvider(userId!));
      return userAsync.when(
        data: (user) {
          if (user != null) {
            return GestureDetector(
              onTap: () {
                if(onSelected!=null){
                  onSelected!(user);
                }
              },
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  UserImage(
                    user.userId ?? "",
                    radius: radius,
                  ),
                  Text(
                    '${user.name}',
                    style: const TextStyle(color: Colors.black),
                  )
                ],
              ),
            );
          }
          return const SizedBox();
        },
        error: (error, stackTrace) {
          return const CircleAvatar(
              radius: 30.0,
              backgroundImage: NetworkImage(Strings.avatarImageUrl));
        },
        loading: () => const CircleAvatar(
            radius: 30.0,
            backgroundImage: NetworkImage(Strings.avatarImageUrl)),
      );
    });

  }
}

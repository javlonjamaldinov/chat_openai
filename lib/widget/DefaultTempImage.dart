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

class DefaultTempImage extends HookWidget{


  String bucketId;
  String? imageStorageId;
  double? size;

  DefaultTempImage(this.bucketId,this.imageStorageId, {super.key,this.size=60});

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: size?? 20,
      child: imageStorageId != null ?Consumer(builder: (context, ref, child) {
        final fileAsync = ref.watch(fileTempProvider(
            bucketId,
            imageStorageId!));
        return fileAsync.when(
          data: (file) => groupPicture(file),
          error: (error, stackTrace) {

            return  defaultImage();
          },
          loading: () => const SizedBox(
              width: 20, child: LinearProgressIndicator()),
        );
      }):defaultImage(),
    );
  }

  CircleAvatar defaultImage() {
    return  CircleAvatar(
      radius: size??20.0,
      backgroundImage: const NetworkImage(Strings.avatarImageUrl),
    );
  }


  groupPicture(File file) {
    Uint8List uint8list = Uint8List.fromList(file.readAsBytesSync());
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: CircleAvatar(radius: size??20, backgroundImage: MemoryImage(uint8list)),
    );
  }



}

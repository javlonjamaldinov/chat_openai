import 'dart:io';

import 'package:chat_with_bisky/app_decoration.dart';
import 'package:chat_with_bisky/constant/strings.dart';
import 'package:chat_with_bisky/core/extensions/extensions.dart';
import 'package:chat_with_bisky/core/providers/FileTempProvider.dart';
import 'package:chat_with_bisky/core/providers/StoryRepositoryProvider.dart';
import 'package:chat_with_bisky/core/util/Util.dart';
import 'package:chat_with_bisky/model/StoryAppwrite.dart';
import 'package:chat_with_bisky/widget/story_custom_image_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../core/providers/GetUserProvider.dart';

// ignore: must_be_immutable
class StoryViewFileImageWidget extends HookConsumerWidget {
  String? storageId;
  StoryAppwrite? story;
  BoxFit? imageFit;
  double? height;
  double? width;

  StoryViewFileImageWidget({super.key, required this.storageId,
    required this.story,
    this.imageFit = BoxFit.fitWidth,this.height,this.width});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    useEffect((){

      if(story?.seen == false){
         ref.read(storyRepositoryProvider).updateStorySeen(story?.id??"");
      }
      return null;

    });
    return Consumer(
      builder: (context, ref, child) {
        final fileAsync = ref.watch(fileTempProvider(
            Strings.messagesBucketId,
            storageId ?? ""));
        return fileAsync.when(
          data: (file) => Image.file(File(file.path), fit: imageFit,width: width,height: height,),
          error: (error, stackTrace) {
            return Center(
              child: Text('$error'),
            );
          },
          loading: () =>
          const Center(child: SizedBox(width: 20,
              child: LinearProgressIndicator(color: Colors.orange,))),
        );
      },
    );
  }
}

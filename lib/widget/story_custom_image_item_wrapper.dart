import 'dart:io';

import 'package:chat_with_bisky/app_decoration.dart';
import 'package:chat_with_bisky/core/extensions/extensions.dart';
import 'package:chat_with_bisky/core/util/Util.dart';
import 'package:chat_with_bisky/model/StoryAppwrite.dart';
import 'package:chat_with_bisky/widget/story_custom_image_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../core/providers/GetUserProvider.dart';

// ignore: must_be_immutable
class SoryCustomImageItemWrapper extends HookWidget {
  File file;
  StoryAppwrite story;
  bool? isMine;
  SoryCustomImageItemWrapper(this.file,this.story, {this.isMine = false,super.key});

  @override
  Widget build(BuildContext context) {

    return IntrinsicWidth(
      child: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: getPadding(
            right: 16,
          ),
          child:Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Card(
                clipBehavior: Clip.antiAlias,
                elevation: 0,
                margin: const EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.orange,
                    width: getHorizontalSize(
                      2,
                    ),
                  ),
                  borderRadius: BorderRadius.circular(
                    getHorizontalSize(
                      32,
                    ),
                  ),
                ),
                child: Container(
                  height: getSize(
                    64,
                  ),
                  width: getSize(
                    64,
                  ),
                  padding: getPadding(
                    left: 6,
                    top: 5,
                    right: 6,
                    bottom: 5,
                  ),
                  decoration: AppDecoration.outlineDeeppurpleA2001.copyWith(
                    borderRadius: BorderRadius.circular(
                      getHorizontalSize(
                        32,
                      ),
                    ),
                  ),
                  child: Stack(
                    children: [
                      StoryCustomImageItem(
                        file: file,
                        height: getVerticalSize(
                          54,
                        ),
                        width: getHorizontalSize(
                          52,
                        ),
                        radius: BorderRadius.circular(
                          getHorizontalSize(
                            27,
                          ),
                        ),
                        alignment: Alignment.center,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: getPadding(
                  top: 9,
                ),
                child:  isMine == false?Consumer(
                  builder: (context, ref, child) {
                    final userAsync = ref
                        .read(GetUserProvider(story.userId ?? ""));
                    return userAsync.when(
                      data: (user) {
                        if (user != null) {
                          return   Text(
                            user.name??"",
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                          );
                        }
                        return const SizedBox();
                      },
                      error: (error, stackTrace) {
                        print(stackTrace);
                        return const SizedBox();
                      },
                      loading: () =>
                      const SizedBox(width: 20, child: LinearProgressIndicator()),
                    );
                  },
                ):const SizedBox() ,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

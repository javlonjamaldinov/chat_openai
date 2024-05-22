import 'package:chat_with_bisky/core/util/animated_stickers.dart';
import 'package:chat_with_bisky/widget/AnimatedAttachment.dart';
import 'package:flutter/material.dart';


class ChatStickerDialog extends StatelessWidget {
  const ChatStickerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(
        horizontal:  40.0 ,
        vertical:80.0 ,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.0,
                  mainAxisSpacing: 12.0,
                ),
                itemCount: kAssets.length,
                itemBuilder: (context, index) {
                  return AnimatedAttachment(
                    sticker: kAssets[index].assetPath,
                    onItemTap: (item) {
                      Navigator.of(context).pop(item);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

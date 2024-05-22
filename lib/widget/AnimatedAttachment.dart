import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class AnimatedAttachment extends StatelessWidget {
  const AnimatedAttachment({
    Key? key,
    required this.sticker,
    this.onItemTap,
  }) : super(key: key);
  final String sticker;
  final ValueChanged<String>? onItemTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: WrapAttachmentWidget(attachmentWidget:    InkWell(
        onTap: onItemTap != null ? () => onItemTap!(sticker) : null,
        child: RiveAnimation.asset(
          sticker,
          fit: BoxFit.fill,
        ),
      ), attachmentShape:   RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),),
    );
  }
}

import 'package:chat_with_bisky/model/StoryAppwrite.dart';
import 'package:chat_with_bisky/service/LocalStorageService.dart';
import 'package:chat_with_bisky/widget/StoryViewFileImageWidget.dart';
import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import "package:story_view/story_view.dart";

class StoriesViewScreen extends ConsumerStatefulWidget {

  List<StoryItem> storyItems;
  StoryController controller;
  String name;
  StoriesViewScreen(this.storyItems, this.controller, this.name, {super.key});

  @override
  ConsumerState<StoriesViewScreen> createState() => _StoriesViewScreenState();
}

class _StoriesViewScreenState extends ConsumerState<StoriesViewScreen> {
  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: () {},
      child: Scaffold(
        appBar: AppBar(title: Text('${widget.name}'),),
        body: StoryView(
          indicatorForegroundColor: Colors.orange,
          indicatorColor: Colors.blue,
          storyItems: widget.storyItems,
          controller: widget.controller,
          onStoryShow: (s) {
            print("Showing a story");
          },
          onComplete: () {
            Navigator.pop(context);
          },
          progressPosition: ProgressPosition.top,
          repeat: false,
        ),
      ),
    );
  }

  Future<void> initialization() async {
    String userId =
        await LocalStorageService.getString(LocalStorageService.userId) ?? "";
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initialization());
  }


}

customStoryViewImage({
  required String storageId,
  required StoryAppwrite story,
  Key? key,
  BoxFit imageFit = BoxFit.fitWidth,
  String? caption,
  bool shown = false,
  Map<String, dynamic>? requestHeaders,
  Duration? duration,
}) {
  return StoryItem(
    Container(
      key: key,
      color: Colors.black,
      child: Stack(
        children: <Widget>[
          StoryViewFileImageWidget(storageId: storageId,story: story,imageFit: imageFit,),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(
                  bottom: 24,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                color: caption != null ? Colors.black54 : Colors.transparent,
                child: caption != null
                    ? Text(
                  caption,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                )
                    : const SizedBox(),
              ),
            ),
          )
        ],
      ),
    ),
    shown: shown,
    duration: duration ?? const Duration(seconds: 3),
  );
}

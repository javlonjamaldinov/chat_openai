import 'package:chat_with_bisky/core/extensions/extensions.dart';
import 'package:chat_with_bisky/core/util/Util.dart';
import 'package:chat_with_bisky/model/StoryAppwrite.dart';
import 'package:chat_with_bisky/model/StoryState.dart';
import 'package:chat_with_bisky/model/UserAppwrite.dart';
import 'package:chat_with_bisky/pages/dashboard/stories/StoryViewModel.dart';
import 'package:chat_with_bisky/service/LocalStorageService.dart';
import 'package:chat_with_bisky/widget/StoryViewFileImageWidget.dart';
import 'package:chat_with_bisky/widget/UserImageNameTileWidget.dart';
import 'package:chat_with_bisky/widget/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class MyStoryViewScreen extends ConsumerStatefulWidget {
  final StoryAppwrite storyAppwrite;

  MyStoryViewScreen(this.storyAppwrite);

  @override
  ConsumerState<MyStoryViewScreen> createState() => _MyStoryViewScreenState();
}

class _MyStoryViewScreenState extends ConsumerState<MyStoryViewScreen> {
  StoryViewModel? _notifier;
  StoryState? _state;

  @override
  Widget build(BuildContext context) {
    _notifier = ref.read(storyViewModelProvider.notifier);
    _state = ref.watch(storyViewModelProvider);
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              deleteStory();
            },
            backgroundColor: Colors.red,
            child: const Icon(Icons.delete_forever,color: Colors.white,size: 20,),
          ),
      appBar: AppBar(
        title:  Text('txt_story'.tr),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
            width: double.maxFinite,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  StoryViewFileImageWidget(
                    storageId: widget.storyAppwrite.storageId ?? "",
                    story: widget.storyAppwrite,
                    width: size.width,
                    height: size.height * 0.6,
                    imageFit: BoxFit.cover,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                   (_state?.seenFriends?.isNotEmpty == true)?
                  const Text(
                    "Seen By:",
                    style: TextStyle(
                        color: Colors.orange, fontWeight: FontWeight.bold),
                  ): Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('txt_no_one'.tr,style: const TextStyle(color: Colors.black)),
                  ),
                  if (_state?.seenFriends?.isNotEmpty == true)
                    Flexible(
                        child: ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              UserAppwrite user = _state!.seenFriends![index];
                              return UserImageNameTileWidget(
                                user,
                                onOptionClicked: (value) {},
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const SizedBox(
                                width: 1,
                              );
                            },
                            itemCount: _state?.seenFriends?.length ?? 0)),

                ])),
      ),
    ));
  }

  Future<void> initialization() async {
    _notifier?.setStorageId(widget.storyAppwrite.storageId ?? "");
    _notifier?.setMyUserId(widget.storyAppwrite.userId ?? "");
    _notifier?.getSeenStories();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initialization());
  }

  void deleteStory() {
    ChatDialogs.confirmDialog(context, (value) async {
      if (value) {
        final isDeleted = await _notifier?.deleteStory(widget.storyAppwrite.storageId ??"");
        if(isDeleted == true && mounted){
          Navigator.pop(context);
        }
      }
    },
        title: 'txt_delete_story'.tr,
        description: 'txt_are_you_sure'.tr,
        type: AlertType.warning);
  }
}

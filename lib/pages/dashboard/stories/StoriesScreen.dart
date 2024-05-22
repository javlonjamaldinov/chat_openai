import 'package:appwrite/models.dart';
import 'package:auto_route/auto_route.dart';
import 'package:chat_with_bisky/constant/strings.dart';
import 'package:chat_with_bisky/core/extensions/extensions.dart';
import 'package:chat_with_bisky/core/providers/FileTempProvider.dart';
import 'package:chat_with_bisky/core/providers/GetUserProvider.dart';
import 'package:chat_with_bisky/core/util/Util.dart';
import 'package:chat_with_bisky/model/AttachmentType.dart';
import 'package:chat_with_bisky/model/GroupAppwrite.dart';
import 'package:chat_with_bisky/model/MyGroupsState.dart';
import 'package:chat_with_bisky/model/StoryAppwrite.dart';
import 'package:chat_with_bisky/model/StoryState.dart';
import 'package:chat_with_bisky/pages/dashboard/groups/GroupsListViewModel.dart';
import 'package:chat_with_bisky/pages/dashboard/stories/MyStoryViewScreen.dart';
import 'package:chat_with_bisky/pages/dashboard/stories/StoriesViewScreen.dart';
import 'package:chat_with_bisky/pages/dashboard/stories/StoryViewModel.dart';
import 'package:chat_with_bisky/route/app_route/AppRouter.gr.dart';
import 'package:chat_with_bisky/service/LocalStorageService.dart';
import 'package:chat_with_bisky/widget/GroupTileItemWidget.dart';
import 'package:chat_with_bisky/widget/UserImage.dart';
import 'package:chat_with_bisky/widget/UserImageNameWidget.dart';
import 'package:chat_with_bisky/widget/custom_app_bar.dart';
import 'package:chat_with_bisky/widget/custom_dialog.dart';
import 'package:chat_with_bisky/widget/story_custom_image_item_wrapper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:realm/realm.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:story_view/controller/story_controller.dart';

class StoriesScreen extends  ConsumerStatefulWidget {
  @override
  ConsumerState<StoriesScreen> createState() => _GroupsListScreenState();
}

class _GroupsListScreenState extends ConsumerState<StoriesScreen> {

  StoryViewModel? _notifier;
  StoryState? _state;
  final StoryController controller = StoryController();
  @override
  Widget build(BuildContext context) {
    _notifier = ref.read(storyViewModelProvider.notifier);
    _state = ref.watch(storyViewModelProvider);
    return FocusDetector(
      onFocusGained: () {

        _notifier?.getStories();
      },
      child: Scaffold(

          floatingActionButton: FloatingActionButton(
            onPressed: () {
              pickImageAndCreateStory();
            },
            foregroundColor: Colors.orange,
            backgroundColor: Colors.orange,
            child: const Icon(Icons.camera_alt,color: Colors.white,),
          ),
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [

                CustomBarWidget(
                  "txt_stories".tr,

                ),

                // show my stories
                Padding(
                  padding: getPadding(
                    left: 16,
                  ),
                  child:  Text(
                    "txt_my_stories".tr,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: getVerticalSize(
                      144,
                    ),
                    child: _state?.myStories?.isNotEmpty == true
                        ?ListView.separated(
                      padding: getPadding(
                        left: 16,
                        top: 24,
                        right: 14,
                      ),
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: getVerticalSize(
                            16,
                          ),
                        );
                      },
                      itemCount: _state?.myStories?.length ?? 0,
                      itemBuilder: (context, index) {
                        return Consumer(builder: (context, ref, child) {

                          StoryAppwrite story  = _state!.myStories![index];
                          final fileAsync = ref.watch(fileTempProvider(
                              Strings.messagesBucketId,
                              story.storageId ?? ""));
                          return fileAsync.when(
                            data: (file) => GestureDetector(
                              onTap: () {
                                context.push(MyStoryViewScreen(story));
                              },
                                child: SoryCustomImageItemWrapper(file,story,isMine: true,)),
                            error: (error, stackTrace) {
                              return const CircleAvatar(
                                radius: 50.0,
                                backgroundImage: NetworkImage(Strings.avatarImageUrl),
                              );
                            },
                            loading: () => const SizedBox(
                                width: 20, child: LinearProgressIndicator()),
                          );
                        });
                      },
                    ): SizedBox(child: Text('txt_share_your_story'.tr),),
                  ),
                ),
                // show friends stories

                Padding(
                  padding: getPadding(
                    left: 16,
                  ),
                  child:  Text(
                    "txt_friends_stories".tr,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: getVerticalSize(
                      144,
                    ),
                    child: _state?.friendsMapStories?.isNotEmpty == true
                        ?ListView.separated(
                      padding: getPadding(
                        left: 16,),
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: getVerticalSize(
                            16,
                          ),
                        );
                      },
                            itemCount: _state?.friendsMapStories?.length ?? 0,
                            itemBuilder: (context, index) {
                              String friendId = _state!.friendsMapStories!
                                  .elementAt(index)[0]
                                  .userId;
                              return UserImageNameItemWidget(
                                userId: friendId,
                                radius: 20,
                                onSelected: (user) async {
                                  List<StoryAppwrite> stories = _state!
                                          .friendsMapStories!
                                          .elementAt(index) ??
                                      [];
                                  final viewStories = await _notifier!
                                      .mapToViewStories(stories, controller);
                                  if (mounted && viewStories.isNotEmpty) {
                                    context.push(StoriesViewScreen(viewStories,
                                        controller, user.name ?? ""));
                                  }
                                },
                              );
                            },
                          )
                        :  SizedBox(
                            child: Text('txt_empty_friends_stories'.tr),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }



  Future<void> initialization() async {
    String userId =  await LocalStorageService.getString(LocalStorageService.userId) ?? "";
    _notifier?.setMyUserId(userId);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => initialization());

  }


  pickImageAndCreateStory() async {

    final file = await context.pickAndCropImage(3 / 4, ImageSource.gallery);

    if (file != null) {
      print(file.path);

      File? fileUploaded = await _notifier?.uploadStoryMedia(
          ObjectId().hexString, file.path);

      if (fileUploaded != null) {
        _notifier?.setStoryType(AttachmentType.image);
         final success = await _notifier?.saveStory(fileUploaded);
         if(success == true){

           _notifier?.getStories();
         }else{
           if(mounted){
             ChatDialogs.informationOkDialog(context, title: 'txt_error'.tr, description: 'txt_error_create_story'.tr, type: AlertType.error);
           }
         }
      }
    }
  }


}

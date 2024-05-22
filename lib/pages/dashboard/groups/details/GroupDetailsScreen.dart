import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:chat_with_bisky/constant/strings.dart';
import 'package:chat_with_bisky/core/extensions/extensions.dart';
import 'package:chat_with_bisky/core/providers/FileTempProvider.dart';
import 'package:chat_with_bisky/model/GroupAppwrite.dart';
import 'package:chat_with_bisky/model/GroupDetailsState.dart';
import 'package:chat_with_bisky/model/GroupMemberAppwrite.dart';
import 'package:chat_with_bisky/pages/dashboard/groups/details/GroupDetailsViewModel.dart';
import 'package:chat_with_bisky/widget/GroupMemberTileWidget.dart';
import 'package:chat_with_bisky/widget/custom_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

@RoutePage()
class GroupDetailsScreen extends ConsumerStatefulWidget {
  final GroupAppwrite group;
  final String myUserId;

  const GroupDetailsScreen(
      {super.key, required this.group, required this.myUserId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _GroupDetailsScreenState();
  }
}

class _GroupDetailsScreenState extends ConsumerState<GroupDetailsScreen> {
  GroupDetailsViewModel? _notifier;
  GroupDetailsState? _state;

  @override
  Widget build(BuildContext context) {
    _notifier = ref.read(groupDetailsViewModelProvider.notifier);
    _state = ref.watch(groupDetailsViewModelProvider);
    return Scaffold(
      appBar: AppBar(title: Text(widget.group.name ?? "")),
      body: SizedBox(
        width: MediaQuery.of(context).size.width, // added
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => pickImage(ImageSource.gallery),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Consumer(builder: (context, ref, child) {
                    final fileAsync = ref.watch(fileTempProvider(
                        Strings.profilePicturesBucketId,
                        _state?.group?.pictureStorageId ?? ""));
                    return fileAsync.when(
                      data: (file) => groupPicturePicture(file),
                      error: (error, stackTrace) {
                        return const CircleAvatar(
                          radius: 50.0,
                          backgroundImage: NetworkImage(Strings.avatarImageUrl),
                        );
                      },
                      loading: () => const SizedBox(
                          width: 20, child: LinearProgressIndicator()),
                    );
                  }),
                  const Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 30,
                  )
                ],
              ),
            ),
             Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('txt_group_members'.tr),
            ),
            if (_state?.members?.isNotEmpty == true)
              Expanded(
                  child: ListView.separated(
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        GroupMemberAppwrite member = _state!.members![index];
                        return GroupMemberTileWidget(
                            member, _state?.myUserId ?? "",hideOptions: false,onOptionClicked: (value) {

                              print('option for ${value.memberUserId}');

                              _modalBottomSheet(value);

                            },);
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          width: 1,
                        );
                      },
                      itemCount: _state?.members?.length ?? 0)),
            ElevatedButton(
              style: ButtonStyle(
    foregroundColor:
    MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.red)),
              onPressed: () {

                ChatDialogs.confirmDialog(context, (value) async {

                  if(value){
                    print('exit group');


                    final isDeleted = await _notifier?.exitGroup();

                    if(isDeleted == true){
                      Navigator.pop(context);
                    }
                  }

                },title: 'txt_exit_group'.tr, description: 'txt_are_you_sure'.tr, type: AlertType.warning);

              },
              child:  Text('txt_exit_group'.tr),
            ),
          ],
        ),
      ),
    );
  }

  groupPicturePicture(File file) {
    Uint8List uint8list = Uint8List.fromList(file.readAsBytesSync());
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(radius: 50.0, backgroundImage: MemoryImage(uint8list)),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initialization());
  }

  Future<void> initialization() async {
    _notifier?.setUserId(widget.myUserId);
    _notifier?.setGroup(widget.group);
    _notifier?.getGroupMembers(widget.group.id ?? "");
    _notifier?.getGroupImage();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void pickImage(ImageSource source) async {
    final file = await context.pickAndCropImage(3 / 4, source);

    if (file != null) {
      print(file.path);
      bool? fileUploaded =
          await _notifier?.uploadGroupProfilePicture(file.path);

      if (fileUploaded == true) {
        print('FILE UPLEADED');
      }
    }
  }


  void _modalBottomSheet( GroupMemberAppwrite groupMemberAppwrite) {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Container(
          height: 250.0,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          ),
          child: Container(
            width: double.infinity,
            color: Colors.white,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                 Text("txt_select_an_option".tr),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {

                    Navigator.pop(context);
                    ChatDialogs.confirmDialog(context, (value) async {

                      if(value){

                        final isDeleted = await _notifier?.removeMember(groupMemberAppwrite);

                        if(isDeleted == true){

                          ChatDialogs.informationOkDialog(context, title: 'Success', description: '${groupMemberAppwrite.name} was deleted from this group', type: AlertType.success);
                        }


                      }

                    },title: 'txt_remove_member'.tr, description: 'txt_are_you_sure'.tr, type: AlertType.warning);


                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 38,
                    child:  Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        const Icon(
                          Icons.delete,
                          color: Colors.grey,
                        ),
                        Text("txt_remove_member".tr),
                        Spacer()
                      ],
                    ),
                  ),
                ),
                const Divider(),

                (groupMemberAppwrite.admin != true) ?
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 38,
                    child:  Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        const Icon(
                          Icons.person,
                          color: Colors.grey,
                        ),
                        Text("txt_make_admin".tr),
                        const Spacer()
                      ],
                    ),
                  ),
                ):const SizedBox(),

              ],
            ),
          ),
        );
      },
    );
  }


}

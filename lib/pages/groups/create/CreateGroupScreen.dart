import 'package:auto_route/annotations.dart';
import 'package:chat_with_bisky/core/extensions/extensions.dart';
import 'package:chat_with_bisky/model/CreateGroupState.dart';
import 'package:chat_with_bisky/model/GroupUserModel.dart';
import 'package:chat_with_bisky/pages/groups/create/CreateGroupViewModel.dart';
import 'package:chat_with_bisky/widget/LoadingPageOverlay.dart';
import 'package:chat_with_bisky/widget/friend_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class CreateGroupScreen extends ConsumerStatefulWidget {
  final String myUserId;

  const CreateGroupScreen({super.key, required this.myUserId});

  @override
  ConsumerState<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {
  final TextEditingController _groupNameController = TextEditingController();
  CreateGroupViewModel? notifier;
  CreateGroupState? state;

  _CreateGroupScreenState();

  @override
  Widget build(BuildContext context) {
    notifier = ref.read(createGroupViewModelProvider.notifier);
    state = ref.watch(createGroupViewModelProvider);
    notifier?.onGroupCreated = (value) {
      if(value == true){
        Navigator.pop(context);
      }
    };
    return LoadingPageOverlay(
      loading: state?.loading ?? false,
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.blue,
            centerTitle: false,
            title:  Text(
              'txt_select_members'.tr,
              style: const TextStyle(color: Colors.white),
            ),
            actions: <Widget>[
              state?.members?.isNotEmpty == true
                  ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                    onPressed: () {
                      showGroupNameDialog();
                    },
                    child:  Text(
                      "txt_create".tr,
                      style: const TextStyle(color: Colors.white),
                    )),
              )
                  : const SizedBox()
            ]),
        body: ListView.builder(
            itemCount: state?.allFriends?.length,
            itemBuilder: (context, index) {
              GroupUserModel user = state?.allFriends?[index] ?? GroupUserModel();
              return Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: ListTile(
                        onTap: () {
                          if (user.selected != true) {
                            user.selected = true;
                            notifier?.selectUserChanged(user, true);
                          } else {
                            user.selected = false;
                            notifier?.selectUserChanged(user, false);
                          }
                        },
                        leading: FriendImage(user.base64Image),
                        title: Text(
                          '${user.name}',
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                        trailing: user.selected == true
                            ? const Icon(
                          Icons.check_circle,
                          color: Colors.black,
                        )
                            : const SizedBox()),
                  ),
                ],
              );
            }),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) => initialization(context));
  }

  initialization(BuildContext context) {
    notifier?.userIdChanged(widget.myUserId);
    notifier?.getAllFriends();
  }

  showGroupNameDialog() {

    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              elevation: 14,
              child: SizedBox(
                height: 200,
                width: 370,
                child: Padding(
                    padding: const EdgeInsets.only(
                        top: 38.0,
                        left: 16,
                        right: 16,
                        bottom: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        TextField(
                          controller: _groupNameController,
                          decoration: InputDecoration(
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.orange,
                                    width: 2.0)),
                            border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(
                                    0.0)),
                            labelText: 'txt_group_name'.tr,
                          ),
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        const Spacer(),
                        Row(
                          children:  <Widget>[
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child:  Text(
                                  'txt_cancel'.tr,
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                )),

                            TextButton(
                                onPressed:() {
                                  if(_groupNameController.text.isNotEmpty){
                                    Navigator.pop(context);
                                    notifier?.groupNameChanged(_groupNameController.text);
                                    notifier?.createGroup();
                                  }

                                },
                                child:  Text('txt_create'.tr,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.orange)
                                )
                            ),
                          ],
                        )
                      ],
                    )),
              ));
        });
  }
}

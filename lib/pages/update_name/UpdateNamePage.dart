import 'dart:io';

import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:chat_with_bisky/constant/strings.dart';
import 'package:chat_with_bisky/core/extensions/extensions.dart';
import 'package:chat_with_bisky/model/ProfileState.dart';
import 'package:chat_with_bisky/model/UserAppwrite.dart';
import 'package:chat_with_bisky/pages/update_name/ProfileViewModel.dart';
import 'package:chat_with_bisky/route/app_route/AppRouter.gr.dart';
import 'package:chat_with_bisky/service/LocalStorageService.dart';
import 'package:chat_with_bisky/values/values.dart';
import 'package:chat_with_bisky/widget/LoadingPageOverlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

@RoutePage()
class UpdateNamePage extends ConsumerStatefulWidget {
  final String userId;
  final bool? initial;
  final UserAppwrite? user;

  const UpdateNamePage(this.userId, {this.initial = true,this.user, super.key});

  @override
  _UpdateNamePageState createState() {
    return _UpdateNamePageState();
  }
}

class _UpdateNamePageState extends ConsumerState<UpdateNamePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController controller = TextEditingController();

  ProfileViewModel? _notifier;
  ProfileState? _state;

  @override
  Widget build(BuildContext context) {
    _notifier = ref.read(profileViewModelProvider.notifier);
    _state = ref.watch(profileViewModelProvider);
    return Scaffold(
        appBar: widget.initial == true? null: AppBar(title: Text('txt_profile'.tr),),
        body: LoadingPageOverlay(
          loading: _state?.loading ?? false,
          child: Stack(
      children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? image =
                        await picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      _notifier?.setImageUrl(image.path);
                      _notifier?.setImageFile(File(image.path));
                      final file = File(image.path);
                      Uint8List uint8list = Uint8List.fromList(file.readAsBytesSync());
                      _notifier?.setImageList(uint8list);
                    }
                  },
                  child: CircleAvatar(
                      radius: 80,
                      backgroundImage:  _state?.uint8list == null
                                  ? null
                                  : MemoryImage(
                                      _state!.uint8list!,
                                    ),
                    child: _state?.uint8list== null
                        ? defaultImage():null,
                  ),

                ),
                const SizedBox(
                  height: Sizes.HEIGHT_10,
                ),
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: Strings.displayName),
                ),
                const SizedBox(
                  height: Sizes.HEIGHT_20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    final result =
                        await _notifier?.uploadImageAndUpdateName(controller.text);
                    if (result != null) {
                      if (widget.initial == true) {
                        if (mounted) {
                          LocalStorageService.putString(LocalStorageService.stage,
                              LocalStorageService.dashboardPage);
                          AutoRouter.of(context).push(const DashboardPage());
                        }
                      } else {
                        _notifier?.setUser(result);
                      }
                    }
                  },
                  child: Text("txt_update".tr),
                ),
              ],
            ),
          )
      ],
    ),
        ));
  }

  CircleAvatar defaultImage() {
    return const CircleAvatar(
      radius: 80.0,
      backgroundImage: NetworkImage(Strings.avatarImageUrl),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initialization());
  }

  Future<void> initialization() async {

    _notifier?.setUser(widget.user);
    _notifier?.setUserId(widget.userId);
    if (widget.user != null) {
     setState(() {
       controller.text = widget.user?.name ?? "";
     });

    }
  }
}

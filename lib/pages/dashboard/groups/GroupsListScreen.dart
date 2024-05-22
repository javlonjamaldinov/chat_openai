import 'package:auto_route/auto_route.dart';
import 'package:chat_with_bisky/core/extensions/extensions.dart';
import 'package:chat_with_bisky/model/GroupAppwrite.dart';
import 'package:chat_with_bisky/model/MyGroupsState.dart';
import 'package:chat_with_bisky/pages/dashboard/groups/GroupsListViewModel.dart';
import 'package:chat_with_bisky/route/app_route/AppRouter.gr.dart';
import 'package:chat_with_bisky/service/LocalStorageService.dart';
import 'package:chat_with_bisky/widget/GroupTileItemWidget.dart';
import 'package:chat_with_bisky/widget/custom_app_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class GroupsListScreen extends  ConsumerStatefulWidget {
  @override
  ConsumerState<GroupsListScreen> createState() => _GroupsListScreenState();
}

class _GroupsListScreenState extends ConsumerState<GroupsListScreen> {


  GroupsListViewModel? _notifier;
  MyGroupsState? _state;
  @override
  Widget build(BuildContext context) {

    _notifier = ref.read(groupsListViewModelProvider.notifier);
    _state = ref.watch(groupsListViewModelProvider);

    return FocusDetector(
      onFocusGained: () {
        _notifier?.getMyGroups();
      },
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              AutoRouter.of(context).push(CreateGroupRoute( myUserId: _state?.myUserId??""));
            },
            foregroundColor: Colors.orange,
            backgroundColor: Colors.orange,
            child: const Icon(Icons.add,color: Colors.white,),
          ),
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [

                CustomBarWidget(
                  "txt_groups".tr,
                ),

                _state?.groups?.isNotEmpty == true
                    ? Expanded(
                    child: ListView.separated(
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          GroupAppwrite group = _state!.groups![index];
                          return GroupTileItemWidget(group: group,userId: _state?.myUserId?? "");
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            width: 1,
                          );
                        },
                        itemCount: _state?.groups?.length ?? 0))
                    :  Center(
                  child: Text(
                      "txt_empty_groups".tr),
                )


              ],
            ),
          ),
        ),
      ),
    );
  }



  Future<void> initialization() async {
    String userId =  await LocalStorageService.getString(LocalStorageService.userId) ?? "";
    _notifier?.setUserId(userId);
    _notifier?.getMyGroups();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => initialization());

  }
}

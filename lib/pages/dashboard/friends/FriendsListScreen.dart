import 'package:auto_route/auto_route.dart';
import 'package:chat_with_bisky/core/extensions/extensions.dart';
import 'package:chat_with_bisky/model/FriendState.dart' as frendRiverpodState;
import 'package:chat_with_bisky/model/UserAppwrite.dart';
import 'package:chat_with_bisky/model/db/FriendContactRealm.dart';
import 'package:chat_with_bisky/pages/dashboard/friends/FriendListViewModel.dart';
import 'package:chat_with_bisky/route/app_route/AppRouter.gr.dart';
import 'package:chat_with_bisky/service/LocalStorageService.dart';
import 'package:chat_with_bisky/widget/LoadingShimmerPageOverlay.dart';
import 'package:chat_with_bisky/widget/custom_app_bar.dart';
import 'package:chat_with_bisky/widget/friend_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';

class FriendsListScreen extends  ConsumerStatefulWidget {
  @override
  ConsumerState<FriendsListScreen> createState() => _FriendsListScreenState();
}

class _FriendsListScreenState extends ConsumerState<FriendsListScreen> {

  FriendListNotifier? notifier;
  frendRiverpodState.FriendState? model;
  
  


  @override
  Widget build(BuildContext context) {


    notifier = ref.read(friendListNotifierProvider.notifier);
    model = ref.watch(friendListNotifierProvider);
    
    
    
    return Scaffold(
      floatingActionButton: !kIsWeb ?FloatingActionButton(
        onPressed: () {

          refreshFriends();
        },
        foregroundColor: Colors.orange,
        backgroundColor: Colors.orange,
        child: const Icon(Icons.refresh,color: Colors.white,),
      ):null,
      body:LoadingShimmerPageOverlay(
       loading: model?.loading ?? false,
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [

                CustomBarWidget(
                  "txt_friends".tr,
                ),


                model?.friends.isNotEmpty == true
                    ? Expanded(
                    child: ListView.separated(
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {

                          FriendContactRealm friend  = model!.friends[index];
                          return ListTile(
                            leading: FriendImage(friend.base64Image),
                            title: Text(friend.displayName ?? ""),
                            onTap: () async {

                              String userId =  await LocalStorageService.getString(LocalStorageService.userId) ?? "";

                              AutoRouter.of(context).push(MessageRoute(displayName: friend.displayName ?? "",myUserId:userId,friendUserId:friend.mobileNumber ?? "",
                                  friendUser: UserAppwrite(userId: friend.mobileNumber,
                                      name: friend.displayName)));

                            },
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            width: 1,
                          );
                        },
                        itemCount:  model?.friends.length ?? 0))
                    : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("txt_empty_friends".tr),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  getFriends() async {

    if(mounted){
      String userId =  await LocalStorageService.getString(LocalStorageService.userId) ?? "";

      notifier?.getMyFriends(userId);
    }
  }

  Future<void> refreshFriends() async {


    // You can request multiple permissions at once.
    Map<Permission, PermissionStatus> statuses = await [
    Permission.contacts].request();

    print(statuses[Permission.contacts]);

    await notifier?.getContactsListAndPersistFriend();
    await notifier?.getMyFriends(model?.myUserId??"");

  }


  Future<void> initialization() async {

    String userId =  await LocalStorageService.getString(LocalStorageService.userId) ?? "";
    notifier?.changedUserId(userId);
    Future.delayed(const Duration(seconds: 1),() async {
      await getFriends();
      notifier?.initializeFriends(userId);

    },);



  }

  @override
  void initState() {
    super.initState();

    initialization();

  }
}

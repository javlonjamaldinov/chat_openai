import 'package:auto_route/auto_route.dart';
import 'package:chat_with_bisky/core/extensions/extensions.dart';
import 'package:chat_with_bisky/pages/settings/friends/BlockedFriendsScreen.dart';
import 'package:chat_with_bisky/pages/settings/language/LanguageScreen.dart';
import 'package:chat_with_bisky/route/app_route/AppRouter.gr.dart';
import 'package:chat_with_bisky/service/LocalStorageService.dart';
import 'package:chat_with_bisky/widget/custom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/providers/UserRepositoryProvider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: CupertinoColors.extraLightBackgroundGray,
        child: Column(
          children: [
            Container(
                width: double.infinity,
                color: CupertinoColors.white,
                child: Column(
                  children: [
                    CustomBarWidget(
                      "txt_settings".tr,
                    ),
                    GestureDetector(
                      onTap: () {
                        context.push(const LanguageScreen());
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        height: 38,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(width: 12),
                            const Icon(
                              Icons.language,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 12),
                            Text("change_language".tr),
                            const Spacer(),
                            const SizedBox(width: 5),
                            const Icon(
                              CupertinoIcons.right_chevron,
                              color: CupertinoColors.inactiveGray,
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ),
                    ),
                    const Divider(),
                    GestureDetector(
                      onTap: () async {

                        final userId = await LocalStorageService.getString(LocalStorageService.userId) ?? "";
                        final user = await ref.read(userRepositoryProvider).getUser(userId);
                        if (mounted) {
                          AutoRouter.of(context)
                              .push(UpdateNamePage(userId: userId, user: user,initial: false));
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        height: 38,
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                            const SizedBox(width: 12),
                            const Icon(
                              CupertinoIcons.person,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 12),
                            Text("txt_profile".tr),
                            const Spacer(),
                            const SizedBox(width: 5),
                            const Icon(
                              CupertinoIcons.right_chevron,
                              color: CupertinoColors.inactiveGray,
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),


            const SizedBox(height: 8),

             Container(
                width: double.infinity,
                color: CupertinoColors.white,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.push(const BlockedFriendsScreen());
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        height: 38,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(width: 12),
                            const Icon(
                              Icons.block,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 12),
                            Text("txt_blocked_users".tr),
                            const Spacer(),
                            const Icon(
                              CupertinoIcons.right_chevron,
                              color: CupertinoColors.inactiveGray,
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ),
                    ),
                    const Divider(),
                    Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: 38,
                      child:  Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: 12),
                          const Icon(
                            CupertinoIcons.person,
                            color: CupertinoColors.inactiveGray,
                          ),
                          const SizedBox(width: 12),
                          Text("txt_designed_by".tr),
                          const Spacer(),
                          const Icon(
                            CupertinoIcons.right_chevron,
                            color: CupertinoColors.inactiveGray,
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  TextStyle headingStyleIOS = const TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 16,
    color: CupertinoColors.inactiveGray,
  );

  TextStyle descStyleIOS = const TextStyle(color: CupertinoColors.inactiveGray);
}

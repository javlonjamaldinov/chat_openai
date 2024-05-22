import 'package:chat_with_bisky/model/GroupMemberAppwrite.dart';
import 'package:chat_with_bisky/model/UserAppwrite.dart';
import 'package:chat_with_bisky/widget/UserImage.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UserImageNameTileWidget extends HookConsumerWidget {

  UserAppwrite user;
  ValueChanged<UserAppwrite>? onOptionClicked;
  UserImageNameTileWidget(this.user, {this.onOptionClicked,super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return ListTile(
      leading: SizedBox(width:50,
      height: 50,
      child: UserImage(user.userId ?? "")),
      title: Text(
        user.name ?? "",
        maxLines: 1,
        style: style.labelSmall
            ?.copyWith(fontSize: 13, fontWeight: FontWeight.bold),
        overflow: TextOverflow.ellipsis,
      ),
      // subtitle: Row(
      //   children: [
      //     Text((),
      //   ],
      // ),
      onTap: () async {

        if(onOptionClicked!=null){
          onOptionClicked!(user);
        }

      },
    );
  }
}

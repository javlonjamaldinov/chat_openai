import 'package:chat_with_bisky/core/extensions/extensions.dart';
import 'package:chat_with_bisky/model/GroupMemberAppwrite.dart';
import 'package:chat_with_bisky/widget/UserImage.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class GroupMemberTileWidget extends HookConsumerWidget {
  GroupMemberAppwrite member;
  String userId;
  bool hideOptions;
  ValueChanged<GroupMemberAppwrite>? onOptionClicked;
  GroupMemberTileWidget(this.member, this.userId, {this.hideOptions = true,this.onOptionClicked,super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return ListTile(
      leading: SizedBox(width:50,
      height: 50,
      child: UserImage(member.memberUserId ?? "")),
      title: Text(
        member.name ?? "",
        maxLines: 1,
        style: style.labelSmall
            ?.copyWith(fontSize: 13, fontWeight: FontWeight.bold),
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Row(
        children: [
          Text((member.admin == true) ? "txt_admin".tr : 'txt_member'.tr),
        ],
      ),
      onTap: () async {

        if(onOptionClicked!=null){
          onOptionClicked!(member);
        }

      },
      trailing: hideOptions? null:Icon(Icons.delete,
      color: Colors.grey,size: 20,),
    );
  }
}

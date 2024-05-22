import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:chat_with_bisky/constant/strings.dart';
import 'package:chat_with_bisky/core/providers/DatabaseProvider.dart';
import 'package:chat_with_bisky/core/providers/GroupRepositoryProvider.dart';
import 'package:chat_with_bisky/core/providers/MessageRepositoryProvider.dart';
import 'package:chat_with_bisky/model/GroupAppwrite.dart';
import 'package:chat_with_bisky/model/GroupMessageInfoAppwrite.dart';
import 'package:chat_with_bisky/model/MessageAppwrite.dart';
import 'package:chat_with_bisky/model/MessageAppwriteDocument.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:realm/realm.dart';

final groupMessagesInfoRepositoryProvider = Provider(
      (ref) => GroupMessagesInfoRepositoryProvider(ref),
);

class GroupMessagesInfoRepositoryProvider {
  final Ref _ref;

  Databases get _databases => _ref.read(databaseProvider);
  GroupRepositoryProvider get _groupRepositoryProvider => _ref.read(groupRepositoryProvider);
  MessageRepositoryProvider get _messageRepositoryProvider => _ref.read(messageRepositoryProvider);

  GroupMessagesInfoRepositoryProvider(this._ref);

  Future<void> updateGroupMemberMessagesInfoSeen(String groupId,
      String myUserId, String messageId) async {
    try {

      GroupAppwrite? group =await _groupRepositoryProvider.getGroup(groupId);
      if(group == null){
        return;
      }
      GroupMessageInfoAppwrite? groupMessageInfoAppwrite =
      await getOrCreateGroupMessageInfo(
          messageId, myUserId, group);

      if(groupMessageInfoAppwrite == null || (groupMessageInfoAppwrite.read == true)){
        checkAndUpdateGroupIfEveryMemberReadOrReceivedMessage(group,messageId,myUserId);
        return;
      }
      await _databases.updateDocument(
          databaseId: Strings.databaseId,
          collectionId: Strings.collectionGroupMessagesInfoId,
          documentId: groupMessageInfoAppwrite.id!,
          data: {
            'delivered': true,
            'read': true
          });
      checkAndUpdateGroupIfEveryMemberReadOrReceivedMessage(group,messageId,myUserId);
    } catch (e) {
      print('updateGroupMemberMessagesInfoSeen $e');
    }
  }

  Future<void> updateGroupMemberMessagesInfoDelivered(
      GroupAppwrite groupAppwrite,
      String memberUserId,
      String messageId) async {
    try {
      GroupMessageInfoAppwrite? groupMessageInfoAppwrite =
      await getOrCreateGroupMessageInfo(
          messageId, memberUserId, groupAppwrite);

      if(groupMessageInfoAppwrite == null || ( groupMessageInfoAppwrite.delivered == true)){
        return;
      }
      await _databases.updateDocument(
          databaseId: Strings.databaseId,
          collectionId: Strings.collectionGroupMessagesInfoId,
          documentId: groupMessageInfoAppwrite.id!,
          data: {
            'delivered': true
          });

      checkAndUpdateGroupIfEveryMemberReadOrReceivedMessage(groupAppwrite,messageId,memberUserId);
    } catch (e) {
      print('updateGroupMemberMessagesInfoDelivered $e');
    }
  }

  Future<GroupMessageInfoAppwrite?> getOrCreateGroupMessageInfo(
      String messageId,
      String memberUserId,
      GroupAppwrite groupAppwrite) async {
    GroupMessageInfoAppwrite? retrieved =
    await getGroupMessagesInfo(messageId, memberUserId);
    if (retrieved == null) {
      return await createGroupMessagesInfo(
          groupAppwrite, memberUserId, messageId);
    }
    return retrieved;
  }

  Future<GroupMessageInfoAppwrite?> createGroupMessagesInfo(
      GroupAppwrite groupAppwrite,
      String memberUserId,
      String messageId) async {

    if(groupAppwrite.sendUserId == memberUserId){
      return null;
    }
    try {
      String id = ObjectId().hexString;
      GroupMessageInfoAppwrite groupMessageInfoAppwrite =
      GroupMessageInfoAppwrite(
          read: false,
          delivered: false,
          memberUserId: memberUserId,
          messageId: messageId,
          groupId: groupAppwrite.id,
          id: id);

      GroupMessageInfoAppwrite? retrieved =
      await getGroupMessagesInfo(messageId, memberUserId);
      if (retrieved != null) {
        return retrieved;
      }

      Document document = await _databases.createDocument(
          databaseId: Strings.databaseId,
          collectionId: Strings.collectionGroupMessagesInfoId,
          documentId: id,
          data: groupMessageInfoAppwrite.toJson());
      return GroupMessageInfoAppwrite.fromJson(document.data);
    } on AppwriteException catch (exception) {

      if(exception.code != 409){
        print('Exception createGroupMessagesInfo $exception');
      }

    }
    return null;
  }

  Future<GroupMessageInfoAppwrite?> getGroupMessagesInfo(
      String messageId, String memberUserId) async {
    try {
      DocumentList documentList = await _databases.listDocuments(
          databaseId: Strings.databaseId,
          collectionId: Strings.collectionGroupMessagesInfoId,
          queries: [
            Query.equal("messageId", [messageId]),
            Query.equal("memberUserId", [memberUserId]),
            Query.orderDesc('\$createdAt'),
            Query.limit(100),
          ]);

      if (documentList.total > 0) {
        return GroupMessageInfoAppwrite.fromJson(
            documentList.documents.first.data);
      }
    } on AppwriteException catch (exception) {
      print('Exception getGroupMessagesInfo $exception');
    }

    return null;
  }

  Future<void> checkAndUpdateGroupIfEveryMemberReadOrReceivedMessage(GroupAppwrite group, String messageId, String memberUserId) async {


    final grp = await _groupRepositoryProvider.getGroup(group.id??"");

    final members = await _groupRepositoryProvider.getGroupMembers(group.id??"");
    int countMembers = members.length;
    countMembers = countMembers -1;
    final countReads = await getGroupMessageReads(messageId);
    if(countMembers == countReads.length ){
      group.delivered = true;
      group.read = true;
      if(grp?.messageId == messageId){
        _groupRepositoryProvider.updateGroup(group);
      }
      _messageRepositoryProvider.updateMessageSeen(messageId);
    } else{
      if(group.delivered == true){
        return;
      }
      final countDelivered = await getGroupMessageDelivered(messageId);

      if(countMembers == countDelivered.length){
        group.delivered = true;
        group.read = false;
        if(grp?.messageId == messageId){
          _groupRepositoryProvider.updateGroup(group);
        }
        _messageRepositoryProvider.updateMessageDelivered(messageId);
      }
    }
  }



  Future< List<GroupMessageInfoAppwrite>> getGroupMessageReads(String messageId) async {
    try {
      DocumentList documentList = await _databases.listDocuments(
          databaseId: Strings.databaseId,
          collectionId: Strings.collectionGroupMessagesInfoId,
          queries: [
            Query.equal("messageId", [messageId]),
            Query.equal("read", [true])
          ]);

      if(documentList.total >0){

        List<GroupMessageInfoAppwrite> list = [];
        for (var element in documentList.documents) {
          list.add(GroupMessageInfoAppwrite.fromJson(element.data));
        }

        return list;
      }



    } on AppwriteException catch (exception) {
      print('Exception getGroupMessageReads $exception');
    }
    return [];
  }

  Future<List<GroupMessageInfoAppwrite>> getGroupMessageDelivered(String messageId) async {
    try {
      DocumentList documentList = await _databases.listDocuments(
          databaseId: Strings.databaseId,
          collectionId: Strings.collectionGroupMessagesInfoId,
          queries: [
            Query.equal("messageId", [messageId]),
            Query.equal("delivered", [true])
          ]);
      if(documentList.total >0){

        List<GroupMessageInfoAppwrite> list = [];
        for (var element in documentList.documents) {
          list.add(GroupMessageInfoAppwrite.fromJson(element.data));
        }

        return list;
      }
    } on AppwriteException catch (exception) {
      print('Exception getGroupMessageReads $exception');
    }
    return [];
  }


}

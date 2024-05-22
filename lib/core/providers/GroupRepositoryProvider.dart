import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:chat_with_bisky/constant/strings.dart';
import 'package:chat_with_bisky/core/providers/DatabaseProvider.dart';
import 'package:chat_with_bisky/core/providers/UserRepositoryProvider.dart';
import 'package:chat_with_bisky/model/GroupAppwrite.dart';
import 'package:chat_with_bisky/model/GroupMemberAppwrite.dart';
import 'package:chat_with_bisky/model/GroupUserModel.dart';
import 'package:chat_with_bisky/model/MessageAppwrite.dart';
import 'package:chat_with_bisky/model/UserAppwrite.dart';
import 'package:chat_with_bisky/service/LocalStorageService.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:realm/realm.dart';

final groupRepositoryProvider = Provider(
      (ref) => GroupRepositoryProvider(ref),
);

class GroupRepositoryProvider {
  final Ref _ref;

  Databases get _databases => _ref.read(databaseProvider);

  UserDataRepositoryProvider get _userRepositoryProvider =>
      _ref.read(userRepositoryProvider);

  GroupRepositoryProvider(this._ref);

  Future<bool?> createGroup(
      GroupAppwrite groupAppwrite, List<GroupUserModel> members) async {
    try {
      String userId =
          await LocalStorageService.getString(LocalStorageService.userId) ?? "";
      String id = ObjectId().hexString;
      groupAppwrite.id = id;
      groupAppwrite.creatorUserId = userId;
      UserAppwrite? userAppwrite =
      await _userRepositoryProvider.getUser(userId);

      if(userAppwrite == null){
        return false;
      }
      groupAppwrite.sendUserId = userId;
      Document document = await _databases.createDocument(
          databaseId: Strings.databaseId,
          collectionId: Strings.collectionGroupId,
          documentId: id,
          data: groupAppwrite.toJson());

      return await createGroupMembers(groupAppwrite, document, members, userId,userAppwrite);
    } catch (e) {
      print('createGroup $e');
    }
    return false;
  }

  Future<bool> createGroupMembers(GroupAppwrite group, Document groupDocument,
      List<GroupUserModel> members, String userId,UserAppwrite? userAppwrite) async {
    try {
      List<GroupMemberAppwrite> appwriteGroupMembers = [];
      for (var element in members) {
        final mbr = GroupMemberAppwrite(
            memberUserId: element.memberUserId,
            admin: false,
            blocked: false,
            createdUserId: userId,
            name: element.name,
            dateJoined: DateTime.parse(groupDocument.$createdAt),
            groupId: groupDocument.$id);
        appwriteGroupMembers.add(mbr);
      }

      if (userAppwrite != null) {
        final adminMember = GroupMemberAppwrite(
            memberUserId: userId,
            admin: true,
            blocked: false,
            createdUserId: userId,
            name: userAppwrite.name,
            dateJoined: DateTime.parse(groupDocument.$createdAt),
            groupId: groupDocument.$id);
        appwriteGroupMembers.add(adminMember);

        for (var element in appwriteGroupMembers) {
          await _databases.createDocument(
              databaseId: Strings.databaseId,
              collectionId: Strings.collectionGroupMembersId,
              documentId: ObjectId().hexString,
              data: element.toJson());
        }

        return true;
      }

      return false;
    } catch (e) {
      print('createGroupMembers $e');
    }

    return false;
  }


  Future<GroupMemberAppwrite?> getGroupMemberByUserId(String groupId,String memberUserId) async {
    try {
      DocumentList documentList = await _databases.listDocuments(
          databaseId: Strings.databaseId,
          collectionId: Strings.collectionGroupMembersId,
          queries: [
            Query.equal("groupId", [groupId]),
            Query.equal("memberUserId", [memberUserId]),
          ]);

      if (documentList.total > 0) {

        GroupMemberAppwrite groupMemberAppwrite = GroupMemberAppwrite.fromJson(documentList.documents.first.data);
        return groupMemberAppwrite;
      }
    } on AppwriteException catch (exception) {
      print('getGroupMemberByUserId Exception \n $exception');
    }
    return null;
  }


  Future<GroupAppwrite?> getGroup(String id) async {

    try {
      Document document = await _databases.getDocument(
          databaseId: Strings.databaseId,
          collectionId: Strings.collectionGroupId,
          documentId: id);

      return GroupAppwrite.fromJson(document.data);
    } on AppwriteException catch (e) {
      print('ERROR getGroup $e');
    } catch (e) {
      print('ERROR getGroup $e');
    }
    return null;
  }



  Future<List<GroupAppwrite>> getMemberGroups(String memberUserId) async {

    try {

      DocumentList documentList = await _databases.listDocuments(
          databaseId: Strings.databaseId,
          collectionId: Strings.collectionGroupMembersId,
          queries: [
            Query.equal("memberUserId", [memberUserId]),
          ]);

      if (documentList.total > 0) {
        List<GroupAppwrite>  groups = [];
        for (Document document in documentList.documents) {
          GroupMemberAppwrite groupMember = GroupMemberAppwrite.fromJson(document.data);
          GroupAppwrite? group  = await getGroup(groupMember.groupId??"");
          if(group != null){
            groups.add(group);
          }
        }

        return groups;

      }
    } on AppwriteException catch (e) {
      print('ERROR getMemberGroups $e');
    } catch (e) {
      print('ERROR getMemberGroups $e');
    }
    return [];
  }


  Future<List<GroupMemberAppwrite>> getGroupMembers(String groupId) async {

    try {
      DocumentList documentList = await _databases.listDocuments(
          databaseId: Strings.databaseId,
          collectionId: Strings.collectionGroupMembersId,
          queries: [
            Query.equal("groupId", [groupId]),
          ]);

      if (documentList.total > 0) {
        List<GroupMemberAppwrite>  groupsMembers = [];
        for (Document document in documentList.documents) {
          GroupMemberAppwrite groupMember = GroupMemberAppwrite.fromJson(document.data);
          groupsMembers.add(groupMember);
        }
        return groupsMembers;
      }
    } on AppwriteException catch (e) {
      print('ERROR getGroupMembers $e');
    } catch (e) {
      print('ERROR getGroupMembers $e');
    }
    return [];
  }

  Future<bool> updateGroup(GroupAppwrite group) async {

    try {


      Document document = await _databases.updateDocument(
          databaseId: Strings.databaseId,
          collectionId: Strings.collectionGroupId,
          documentId: group.id??"",
          data: group.toJson());

      return true;

    } on AppwriteException catch (exception) {
      print('update group $exception');

    }

    return false;
  }


  Future<bool> updateGroupProfilePicture(GroupAppwrite group,String imageId) async {

    try {


      Document document = await _databases.updateDocument(
          databaseId: Strings.databaseId,
          collectionId: Strings.collectionGroupId,
          documentId: group.id??"",
          data: {
            'pictureStorageId':imageId
          }
      );

      return true;

    } on AppwriteException catch (exception) {
      print('update updateGroupProfilePicture $exception');

    }
    return false;
  }



  Future<bool> updateGroupName(GroupAppwrite group,String name) async {

    try {


      Document document = await _databases.updateDocument(
          databaseId: Strings.databaseId,
          collectionId: Strings.collectionGroupId,
          documentId: group.id??"",
          data: {
            'name':name
          }
      );

      return true;

    } on AppwriteException catch (exception) {
      print('update updateGroupProfilePicture $exception');

    }
    return false;
  }


  Future<bool> deleteMemberByUserId(String groupId,String memberUserId) async {
    try {
      DocumentList documentList = await _databases.listDocuments(
          databaseId: Strings.databaseId,
          collectionId: Strings.collectionGroupMembersId,
          queries: [
            Query.equal("groupId", [groupId]),
            Query.equal("memberUserId", [memberUserId]),
          ]);

      if (documentList.total > 0) {


        await _databases.deleteDocument(databaseId: Strings.databaseId,
            collectionId: Strings.collectionGroupMembersId,
            documentId: documentList.documents.first.$id);

        return true;


      }
    } on AppwriteException catch (exception) {
      print('deleteMemberByUserId Exception \n $exception');
    }
    return false;
  }

}

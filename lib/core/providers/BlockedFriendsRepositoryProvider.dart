import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:chat_with_bisky/constant/strings.dart';
import 'package:chat_with_bisky/core/providers/DatabaseProvider.dart';
import 'package:chat_with_bisky/core/providers/UserRepositoryProvider.dart';
import 'package:chat_with_bisky/model/BlockedFriendAppwrite.dart';
import 'package:chat_with_bisky/model/GroupAppwrite.dart';
import 'package:chat_with_bisky/model/GroupMemberAppwrite.dart';
import 'package:chat_with_bisky/model/GroupUserModel.dart';
import 'package:chat_with_bisky/model/MessageAppwrite.dart';
import 'package:chat_with_bisky/model/UserAppwrite.dart';
import 'package:chat_with_bisky/service/LocalStorageService.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:realm/realm.dart';

final blockedFriendsRepositoryProvider = Provider(
      (ref) => BlockedFriendsRepositoryProvider(ref),
);

class BlockedFriendsRepositoryProvider {
  final Ref _ref;

  Databases get _databases => _ref.read(databaseProvider);

  BlockedFriendsRepositoryProvider(this._ref);

  Future<bool> create(BlockedFriendAppwrite request) async {
    try {

       await _databases.createDocument(
          databaseId: Strings.databaseId,
          collectionId: Strings.collectionBlockedFriendsId,
          documentId: request.id!,
          data: request.toJson());

      return true;
    } catch (e) {
      print('createBlockedFriend $e');
    }
    return false;
  }





  Future<List<BlockedFriendAppwrite>> getBlockedFriendsByUserId(String userId) async {

    try {

      DocumentList documentList = await _databases.listDocuments(
          databaseId: Strings.databaseId,
          collectionId: Strings.collectionBlockedFriendsId,
          queries: [
            Query.equal("userId", [userId]),
          ]);

      if (documentList.total > 0) {
        List<BlockedFriendAppwrite> blockedFriends = [];
        for (Document document in documentList.documents) {
          BlockedFriendAppwrite blockedFriendAppwrite = BlockedFriendAppwrite
              .fromJson(document.data);

          blockedFriends.add(blockedFriendAppwrite);


          return blockedFriends;
        }
      }
    } on AppwriteException catch (e) {
      print('ERROR getBlockedFriendsByUserId $e');
    } catch (e) {
      print('ERROR getBlockedFriendsByUserId $e');
    }
    return [];
  }

  Future<List<BlockedFriendAppwrite>> getBlockedFriendsByUserIdAndFriendId(String userId,String friendId) async {

    try {
      DocumentList documentList = await _databases.listDocuments(
          databaseId: Strings.databaseId,
          collectionId: Strings.collectionBlockedFriendsId,
          queries: [
            Query.equal("userId", [userId]),
            Query.equal("friendId", [friendId]),
          ]);

      if (documentList.total > 0) {
        List<BlockedFriendAppwrite> blockedFriends = [];
        for (Document document in documentList.documents) {
          BlockedFriendAppwrite blockedFriendAppwrite = BlockedFriendAppwrite
              .fromJson(document.data);
          blockedFriends.add(blockedFriendAppwrite);
          return blockedFriends;
        }
      }
    } on AppwriteException catch (e) {
      print('ERROR getBlockedFriendsByUserIdAndFriendId $e');
    } catch (e) {
      print('ERROR getBlockedFriendsByUserIdAndFriendId $e');
    }
    return [];
  }


  Future<bool> deleteBlockedFriend(String id) async {
    try {

      await _databases.deleteDocument(
          databaseId: Strings.databaseId,
          collectionId: Strings.collectionBlockedFriendsId,
          documentId: id,);

      return true;
    } catch (e) {
      print('deleteBlockedFriend $e');
    }
    return false;
  }


}

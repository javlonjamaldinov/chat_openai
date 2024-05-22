import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:chat_with_bisky/constant/strings.dart';
import 'package:chat_with_bisky/core/providers/DatabaseProvider.dart';
import 'package:chat_with_bisky/model/MessageAppwrite.dart';
import 'package:chat_with_bisky/model/StoryAppwrite.dart';
import 'package:chat_with_bisky/model/StoryState.dart';
import 'package:chat_with_bisky/model/db/FriendContactRealm.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:chat_with_bisky/model/MessageAppwriteDocument.dart';
import 'package:realm/realm.dart';

final storyRepositoryProvider = Provider(
  (ref) => StoryRepositoryProvider(ref),
);

class StoryRepositoryProvider {
  Ref _ref;

  Databases get _databases => _ref.read(databaseProvider);

  StoryRepositoryProvider(this._ref);

  Future<void> updateStorySeen(String id) async {
    try {
      _databases.updateDocument(
          databaseId: Strings.databaseId,
          collectionId: Strings.collectionStoryId,
          documentId: id,
          data: {'seen': true});
    } catch (e) {
      print('updateStorySeen $e');
    }
  }

  Future<StoryAppwrite?> getStory(String id) async {
    try {
      Document document = await _databases.getDocument(
          databaseId: Strings.databaseId,
          collectionId: Strings.collectionStoryId,
          documentId: id);
      StoryAppwrite message = StoryAppwrite.fromJson(document.data);
      return message;
    } catch (e) {
      print('getMessage Error $e');
    }
    return null;
  }

  Future<List<StoryAppwrite>> getMyStories(String userId) async {
    try {
      DocumentList documentList = await _databases.listDocuments(
          databaseId: Strings.databaseId,
          collectionId: Strings.collectionStoryId,
          queries: [
            Query.equal("userId", [userId]),
            Query.equal("friendId", [userId]),
            Query.orderDesc('\$createdAt'),
            Query.limit(100),
          ]);

      List<StoryAppwrite> stories = [];
      if (documentList.total > 0) {
        for (Document document in documentList.documents) {
          StoryAppwrite story = StoryAppwrite.fromJson(document.data);
          final deleted = await deleteStoryAfter24Hours(document,story.storageId??"");
          if( deleted == false){
            stories.add(story);
          }
        }

        return stories;
      }
    } on AppwriteException catch (exception) {
      print(exception);
    }
    return [];
  }

  Future<List<StoryAppwrite>> getStoriesFromFriends(String userId) async {
    try {
      DocumentList documentList = await _databases.listDocuments(
          databaseId: Strings.databaseId,
          collectionId: Strings.collectionStoryId,
          queries: [
            Query.notEqual("userId", [userId]),
            Query.equal("friendId", [userId]),
            Query.orderDesc('\$createdAt'),
            Query.limit(100),
          ]);

      List<StoryAppwrite> stories = [];
      if (documentList.total > 0) {
        for (Document document in documentList.documents) {
          StoryAppwrite story = StoryAppwrite.fromJson(document.data);
          final deleted = await deleteStoryAfter24Hours(document,story.storageId??"");
          if( deleted == false){
            stories.add(story);
          }
        }

        return stories;
      }
    } on AppwriteException catch (exception) {
      print(exception);
    }
    return [];
  }

  Future<bool>deleteStoryAfter24Hours(Document document,String storageId) async{

    final dateTime = DateTime.parse(document.$createdAt).toLocal();
    if(DateTime.now().toLocal().difference(dateTime).inHours > 24){
      final stories = await getByStorageId(storageId);
      if(stories.isNotEmpty){
        for(StoryAppwrite story in stories){
          deleteStory(story.id ??"");
        }
      }
      return true;
    }
    return false;
  }

  deleteStory(String storyId) async {
    try {
      await _databases.deleteDocument(
          databaseId: Strings.databaseId,
          collectionId: Strings.collectionStoryId,
          documentId: storyId);

      return true;
    } on AppwriteException catch (exception) {
      print('delete message $exception');
    }
    return false;
  }
  deleteAllStories(String storageId) async {

    final stories = await getByStorageId(storageId);
    if(stories.isNotEmpty){
      for(StoryAppwrite story in stories){
        deleteStory(story.id ??"");
      }
      return true;
    }
    return false;
  }



  Future<bool> createStory(StoryState state) async {
    try {
      createSingleStory(state, state.myUserId);
      if (state.friends != null && state.friends!.isNotEmpty) {
        for (FriendContactRealm friend in state.friends!) {
          createSingleStory(state, friend.mobileNumber ?? "");
        }
      }
      return true;
    } catch (e) {
      print('createStory $e');
    }
    return false;
  }

  Future<void> createSingleStory(StoryState state, String friendId) async {
    try {
      final id = ObjectId().hexString;
      StoryAppwrite story = StoryAppwrite(
          userId: state.myUserId,
          friendId: friendId,
          storyType: state.storyType,
          storageId: state.storageId,
          id: id,
          seen: false);
      await _databases.createDocument(
          databaseId: Strings.databaseId,
          collectionId: Strings.collectionStoryId,
          documentId: id,
          data: story.toJson());
    } catch (e) {
      print('createSingleStory $e');
    }
  }


  Future<List<StoryAppwrite>> getSeenFromFriends(String userId,String storageId) async {
    try {
      DocumentList documentList = await _databases.listDocuments(
          databaseId: Strings.databaseId,
          collectionId: Strings.collectionStoryId,
          queries: [
            Query.equal("storageId", [storageId]),
            Query.equal("seen", [true]),
            Query.orderDesc('\$updatedAt'),
            Query.limit(100),
          ]);

      List<StoryAppwrite> stories = [];
      if (documentList.total > 0) {
        for (Document document in documentList.documents) {
          StoryAppwrite story = StoryAppwrite.fromJson(document.data);
          stories.add(story);
        }

        return stories;
      }
    } on AppwriteException catch (exception) {
      print(exception);
    }
    return [];
  }

  Future<List<StoryAppwrite>> getByStorageId(String storageId) async {
    try {
      DocumentList documentList = await _databases.listDocuments(
          databaseId: Strings.databaseId,
          collectionId: Strings.collectionStoryId,
          queries: [
            Query.equal("storageId", [storageId]),
            Query.limit(100),
          ]);
      List<StoryAppwrite> stories = [];
      if (documentList.total > 0) {
        for (Document document in documentList.documents) {
          StoryAppwrite story = StoryAppwrite.fromJson(document.data);
          stories.add(story);
        }

        return stories;
      }
    } on AppwriteException catch (exception) {
      print(exception);
    }
    return [];
  }
}





import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:chat_with_bisky/constant/strings.dart';
import 'package:chat_with_bisky/core/providers/DatabaseProvider.dart';
import 'package:chat_with_bisky/core/providers/RealmProvider.dart';
import 'package:chat_with_bisky/model/FriendContact.dart';
import 'package:chat_with_bisky/model/FriendState.dart';
import 'package:chat_with_bisky/model/UserAppwrite.dart';
import 'package:chat_with_bisky/model/db/FriendContactRealm.dart';
import 'package:chat_with_bisky/service/LocalStorageService.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/foundation.dart';
import 'package:realm/realm.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/services.dart';
import 'package:chat_with_bisky/core/providers/StorageProvider.dart';
import 'package:chat_with_bisky/core/providers/UserRepositoryProvider.dart';
import 'package:chat_with_bisky/core/util/Util.dart';
part 'FriendListViewModel.g.dart';
@riverpod
class FriendListNotifier  extends _$FriendListNotifier{

  Databases get _databases => ref.read(databaseProvider);
  Realm get _realm => ref.read(realmProvider);
  Storage get _storage => ref.read(storageProvider);
  @override
  FriendState build(){
    ref.keepAlive();
    return FriendState();
  }


  changedUserId(String userId){

    state = state.copyWith(
      myUserId: userId
    );
  }
  loader(bool input){

    state = state.copyWith(
      loading: input
    );
  }

  getMyFriends(String userId) async {

    DocumentList documentList = await _databases.listDocuments(databaseId: Strings.databaseId,
        collectionId: Strings.collectionContactsId,
        queries: [
          Query.equal("userId", [userId]),
        ]);

    if(documentList.total > 0){

      List<Document> documents =documentList.documents;

      for(Document document in documents){

        FriendContact friend = FriendContact.fromJson(document.data);

        FriendContactRealm friendContactRealm = FriendContactRealm(
          ObjectId(),
          userId: friend.userId,
          mobileNumber: friend.mobileNumber,
          displayName: friend.displayName,
        );
        final user = await ref.read(userRepositoryProvider).getUser(friend.mobileNumber??"");
        if(user != null && user.profilePictureStorageId != null){
          Uint8List imageBytes = await _storage.getFilePreview(
            bucketId: Strings.profilePicturesBucketId,
            fileId: user.profilePictureStorageId ?? "",
          );
          friendContactRealm.base64Image = uint8ListToBase64(imageBytes);
        }
        createOrUpdateFriend(friendContactRealm);

      }
      initializeFriends(userId);

    }

  }



  createOrUpdateFriend(FriendContactRealm friendContactRealm){

    final results = _realm.query<FriendContactRealm>(r'mobileNumber = $0',[friendContactRealm.mobileNumber]);

    print(friendContactRealm.userId);
    print(friendContactRealm.displayName);
    print(friendContactRealm.mobileNumber);
    print(results.length);
    if(results.isNotEmpty){
      FriendContactRealm retrieved = results.first;
      friendContactRealm.id = retrieved.id;
    }

    _realm.write(() {
      _realm.add(friendContactRealm,update: true);

    });
  }

  initializeFriends(String userId){

    final results = _realm.query<FriendContactRealm>(r'userId = $0 SORT(displayName ASC)',[userId]);

    if(results.isNotEmpty){
      state = state.copyWith(
        friends: results.toList()
      );
    }

  }

  Future<bool>getContactsListAndPersistFriend() async {
    if(kIsWeb){
      return false;
    }
    try{
      loader(true);
      List<Contact>  contacts = await ContactsService.getContacts(withThumbnails: false);
      String dialCode = await LocalStorageService.getString(LocalStorageService.dialCode) ?? "";
      if(contacts.isNotEmpty){
        List<String> mobileNumbers = [];
        Map<String,List<String>> contactsMap = {};
        for(Contact contact in contacts){
          if(contact.phones != null && contact.phones?.isNotEmpty == true){
            for(Item item in contact.phones!){
              String? phone = item.value;
              if(phone != null){
                //+3249 323 343
                //+3249-323-343
                //3249323343
                //049323343
                phone = phone.replaceAll(" ", "");
                if(phone.startsWith("+")){
                  phone = phone.substring(1);
                }else if(phone.startsWith("0")){
                  //01222222222
                  //321222222222
                  phone = "$dialCode${phone.substring(1)}";
                }
                phone = removeSpecialCharacters(phone);
                if(phone.isEmpty){
                  continue;
                }
                if(mobileNumbers.length >= 100){
                  contactsMap[ObjectId().hexString] = mobileNumbers;
                  mobileNumbers = [];
                  mobileNumbers.add(phone);
                }else{
                  mobileNumbers.add(phone);
                }
              }
            }
          }
        }
        if(mobileNumbers.isNotEmpty && mobileNumbers.length < 100){
          contactsMap[ObjectId().hexString] = mobileNumbers;
        }
        if(contactsMap.isNotEmpty){
        contactsMap.forEach((key, value) async {
            DocumentList documentList = await _databases.listDocuments(databaseId: Strings.databaseId,
                collectionId: Strings.collectionUsersId,
                queries: [
                  Query.equal('userId', value)
                ]);
            if(documentList.total > 0){
              // create friend
              List<FriendContact>  friends = [];
              for(Document document in documentList.documents){
                UserAppwrite user =  UserAppwrite.fromJson(document.data);
                FriendContact contact= FriendContact(
                  mobileNumber: user.userId,
                  displayName: user.name,
                  userId: state.myUserId,
                );
                friends.add(contact);
              }
             await createOrUpdateMyFriends(friends,state.myUserId);
            }
          });
        }
      }
      loader(false);
      return true;
    }catch(exception){
      print(exception);
    }
    loader(false);
    return false;
  }

  String removeSpecialCharacters(String mobileNumber){
    return mobileNumber.replaceAll(RegExp('[^0-9]'), '');
  }

  Future<void> createOrUpdateMyFriends(List<FriendContact> friends,String userId) async {
    for(FriendContact friend in friends){
      try{
        DocumentList documentList = await _databases.listDocuments(databaseId: Strings.databaseId, collectionId: Strings.collectionContactsId,
            queries: [
              Query.equal("mobileNumber", [friend.mobileNumber ?? ""]),
              Query.equal("userId", [userId]),
            ]);
        if(documentList.total > 0){
          Document document = documentList.documents.first;
          FriendContact friendContact =  FriendContact.fromJson(document.data);
          friendContact.displayName = friend.displayName;
          Document updatedDocument = await _databases.updateDocument(databaseId: Strings.databaseId, collectionId: Strings.collectionContactsId, documentId: document.$id,data: friendContact.toJson());
          print("contact document updated ${updatedDocument.$id}");
        }else{
          Document newDocument = await _databases.createDocument(databaseId: Strings.databaseId, collectionId: Strings.collectionContactsId, documentId: ObjectId().hexString, data: friend.toJson());
          print("contact document created ${newDocument.$id}");
        }
      }catch (exception){
        print(exception);
      }
    }
  }


}

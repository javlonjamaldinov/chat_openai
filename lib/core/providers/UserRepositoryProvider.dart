import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:chat_with_bisky/constant/strings.dart';
import 'package:chat_with_bisky/core/providers/DatabaseProvider.dart';
import 'package:chat_with_bisky/model/UserAppwrite.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final userRepositoryProvider =
    Provider((ref) => UserDataRepositoryProvider(ref));

class UserDataRepositoryProvider {
  final Ref _ref;

  Databases get _db => _ref.read(databaseProvider);

  UserDataRepositoryProvider(this._ref);

  Future<UserAppwrite?> getUser(String id) async {
    try {

      Document document = await _db.getDocument(
          databaseId: Strings.databaseId,
          collectionId: Strings.collectionUsersId,
          documentId: id);

      return UserAppwrite.fromJson(document.data);
    } on AppwriteException catch (e) {
      print('ERROR AppwriteException getUser $e');
    } catch (e) {
      print('ERROR Exception getUser $e');
    }

    return null;
  }


  Future<UserAppwrite?> updateUser(UserAppwrite userAppwrite) async {
    try {
      Document document = await _db.updateDocument(
          databaseId: Strings.databaseId,
          collectionId: Strings.collectionUsersId,
          documentId: userAppwrite.userId ?? "",
      data: userAppwrite.toJson());

      return UserAppwrite.fromJson(document.data);
    } on AppwriteException catch (e) {
      print('ERROR updateUser $e');

      if(e.code == 409){

        return userAppwrite;
      }else  if(e.code == 404){

        Document document = await _db.createDocument(databaseId: Strings.databaseId, collectionId: Strings.collectionUsersId,
            documentId:  userAppwrite.userId ?? "", data: userAppwrite.toJson());
        return UserAppwrite.fromJson(document.data);
      }
    } catch (e) {
      print('ERROR updateUser $e');
    }

    return null;
  }
}

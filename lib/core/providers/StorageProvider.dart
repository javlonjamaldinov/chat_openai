import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:chat_with_bisky/core/providers/AppwriteClientProvider.dart';
import 'package:chat_with_bisky/model/db/ChatRealm.dart';
import 'package:chat_with_bisky/model/db/FriendContactRealm.dart';
import 'package:chat_with_bisky/model/db/MessageRealm.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:realm/realm.dart';


final storageProvider=  Provider((ref) => Storage(clientService.getClient()));


final storageAppwriteProvider =
Provider((ref) => StorageAppwriteProvider(ref));

class StorageAppwriteProvider {
  final Ref _ref;

  Storage get _storage => _ref.read(storageProvider);

  StorageAppwriteProvider(this._ref);

  Future<File?> uploadMedia(String fileId, String filePath,String bucketId) async {
    try {
      File file = await _storage.createFile(
          bucketId: bucketId,
          fileId: fileId,
          file: InputFile(
              path: filePath,
              filename: '$fileId.${getFileExtension(filePath)}'));

      return file;
    } catch (e) {
      print(e);
    }

    return null;
  }
  Future<bool> delete(String fileId,String bucketId) async {
    try {
      await _storage.deleteFile(bucketId:bucketId, fileId:fileId);


      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  String getFileExtension(String filePath) {
    try {
      return '.${filePath.split('.').last}';
    } catch (e) {
      return "";
    }
  }
}



import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:chat_with_bisky/constant/strings.dart';
import 'package:chat_with_bisky/core/providers/DatabaseProvider.dart';
import 'package:chat_with_bisky/core/providers/GroupRepositoryProvider.dart';
import 'package:chat_with_bisky/core/providers/StorageProvider.dart';
import 'package:chat_with_bisky/model/UserAppwrite.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final profileRepositoryProvider =
Provider((ref) => ProfileRepositoryProvider(ref));

class ProfileRepositoryProvider {
  final Ref _ref;
  Storage get _storage => _ref.read(storageProvider);
  GroupRepositoryProvider get _groupRepositoryProvider => _ref.read(groupRepositoryProvider);

  ProfileRepositoryProvider(this._ref);


  Future<bool> uploadGroupProfilePicture(
      String? imageExist, String imageId, String path) async {
    try {
      if (imageExist != null) {
        await _storage.deleteFile(
            bucketId: Strings.profilePicturesBucketId, fileId: imageExist);
      }
      File file = await _storage.createFile(
        bucketId: Strings.profilePicturesBucketId,
        fileId: imageId,
        file: InputFile(
            path: path, filename: '$imageId${getFileExtension(path)}'),
      );

      return true;
    } on AppwriteException catch (exception) {
      print(exception);
    }
    return false;
  }

  String getFileExtension(String fileName) {
    try {
      return ".${fileName.split('.').last}";
    } catch (e) {
      return "";
    }
  }

  Future<Uint8List?> getExistingProfilePicture(String imageId) async {
    try {
      Uint8List uint8list = await _storage.getFilePreview(
          bucketId: Strings.profilePicturesBucketId, fileId: imageId);

      return uint8list;
    } on AppwriteException catch (exception) {
      print(exception);
    }
    return null;
  }
}

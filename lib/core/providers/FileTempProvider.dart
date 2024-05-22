import 'dart:io';

import 'package:chat_with_bisky/core/providers/StorageProvider.dart';
import 'package:path_provider/path_provider.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:appwrite/models.dart' as model;
part 'FileTempProvider.g.dart';
@riverpod
Future<File> fileTemp(FileTempRef ref,
    String bucketId,
    String id) async{

  ref.keepAlive();
  final storageProviderRef =  ref.read(storageProvider);
  model.File fileAppwrite = await storageProviderRef.getFile(bucketId: bucketId, fileId: id);

  final dir =await getTemporaryDirectory();
  final file = File('${dir.path}/${fileAppwrite.name}');
  if(await file.exists()){
    return file;
  }
  final dataResponse = await storageProviderRef.getFileDownload(bucketId: bucketId, fileId: id);
  await file.writeAsBytes(dataResponse);
  return file;
}

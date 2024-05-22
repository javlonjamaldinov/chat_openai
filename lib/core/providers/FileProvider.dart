

import 'dart:io';

import 'package:chat_with_bisky/constant/strings.dart';
import 'package:chat_with_bisky/core/providers/DirectoryProvider.dart';
import 'package:chat_with_bisky/core/providers/StorageProvider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'FileProvider.g.dart';
@riverpod
Future<File> file(FileRef ref,
String bucketId,
String id,
String fileName) async{

  ref.keepAlive();
  final dir =await ref.read(directoryProvider.future);
  final file = File('${dir.path}/$fileName');
  if(await file.exists()){

    return file;
  }

  final dataResponse = await ref.read(storageProvider).getFileDownload(bucketId: Strings.messagesBucketId, fileId: id);
  await file.writeAsBytes(dataResponse);
  return file;
}

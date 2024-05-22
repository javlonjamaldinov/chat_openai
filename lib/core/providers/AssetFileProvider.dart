
import 'package:flutter/services.dart' show ByteData, rootBundle;

import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'AssetFileProvider.g.dart';
@riverpod
Future<ByteData> assetFile(AssetFileRef ref,
String filePath) async{

  ref.keepAlive();
  print(filePath);

  return rootBundle.load(filePath);
}

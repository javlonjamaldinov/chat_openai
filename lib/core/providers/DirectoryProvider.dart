

import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';

final directoryProvider = FutureProvider((ref) => getApplicationDocumentsDirectory());

Future<File> getTempFile(String fileName) async{

  final dir =await getTemporaryDirectory();
  return  File('${dir.path}/$fileName');
}

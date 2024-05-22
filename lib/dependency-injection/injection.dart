


import 'package:chat_with_bisky/service/AppwriteClient.dart';
import 'package:chat_with_bisky/service/LocalStorageService.dart';
import 'package:kiwi/kiwi.dart';

void initializeKiwi(){

  KiwiContainer container=KiwiContainer();
  container
  ..registerFactory((container) => AppWriteClientService())
  ..registerFactory((container) => LocalStorageService())

  ;
}

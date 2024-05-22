


import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:chat_with_bisky/constant/strings.dart';
import 'package:chat_with_bisky/core/providers/AppwriteClientProvider.dart';
import 'package:chat_with_bisky/core/providers/RealtimeProvider.dart';
import 'package:chat_with_bisky/model/RealtimeNotifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final realtimeNotifierProvider= StreamProvider<RealtimeNotifier>((ref) {
  final realtime = ref.read(realtimeProvider);
  final controller = StreamController<RealtimeNotifier>();

  const channels =[
    'databases.${Strings.databaseId}.collections.${Strings.collectionChatsId}.documents',
    'databases.${Strings.databaseId}.collections.${Strings.collectionMessagesId}.documents',
    'databases.${Strings.databaseId}.collections.${Strings.collectionCalleeId}.documents',
    'databases.${Strings.databaseId}.collections.${Strings.collectionCallerId}.documents',
    'databases.${Strings.databaseId}.collections.${Strings.collectionRoomId}.documents',
    'databases.${Strings.databaseId}.collections.${Strings.collectionGroupId}.documents',
    'databases.${Strings.databaseId}.collections.${Strings.collectionGroupMembersId}.documents',
  ];

  final subscription = realtime.subscribe(channels).stream.listen((message) {

    for(var channel in channels){

      final filterEvents = message.events.where((element) => element.contains(channel));

      if(filterEvents.isNotEmpty){

        final event = filterEvents.first;
        final type = event.split('.').last;


        if([
          RealtimeNotifier.delete,
          RealtimeNotifier.create,
          RealtimeNotifier.update
        ].contains(type)){

          final document = Document.fromMap(message.payload);

          controller.add(RealtimeNotifier(type, document));
        }

      }


    }


  });

  ref.onDispose(() {
    subscription.cancel();
  });

  return controller.stream;
});

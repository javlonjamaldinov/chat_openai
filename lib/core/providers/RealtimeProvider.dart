import 'package:appwrite/appwrite.dart';
import 'package:chat_with_bisky/core/providers/AppwriteClientProvider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final realtimeProvider=  Provider((ref) => Realtime(clientService.getClient()));

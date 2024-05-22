import 'package:appwrite/appwrite.dart';
import 'package:chat_with_bisky/core/providers/AppwriteClientProvider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final databaseProvider=  Provider((ref) => Databases(clientService.getClient()));

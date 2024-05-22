import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:chat_with_bisky/core/providers/AppwriteClientProvider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final appwriteAccountProvider =
    Provider((ref) => Account(clientService.getClient()));

final accountRepositoryProvider =
    Provider((ref) => AccountRepositoryProvider(ref));

class AccountRepositoryProvider {
  final Ref _ref;

  Account get _account => _ref.read(appwriteAccountProvider);

  AccountRepositoryProvider(this._ref);

  Future<User?> updateAccountName(String name) async {
    try {
      return await _account.updateName(name: name);
    } on AppwriteException catch (e) {
      print('ERROR updateAccountName $e');
    } catch (e) {
      print('ERROR updateAccountName $e');
    }
    return null;
  }
}

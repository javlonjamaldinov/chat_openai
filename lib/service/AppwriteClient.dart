import 'package:appwrite/appwrite.dart';
import 'package:chat_with_bisky/constant/strings.dart';

class AppWriteClientService {
  Client getClient() {
    return Client()
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject(Strings.projectId);
  }
}

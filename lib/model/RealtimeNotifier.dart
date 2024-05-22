

import 'package:appwrite/models.dart';

class RealtimeNotifier{

  final String type;
  final Document document;

  RealtimeNotifier(this.type, this.document);


  static const create = "create";
  static const delete = "delete";
  static const update = "update";
  static const loading = "loading";
}

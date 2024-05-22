
import 'package:shared_preferences/shared_preferences.dart';


class LocalStorageService{


  static String stage = "STAGE";
  static String userId = "USER_ID";
  static String dashboardPage = "DASHBOARD_PAGE";
  static String updateNamePage = "UPDATE_NAME_PAGE";
  static String dialCode = "DIAL_CODE";
  static String callInProgress = "CALL_IN_PROGRESS";

  static Future<void> putString(String key,String value) async{

    SharedPreferences preferences= await SharedPreferences.getInstance();
    preferences.setString(key, value);
  }

  static Future<String?> getString(String key) async{

    SharedPreferences preferences= await SharedPreferences.getInstance();
    return  preferences.getString(key);
  }
  static Future<bool> deleteKey(String key) async{

    SharedPreferences preferences= await SharedPreferences.getInstance();
    return  preferences.remove(key);
  }


}

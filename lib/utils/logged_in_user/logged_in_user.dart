import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoggedInUser {
  static Future<void> saveSession(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('loggedInUser', id);
  }

  static Future<String?> getSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('loggedInUser');
  }

  static Future<void> clearSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('loggedInUser');
  }

  static Future<String?> getLoggedInUser() async {
    final deviceStorage = GetStorage();
    return deviceStorage.read('loggedInUser');
  }
}

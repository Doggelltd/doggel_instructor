import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  Future<bool> setAuthToken(String token) async {
    final pref = await SharedPreferences.getInstance();
    return pref.setString(userPref.authToken.toString(), token);
  }

  Future<String?> getAuthToken() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(userPref.authToken.toString());
  }

  Future<bool> setBoarding(String boarding) async {
    final pref = await SharedPreferences.getInstance();
    return pref.setString("boarding", boarding);
  }

  Future<String?> getBoarding() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString("boarding");
  }
}

// ignore: camel_case_types
enum userPref {
  authToken,
}

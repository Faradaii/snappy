import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:snappy/data/models/model/model_login_result.dart';

class PreferencesHelper {
  final Future<SharedPreferences> sharedPreferences;

  PreferencesHelper({required this.sharedPreferences});

  static const isFirstTime = 'IS_FIRST_TIME';
  static const user = 'User';

  Future<LoginResult?> getSavedUser() async {
    final SharedPreferences prefs = await sharedPreferences;
    LoginResult result = LoginResult.fromJson(
      json: json.decode(prefs.getString(user) ?? '{}'),
    );
    return result;
  }

  Future<String?> getToken() async {
    final SharedPreferences prefs = await sharedPreferences;
    String token = await getSavedUser().then((value) => value?.token ?? '');
    return token;
  }

  Future<void> setSavedUser(LoginResult newUser) async {
    final SharedPreferences prefs = await sharedPreferences;
    String user = jsonEncode(newUser.toJson());
    await prefs.setString(user, user);
  }

  Future<bool> getIsFirstTime() async {
    final SharedPreferences prefs = await sharedPreferences;
    return prefs.getBool(isFirstTime) ?? true;
  }

  Future<void> setFirstTime(bool value) async {
    final SharedPreferences prefs = await sharedPreferences;
    await prefs.setBool(isFirstTime, value);
  }
}

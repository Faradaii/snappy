import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:snappy/common/constant/app_constant.dart';
import 'package:snappy/data/models/model/model_login_result.dart';

class PreferencesHelper {
  final SharedPreferences sharedPreferences;

  PreferencesHelper({required this.sharedPreferences});

  static const isFirstTime = 'IS_FIRST_TIME';
  static const user = 'User';
  static const language = 'Language';

  Future<LoginResult?> getSavedUser() async {
    final savedData = sharedPreferences.getString(user);
    if (savedData == null || savedData.isEmpty) {
      return null;
    }

    LoginResult result = LoginResult.fromJson(json: json.decode(savedData));
    return result;
  }

  Future<String?> getToken() async {
    String token = await getSavedUser().then((value) => value?.token ?? '');
    return token;
  }

  Future<void> setSavedUser(LoginResult newUser) async {
    String user = jsonEncode(newUser.toJson());
    await sharedPreferences.setString(user, user);
  }

  Future<bool> getIsFirstTime() async {
    return sharedPreferences.getBool(isFirstTime) ?? true;
  }

  Future<void> setFirstTime(bool value) async {
    await sharedPreferences.setBool(isFirstTime, value);
  }

  Future<AppLanguage?> getLanguage() async {
    return AppLanguage.values.firstWhere((e) =>
    e.name == sharedPreferences.getString(language));
  }

  Future<void> setLanguage(AppLanguage newLanguage) async {
    await sharedPreferences.setString(language, newLanguage.name);
  }
}

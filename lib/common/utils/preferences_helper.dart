import 'dart:convert';
import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:snappy/data/models/model/model_login_result.dart';
import 'package:snappy/domain/entities/user_entity.dart';

class PreferencesHelper {
  final SharedPreferences sharedPreferences;

  PreferencesHelper({required this.sharedPreferences});

  static const isFirstTimePref = 'IS_FIRST_TIME';
  static const userLoggedPref = 'USER_LOGGED';
  static const languageSelectedPref = 'LANGUAGE_SELECTED';

  Future<User?> getSavedUser() async {
    final savedData = sharedPreferences.getString(userLoggedPref);
    if (savedData == null || savedData.isEmpty) {
      return null;
    }

    User result = LoginResult.fromJson(json: json.decode(savedData)).toEntity();
    return result;
  }

  Future<String?> getToken() async {
    String token = await getSavedUser().then((value) => value?.token ?? '');
    return token;
  }

  Future<void> setSavedUser(User? newUser) async {
    if (newUser == null) {
      await sharedPreferences.remove(userLoggedPref);
      return;
    }
    String user = jsonEncode(LoginResult(
            name: newUser.name,
            email: newUser.email,
            userId: newUser.userId,
            token: newUser.token)
        .toJson());
    await sharedPreferences.setString(userLoggedPref, user);
  }

  Future<bool> getIsFirstTime() async {
    return sharedPreferences.getBool(isFirstTimePref) ?? true;
  }

  Future<void> setFirstTime(bool value) async {
    await sharedPreferences.setBool(isFirstTimePref, value);
  }

  Future<Locale?> getLanguage() async {
    return Locale(sharedPreferences.getString(languageSelectedPref) ?? 'en');
  }

  Future<void> toggleLanguage() async {
    Locale? locale = await getLanguage();
    String newLanguage = locale?.languageCode == 'en' ? 'id' : 'en';
    await sharedPreferences.setString(languageSelectedPref, newLanguage);
  }

  Future<void> setLanguage(Locale newLanguage) async {
    await sharedPreferences.setString(
        languageSelectedPref, newLanguage.languageCode);
  }
}

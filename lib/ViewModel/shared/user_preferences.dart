import 'dart:convert';

import 'package:locaface/Model/auth_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum UserPref { model, token, email, password }

class UserPreferences {
  Future<bool> clear(String key) async {
    final pref = await SharedPreferences.getInstance();
    return pref.remove(key);
  }

  Future<bool> setUserModel(AuthModel user) async {
    final pref = await SharedPreferences.getInstance();
    return pref.setString(UserPref.model.toString(), jsonEncode(user.toJson()));
  }

  Future<AuthModel?> getUserModel() async {
    final pref = await SharedPreferences.getInstance();
    final saveUser = pref.getString(UserPref.model.toString());
    if (saveUser == null) {
      return null;
    }
    return AuthModel.fromJson(jsonDecode(saveUser));
  }

  Future<bool> clearUserModel() async {
    return clear(UserPref.model.toString());
  }

  Future<bool> setToken(String token) async {
    final pref = await SharedPreferences.getInstance();
    return pref.setString(UserPref.token.toString(), token);
  }

  Future<String?> getToken() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(UserPref.token.toString());
  }

  Future<bool> clearToken() async {
    return clear(UserPref.token.toString());
  }

  Future<bool> setAuthEmail(String email) async {
    final pref = await SharedPreferences.getInstance();
    return pref.setString(UserPref.email.toString(), email);
  }

  Future<String?> getAuthEmail() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(UserPref.email.toString());
  }

  Future<bool> clearAuthEmail() async {
    return clear(UserPref.email.toString());
  }

  Future<bool> setAuthPassword(String password) async {
    final pref = await SharedPreferences.getInstance();
    return pref.setString(UserPref.password.toString(), password);
  }

  Future<String?> getAuthPassword() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(UserPref.password.toString());
  }

  Future<bool> clearPassword() async {
    return clear(UserPref.password.toString());
  }
}

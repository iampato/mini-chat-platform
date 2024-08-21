import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  static const String userKey = "user_key";
  static const String tokenKey = "token_key";
  static const String refreshTokenKey = "refresh_token_key";
  static const String phoneKey = "phone_key";
  static const String defaultKey = "default_key";

  Future<void> setToken(String value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(tokenKey, value);
  }

  Future<String> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(tokenKey) ?? '';
  }

  Future<void> setRefreshToken(String value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(refreshTokenKey, value);
  }

  Future<String?> getRefreshToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(refreshTokenKey);
  }

  Future<void> setUser(String value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(userKey, value);
  }

  Future<String?> getUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userKey);
  }

  Future<void> setDefault(String value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(defaultKey, value);
  }

  Future<void> removeDefault() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove(defaultKey);
  }

  Future<String?> getDefault() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(defaultKey);
  }

  Future<void> setPhone(String value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(phoneKey, value);
  }

  Future<String?> getPhone() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(phoneKey);
  }

  /// destory()
  /// -Async function that clears all of the values stored in
  /// shared preferences
  /// - call this function during logout
  Future<void> destory() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }
}

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefSingleton {
  static final SharedPrefSingleton _instance = SharedPrefSingleton._internal();
  factory SharedPrefSingleton() => _instance;
  SharedPrefSingleton._internal();
  late SharedPreferences _pref;
  Future<void> initialize() async {
    _pref = await SharedPreferences.getInstance();
  }

  Future<bool> setAutoFirewall(bool ok) => _pref.setBool("auto_firewall", ok);
  bool get autoFirewall => _pref.getBool("auto_firewall") ?? true;

  Future<bool> setAppTheme(bool ok) => _pref.setBool("app_theme", ok);
  // false = dark, true = light
  bool get appTheme => _pref.getBool("app_theme") ?? false;

  Future<bool> setSavedConnection(String config) =>
      _pref.setString("saved_connection", config);
  String get savedConnection => _pref.getString("saved_connection") ?? "[]";
}

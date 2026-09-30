import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {

  static const String
      _notificationsKey =
          "notifications_enabled";

  static Future<String>
      getCurrency() async {

    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getString(
          "currency",
        ) ??
        "FCFA";
  }

  static Future<void>
      saveCurrency(
    String currency,
  ) async {

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      "currency",
      currency,
    );
  }

  static Future<bool>
      getNotificationsEnabled() async {

    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getBool(
          _notificationsKey,
        ) ??
        true;
  }

  static Future<void>
      setNotificationsEnabled(
    bool value,
  ) async {

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setBool(
      _notificationsKey,
      value,
    );
  }
}
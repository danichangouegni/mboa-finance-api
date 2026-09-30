import 'package:shared_preferences/shared_preferences.dart';

class UserService {

  static const String nameKey =
      "user_name";

  static const String emailKey =
      "user_email";

  static Future<void> saveUser({
    required String name,
    required String email,
  }) async {

    final prefs =
        await SharedPreferences
            .getInstance();

    await prefs.setString(
      nameKey,
      name,
    );

    await prefs.setString(
      emailKey,
      email,
    );

  }

  static Future<String> getName()
  async {

    final prefs =
        await SharedPreferences
            .getInstance();

    return prefs.getString(
          nameKey,
        ) ??
        "Utilisateur";

  }

  static Future<String> getEmail()
  async {

    final prefs =
        await SharedPreferences
            .getInstance();

    return prefs.getString(
          emailKey,
        ) ??
        "";

  }

}
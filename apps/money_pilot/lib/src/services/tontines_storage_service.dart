import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class TontinesStorageService {

  static const String tontinesKey =
      "tontines";

  static Future<void> saveTontines(
    List<Map<String, dynamic>> tontines,
  ) async {

    final prefs =
        await SharedPreferences.getInstance();

    final data =
        tontines
            .map((e) => jsonEncode(e))
            .toList();

    await prefs.setStringList(
      tontinesKey,
      data,
    );
  }

  static Future<List<Map<String, dynamic>>>
      loadTontines() async {

    final prefs =
        await SharedPreferences.getInstance();

    final data =
        prefs.getStringList(tontinesKey);

    if (data == null) {
      return [];
    }

    return data.map((item) {

      return Map<String, dynamic>.from(
        jsonDecode(item),
      );

    }).toList();
  }
}
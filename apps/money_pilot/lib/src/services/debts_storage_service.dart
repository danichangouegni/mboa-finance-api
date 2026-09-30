import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class DebtsStorageService {

  static const String debtsKey = 'debts';

  static Future<void> saveDebts(
    List<Map<String, dynamic>> debts,
  ) async {

    final prefs =
        await SharedPreferences.getInstance();

    final data = debts
        .map((e) => jsonEncode(e))
        .toList();

    await prefs.setStringList(
      debtsKey,
      data,
    );
  }

  static Future<List<Map<String, dynamic>>>
      loadDebts() async {

    final prefs =
        await SharedPreferences.getInstance();

    final data =
        prefs.getStringList(debtsKey);

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
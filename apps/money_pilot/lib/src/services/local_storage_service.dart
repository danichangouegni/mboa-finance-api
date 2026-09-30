import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/transaction_model.dart';
import '../models/debt_model.dart';
import '../models/tontine_model.dart';

class LocalStorageService {

  static const String transactionsKey =
      'transactions';

  static const String debtsKey =
    'debts';

  static const String tontinesKey =
    'tontines';

  static Future<void> saveTransactions(
    List<TransactionModel> transactions,
  ) async {

    final prefs =
        await SharedPreferences.getInstance();

    final data = transactions
        .map((e) => jsonEncode(e.toJson()))
        .toList();

    await prefs.setStringList(
      transactionsKey,
      data,
    );
  }

  static Future<void> saveDebts(
  List<DebtModel> debts,
) async {

  final prefs =
      await SharedPreferences
          .getInstance();

  final data = debts
      .map(
        (e) => jsonEncode(
          e.toJson(),
        ),
      )
      .toList();

  await prefs.setStringList(
    debtsKey,
    data,
  );

}

  static Future<List<TransactionModel>>
      loadTransactions() async {

    final prefs =
        await SharedPreferences.getInstance();

    final data =
        prefs.getStringList(transactionsKey);

    if (data == null) {
      return [];
    }

    return data.map((item) {

      return TransactionModel.fromJson(
        jsonDecode(item),
      );

    }).toList();
  }

  static Future<List<DebtModel>>
    loadDebts() async {

  final prefs =
      await SharedPreferences
          .getInstance();

  final data =
      prefs.getStringList(
        debtsKey,
      );

  if (data == null) {

    return [];

  }

  return data.map((item) {

    return DebtModel.fromJson(
      jsonDecode(item),
    );

  }).toList();

}

static Future<void> saveTontines(
  List<TontineModel> tontines,
) async {

  final prefs =
      await SharedPreferences.getInstance();

  final data = tontines
      .map(
        (e) => jsonEncode(
          e.toJson(),
        ),
      )
      .toList();

  await prefs.setStringList(
    tontinesKey,
    data,
  );

}

static Future<List<TontineModel>>
loadTontines() async {

  final prefs =
      await SharedPreferences.getInstance();

  final data =
      prefs.getStringList(
        tontinesKey,
      );

  if (data == null) {
    return [];
  }

  return data.map((item) {

    return TontineModel.fromJson(
      jsonDecode(item),
    );

  }).toList();

}

}

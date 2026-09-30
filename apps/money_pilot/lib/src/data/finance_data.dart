import '../models/transaction_model.dart';
import '../services/local_storage_service.dart';
import '../models/debt_model.dart';
import '../models/tontine_model.dart';

class FinanceData {

  static List<TransactionModel>
      transactions = [];

    static List<DebtModel>
      debts = [];
      
      static List<TontineModel>
      tontines = [];

  static Future<void> load() async {

  transactions =
      await LocalStorageService
          .loadTransactions();

  debts =
      await LocalStorageService
          .loadDebts();

  tontines =
      await LocalStorageService
          .loadTontines();

}


  static Future<void> save() async {

  await LocalStorageService
      .saveTransactions(
        transactions,
      );

  await LocalStorageService
      .saveDebts(
        debts,
      );

  await LocalStorageService
      .saveTontines(
        tontines,
      );

}
}
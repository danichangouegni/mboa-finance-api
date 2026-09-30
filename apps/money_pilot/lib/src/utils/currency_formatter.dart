import 'package:intl/intl.dart';

class CurrencyFormatter {

  static String format(num amount) {

    final formatter = NumberFormat(
      '#,###',
      'fr_FR',
    );

    return formatter.format(amount);
  }
}
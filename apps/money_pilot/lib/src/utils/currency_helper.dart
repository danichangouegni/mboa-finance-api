class CurrencyHelper {

  static String symbol(String currency) {

    switch (currency) {

      case "EUR":
        return "€";

      case "USD":
        return "\$";

      case "GBP":
        return "£";

      case "NGN":
        return "₦";

      case "CDF":
        return "FC";

      case "FCFA":
      default:
        return "FCFA";
    }
  }
}
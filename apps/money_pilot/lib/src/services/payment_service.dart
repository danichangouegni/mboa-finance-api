import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentService {
  static const String baseUrl =
      "https://api.danicha.stockges.com";

  static Future<bool> subscribe({
    required String provider,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(
          "$baseUrl/api/subscriptions/pay",
        ),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "provider": provider,
          "amount": 1850,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
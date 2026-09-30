import 'dart:convert';

import 'package:http/http.dart' as http;

import 'auth_service.dart';
import 'api_service.dart';

class TransactionService {

  static Future<Map<String, dynamic>>
      createTransaction({

    required String title,

    required double amount,

    required String transactionType,

    required String transactionDate,

    String notes = "",

  }) async {

    final token =
        await AuthService.getToken();

    print("TOKEN TRANSACTION:");
    print(token);

    final response =
        await http.post(

      Uri.parse(
        "${ApiService.baseUrl}/api/transactions",
      ),

      headers: {

        "Content-Type":
            "application/json",

        "Authorization":
            "Bearer $token",

      },

      body: jsonEncode({

        "title": title,

        "amount": amount,

        "transaction_type":
            transactionType,

        "transaction_date":
            transactionDate,

        "notes": notes,

      }),

    );

    print("TRANSACTION STATUS:");
    print(response.statusCode);

    print("TRANSACTION BODY:");
    print(response.body);

    return jsonDecode(
      response.body,
    );

  }

  static Future<List<dynamic>>
      getTransactions() async {

    final token =
        await AuthService.getToken();

    print("TOKEN GET TRANSACTIONS:");
    print(token);

    final response =
        await http.get(

      Uri.parse(
        "${ApiService.baseUrl}/api/transactions",
      ),

      headers: {

        "Authorization":
            "Bearer $token",

      },

    );

    print("GET TRANSACTIONS STATUS:");
    print(response.statusCode);

    print("GET TRANSACTIONS BODY:");
    print(response.body);

    final data =
        jsonDecode(response.body);

    return data["transactions"] ?? [];

  }

  static Future<bool>
    deleteTransaction(
  int id,
) async {

  final token =
      await AuthService.getToken();

  final response =
      await http.delete(

    Uri.parse(
      "${ApiService.baseUrl}/api/transactions/$id",
    ),

    headers: {

      "Authorization":
          "Bearer $token",

    },

  );

  final data =
      jsonDecode(response.body);

  return data["success"] == true;

}

static Future<bool>
    updateTransaction({

  required int id,

  required String title,

  required double amount,

  required String transactionType,

  required String transactionDate,

  String notes = "",

}) async {

  final token =
      await AuthService.getToken();

  final response =
      await http.put(

    Uri.parse(
      "${ApiService.baseUrl}/api/transactions/$id",
    ),

    headers: {

      "Content-Type":
          "application/json",

      "Authorization":
          "Bearer $token",

    },

    body: jsonEncode({

      "title": title,

      "amount": amount,

      "transaction_type":
          transactionType,

      "transaction_date":
          transactionDate,

      "notes": notes,

    }),

  );

  print("===== UPDATE TRANSACTION =====");
  print("ID: $id");
  print("STATUS: ${response.statusCode}");
  print("BODY: ${response.body}");

  final data =
      jsonDecode(response.body);

  return data["success"] == true;
}
  

}
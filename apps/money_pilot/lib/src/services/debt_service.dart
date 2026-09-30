import 'dart:convert';
import 'package:http/http.dart' as http;

import 'api_service.dart';
import 'auth_service.dart';

class DebtService {

  static Future<List<dynamic>> getDebts() async {

    final token =
        await AuthService.getToken();

    final response =
        await http.get(

      Uri.parse(
        "${ApiService.baseUrl}/api/debts",
      ),

      headers: {
        "Authorization":
            "Bearer $token",
      },

    );

    final data =
        jsonDecode(response.body);

    return data["debts"] ?? [];
  }

  static Future<bool> createDebt({

    required String personName,
    required double amount,
    required String debtType,
    required String dueDate,
    String notes = "",
  }) async {

    final token =
        await AuthService.getToken();

    final response =
        await http.post(

      Uri.parse(
        "${ApiService.baseUrl}/api/debts",
      ),

      headers: {

        "Content-Type":
            "application/json",

        "Authorization":
            "Bearer $token",

      },

      body: jsonEncode({

        "person_name":
            personName,

        "amount":
            amount,

        "debt_type":
            debtType,

        "due_date":
            dueDate,

        "notes": notes,
      }),

    );

    final data =
        jsonDecode(response.body);

    return data["success"] == true;
  }

  static Future<bool>
      deleteDebt(int id) async {

    final token =
        await AuthService.getToken();

    final response =
        await http.delete(

      Uri.parse(
        "${ApiService.baseUrl}/api/debts/$id",
      ),

      headers: {
        "Authorization":
            "Bearer $token",
      },

    );
    
    final data = jsonDecode(response.body);

    return data["success"] == true;
  }

  static Future<bool> updateDebt({
  required int id,
  required String personName,
  required double amount,
  required String debtType,
  required String dueDate,
  String notes = "",
}) async {

  final token =
      await AuthService.getToken();

  final formattedDate = dueDate.split("T")[0];

  final response = await http.put(
    Uri.parse(
      "${ApiService.baseUrl}/api/debts/$id",
    ),
    headers: {
      "Content-Type":
          "application/json",
      "Authorization":
          "Bearer $token",
    },
   body: jsonEncode({
  "person_name": personName,
  "amount": amount,
  "debt_type": debtType,
  "due_date": formattedDate,
  "notes": notes,
}),
  );

  final data =
      jsonDecode(response.body);

  return data["success"] == true;
}
}
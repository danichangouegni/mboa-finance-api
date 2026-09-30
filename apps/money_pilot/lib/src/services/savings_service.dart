import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_service.dart';
import 'auth_service.dart';

class SavingsService {

  static Future<Map<String, dynamic>>
      getSavings() async {

    final token =
        await AuthService.getToken();

    final response =
        await http.get(

      Uri.parse(
        "${ApiService.baseUrl}/api/savings",
      ),

      headers: {

        "Authorization":
            "Bearer $token",

      },

    );

    if (response.statusCode != 200) {
throw Exception(
response.body);
}
return jsonDecode(
response.body);
  }

  static Future<bool>
      saveSavings({

    required double currentAmount,

    required double targetAmount,

  }) async {

    final token =
        await AuthService.getToken();

    final response =
        await http.post(

      Uri.parse(
        "${ApiService.baseUrl}/api/savings",
      ),

      headers: {

        "Content-Type":
            "application/json",

        "Authorization":
            "Bearer $token",

      },

      body: jsonEncode({

        "current_amount":
            currentAmount,

        "target_amount":
            targetAmount,

      }),

    );

   if (response.statusCode != 200) {
  return false;
}

final data =
    jsonDecode(response.body);

return data["success"] == true;

  }

}
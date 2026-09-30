import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_service.dart';
import 'auth_service.dart';

class GoalService {

  static Future<List<dynamic>> getGoals() async {

    final token =
        await AuthService.getToken();

    final response =
        await http.get(

      Uri.parse(
        "${ApiService.baseUrl}/api/goals",
      ),

      headers: {
        "Authorization":
            "Bearer $token",
      },

    );

    final data =
        jsonDecode(response.body);

    return data["goals"] ?? [];
  }

  static Future<bool> createGoal({

    required String title,
    required double targetAmount,
    required double currentAmount,
    required String targetDate,

  }) async {

    final token =
        await AuthService.getToken();

    final response =
        await http.post(

      Uri.parse(
        "${ApiService.baseUrl}/api/goals",
      ),

      headers: {

        "Content-Type":
            "application/json",

        "Authorization":
            "Bearer $token",

      },

      body: jsonEncode({

        "title":
            title,

        "target_amount":
            targetAmount,

        "current_amount":
            currentAmount,

        "target_date":
            targetDate,

      }),

    );

    print("GOAL STATUS:");
      print(response.statusCode);

      print("GOAL BODY:");
      print(response.body);

      final data =
          jsonDecode(response.body);

      return data["success"] == true;
  }

  static Future<bool> updateGoal({

    required int id,
    required String title,
    required double targetAmount,
    required double currentAmount,
    required String targetDate,
    required String status,

  }) async {

    final token =
        await AuthService.getToken();

    final response =
        await http.put(

      Uri.parse(
        "${ApiService.baseUrl}/api/goals/$id",
      ),

      headers: {

        "Content-Type":
            "application/json",

        "Authorization":
            "Bearer $token",

      },

      body: jsonEncode({

        "title":
            title,

        "target_amount":
            targetAmount,

        "current_amount":
            currentAmount,

        "target_date":
            targetDate,

        "status":
            status,

      }),

    );

    final data =
        jsonDecode(response.body);

    return data["success"] == true;
  }


  static Future<bool>
      deleteGoal(int id) async {

    final token =
        await AuthService.getToken();

    final response =
        await http.delete(

      Uri.parse(
        "${ApiService.baseUrl}/api/goals/$id",
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

  static Future<bool> addContribution({
  required int id,
  required double contribution,
  required double currentAmount,
  required double targetAmount,
  required String title,
  required String targetDate,
}) async {

  final token =
      await AuthService.getToken();

  final response =
      await http.post(
    Uri.parse(
      "${ApiService.baseUrl}/api/goals/$id/contribution",
    ),
    headers: {
      "Content-Type":
          "application/json",
      "Authorization":
          "Bearer $token",
    },
    body: jsonEncode({
      "amount": contribution,
    }),
  );

  final data =
      jsonDecode(response.body);

  return data["success"] == true;
}
}
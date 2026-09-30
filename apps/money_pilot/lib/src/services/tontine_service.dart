import 'dart:convert';

import 'package:http/http.dart'
    as http;

import 'api_service.dart';
import 'auth_service.dart';

class TontineService {

  static Future<List<dynamic>>
      getTontines() async {

    final token =
        await AuthService.getToken();

    final response =
        await http.get(

      Uri.parse(
        "${ApiService.baseUrl}/api/tontines",
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
    final data =
        jsonDecode(response.body);

    return data["tontines"] ?? [];

  }

  static Future<bool>
      createTontine({

    required String name,

    required int contribution,

    required int members,

  }) async {

    final token =
        await AuthService.getToken();

    final response =
        await http.post(

      Uri.parse(
        "${ApiService.baseUrl}/api/tontines",
      ),

      headers: {

        "Content-Type":
            "application/json",

        "Authorization":
            "Bearer $token",

      },

      body: jsonEncode({

        "name": name,
        "contribution":
            contribution,
        "members": members,

      }),

    );

    final data =
        jsonDecode(response.body);

    return data["success"] == true;

  }


static Future<bool> updateTontine({
  required int id,
  required String name,
  required int contribution,
  required int members,
}) async {

  final token =
      await AuthService.getToken();

  final response =
      await http.put(
    Uri.parse(
      "${ApiService.baseUrl}/api/tontines/$id",
    ),
    headers: {
      "Content-Type":
          "application/json",
      "Authorization":
          "Bearer $token",
    },
    body: jsonEncode({
      "name": name,
      "contribution": contribution,
      "members": members,
    }),
  );

  final data =
      jsonDecode(response.body);

  return data["success"] == true;
}
}
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'language_service.dart';
import 'currency_service.dart';
import 'api_service.dart';

class AuthService {

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {

    final response = await http.post(

      Uri.parse(
        "${ApiService.baseUrl}/api/auth/login",
      ),

      headers: {
        "Content-Type": "application/json",
      },

      body: jsonEncode({

        "email": email,
        "password": password,

      }),
    );

    print("LOGIN STATUS:");
    print(response.statusCode);

    print("LOGIN BODY:");
    print(response.body);


    final data =
        jsonDecode(response.body);
if (data["success"] == true &&
    data["user"] != null) {

  await LanguageService.saveLanguage(
    data["user"]["language"] ??
        "Français",
  );

  CurrencyService.setCurrency(
    data["user"]["currency"] ??
        "FCFA",
  );
}
    if (response.statusCode == 200) {

      if (data["token"] != null) {

        print("TOKEN RECU:");
        print(data["token"]);

        await saveToken(
          data["token"],
        );

      } else {

        print(
          "AUCUN TOKEN DANS LA REPONSE",
        );

      }
    }

    return data;
  }

  static Future<Map<String, dynamic>>
      register({

    required String fullName,
    required String email,
    required String password,

  }) async {

    final response =
        await http.post(

      Uri.parse(
        "${ApiService.baseUrl}/api/auth/register",
      ),

      headers: {
        "Content-Type":
            "application/json",
      },

      body: jsonEncode({

        "full_name": fullName,
        "email": email,
        "password": password,

      }),
    );

    return jsonDecode(
      response.body,
    );
  }

  static Future<void> saveToken(
    String token,
  ) async {

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      "token",
      token,
    );

    print("TOKEN SAUVEGARDE:");
    print(
      prefs.getString(
        "token",
      ),
    );
  }

  static Future<String?> getToken()
      async {

    final prefs =
        await SharedPreferences.getInstance();

    final token =
        prefs.getString(
          "token",
        );

    print("TOKEN RECUPERE:");
    print(token);

    return token;
  }

  static Future<void> logout()
      async {

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.remove(
      "token",
    );
  }

  static Future<bool> isLoggedIn()
      async {

    final token =
        await getToken();

    return token != null &&
        token.isNotEmpty;
  }

  static Future<Map<String, dynamic>>
      getProfile() async {

    final token =
        await getToken();

    final response =
        await http.get(

      Uri.parse(
        "${ApiService.baseUrl}/api/auth/me",
      ),

      headers: {

        "Authorization":
            "Bearer $token",

      },
    );

    return jsonDecode(
      response.body,
    );
  }

static Future<Map<String, dynamic>>
forgotPassword(
  String email,
) async {

  final response = await http.post(

    Uri.parse(
     "${ApiService.baseUrl}/api/auth/forgot-password",
    ),

    headers: {
      "Content-Type":
          "application/json",
    },

    body: jsonEncode({
      "email": email,
    }),

  );

  return jsonDecode(
    response.body,
  );
}

static Future<Map<String, dynamic>>
verifyResetCode({
  required String email,
  required String code,
}) async {

  final response = await http.post(

    Uri.parse(
      "${ApiService.baseUrl}/api/auth/verify-reset-code",
    ),

    headers: {
      "Content-Type":
          "application/json",
    },

    body: jsonEncode({

      "email": email,

      "code": code,

    }),

  );

  return jsonDecode(
    response.body,
  );
}

static Future<Map<String, dynamic>>
resetPassword({

  required String email,

  required String code,

  required String password,

}) async {

  final response = await http.post(

    Uri.parse(
     "${ApiService.baseUrl}/api/auth/reset-password",
    ),

    headers: {
      "Content-Type":
          "application/json",
    },

    body: jsonEncode({

      "email": email,

      "code": code,

      "password": password,

    }),

  );

  return jsonDecode(
    response.body,
  );
}
}
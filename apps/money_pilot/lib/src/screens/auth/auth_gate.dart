import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../dashboard/dashboard_screen.dart';
import 'auth_landing_screen.dart';
import '../../services/language_service.dart';

class AuthGate extends StatelessWidget {

  const AuthGate({
    super.key,
  });

  Future<Widget> _getScreen() async {

  final token =
      await AuthService.getToken();

  final language =
      await LanguageService.loadLanguage() ??
      "Français";

  if (token != null &&
      token.isNotEmpty) {

    return const DashboardScreen();

  }

  return AuthLandingScreen(
    language: language,
  );
}

  @override
  Widget build(
    BuildContext context,
  ) {

    return FutureBuilder<Widget>(

      future: _getScreen(),

      builder:
          (context, snapshot) {

        if (!snapshot.hasData) {

          return const Scaffold(
            body: Center(
              child:
                  CircularProgressIndicator(),
            ),
          );
        }

        return snapshot.data!;
      },
    );
  }
}
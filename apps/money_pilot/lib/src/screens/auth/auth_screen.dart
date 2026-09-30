import 'package:flutter/material.dart';

import '../dashboard/dashboard_screen.dart';

class AuthScreen extends StatelessWidget {

  final String language;

  const AuthScreen({
    super.key,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {

    final bool isFrench =
        language == "Français";

    return Scaffold(

      body: Padding(

        padding: const EdgeInsets.all(24),

        child: Column(

          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [

            Text(

              isFrench
                  ? "Bienvenue"
                  : "Welcome",

              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),

            ),

            const SizedBox(height: 15),

            Text(

              isFrench
                  ? "Connectez-vous pour continuer"
                  : "Sign in to continue",

              textAlign: TextAlign.center,

            ),

            const SizedBox(height: 30),

            SizedBox(

              width: double.infinity,

              child: ElevatedButton(

                onPressed: () {},

                child: Text(

                  isFrench
                      ? "Se connecter"
                      : "Sign In",

                ),

              ),

            ),

            const SizedBox(height: 10),

            SizedBox(

              width: double.infinity,

              child: OutlinedButton(

                onPressed: () {},

                child: Text(

                  isFrench
                      ? "Créer un compte"
                      : "Create Account",

                ),

              ),

            ),

            const SizedBox(height: 20),

            TextButton(

              onPressed: () {

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const DashboardScreen(),
                  ),
                );

              },

              child: Text(

                isFrench
                    ? "Continuer comme invité"
                    : "Continue as Guest",

              ),

            ),

          ],

        ),

      ),

    );

  }

}

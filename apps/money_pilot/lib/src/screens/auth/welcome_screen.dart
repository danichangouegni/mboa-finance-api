import 'package:flutter/material.dart';
import '../../services/language_service.dart';
import '../dashboard/dashboard_screen.dart';
import 'auth_screen.dart';
import 'auth_landing_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() =>
      _WelcomeScreenState();
}

class _WelcomeScreenState
    extends State<WelcomeScreen> {

  String selectedLanguage = "Français";

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Container(

        width: double.infinity,

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF005B35),
              Color(0xFF00894A),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: SafeArea(

          child: Padding(

            padding: const EdgeInsets.all(24),

            child: Column(

              children: [

                const Spacer(),

                const Icon(
                  Icons.account_balance_wallet,
                  size: 90,
                  color: Colors.white,
                ),

                const SizedBox(height: 20),

                const Text(
                  "Mboa Finance",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                const Text(
                  "Maîtrisez votre argent\nConstruisez votre avenir",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 40),

                const Text(
                  "Sélectionnez votre langue",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                Container(

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(12),
                  ),

                  child: RadioListTile<String>(

                    title: const Text(
                      "🇫🇷 Français",
                    ),

                    value: "Français",

                    groupValue:
                        selectedLanguage,

                    onChanged: (value) {

                      setState(() {

                        selectedLanguage =
                            value!;

                      });

                    },

                  ),

                ),

                const SizedBox(height: 10),

                Container(

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(12),
                  ),

                  child: RadioListTile<String>(

                    title: const Text(
                      "🇬🇧 English",
                    ),

                    value: "English",

                    groupValue:
                        selectedLanguage,

                    onChanged: (value) {

                      setState(() {

                        selectedLanguage =
                            value!;

                      });

                    },

                  ),

                ),

                const Spacer(),

                SizedBox(

                  width: double.infinity,

                  child: FilledButton(

            onPressed: () async {

  await LanguageService
      .saveLanguage(
    selectedLanguage,
  );

  if (!context.mounted) {
    return;
  }

  Navigator.pushReplacement(

    context,

    MaterialPageRoute(

      builder: (_) =>
          AuthLandingScreen(
        language:
            selectedLanguage,
      ),

    ),

  );

},


                    child: const Text(
                      "Continuer",
                    ),

                  ),

                ),

                const SizedBox(height: 30),

              ],

            ),

          ),

        ),

      ),

    );

  }
}
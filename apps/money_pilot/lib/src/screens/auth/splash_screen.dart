import 'package:flutter/material.dart';
import '../../services/language_service.dart';
import '../dashboard/dashboard_screen.dart';
import '../../core/app_colors.dart';
import 'welcome_screen.dart';
import '../../services/auth_service.dart';
import 'auth_landing_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
void initState() {
  super.initState();

  _initialize();
}

Future<void> _initialize() async {

  await Future.delayed(
    const Duration(seconds: 2),
  );

  final language =
      await LanguageService
          .loadLanguage();

  final token =
      await AuthService.getToken();

  if (!mounted) return;

  if (language == null) {

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const WelcomeScreen(),
      ),
    );

    return;
  }

  if (token == null ||
      token.isEmpty) {

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            AuthLandingScreen(
              language: language,
            ),
      ),
    );

    return;
  }

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) =>
          const DashboardScreen(),
    ),
  );
}



 @override
Widget build(BuildContext context) {

  return Scaffold(

    backgroundColor: Colors.white,

    body: Center(

      child: Column(

        mainAxisAlignment:
            MainAxisAlignment.center,

        children: [

          Container(

            padding:
                const EdgeInsets.all(20),

            decoration: BoxDecoration(

              color: AppColors.primary,

              borderRadius:
                  BorderRadius.circular(20),

              boxShadow: const [

                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),

              ],

            ),

            child: const Icon(
              Icons.account_balance_wallet,
              color: Colors.white,
              size: 60,
            ),

          ),

          const SizedBox(height: 30),

          const Text(

            "Mboa Finance",

            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),

          ),

          const SizedBox(height: 20),

          const Text(

            "Maîtrisez votre argent",

            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),

          ),

          const SizedBox(height: 5),

          const Text(

            "Construisez votre avenir",

            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),

          ),

          const SizedBox(height: 40),

          const SizedBox(

            width: 40,
            height: 40,

            child:
                CircularProgressIndicator(),

          ),

        ],

      ),

    ),

  );
}

}
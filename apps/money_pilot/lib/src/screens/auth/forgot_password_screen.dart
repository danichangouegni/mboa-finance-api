import 'package:flutter/material.dart';

import '../../core/app_texts.dart';
import '../../services/auth_service.dart';
import '../../services/language_service.dart';

import 'verify_reset_code_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends State<ForgotPasswordScreen> {

  final _emailController =
      TextEditingController();

  String language = "Français";

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {

    final savedLanguage =
        await LanguageService.loadLanguage();

    if (!mounted) return;

    setState(() {

      language =
          savedLanguage ?? "Français";

    });
  }

  Future<void> _sendCode() async {

    if (_emailController.text.trim().isEmpty) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
final email =
    _emailController.text.trim();

if (email.isEmpty) {

  ScaffoldMessenger.of(context)
      .showSnackBar(

    SnackBar(
      content: Text(
        language == "Français"
            ? "Veuillez saisir une adresse email."
            : "Please enter an email address.",
      ),
    ),

  );

  setState(() {
  _isLoading = false;
});
return;
}
final emailRegex =
    RegExp(
      r'^[^@]+@[^@]+\.[^@]+',
    );

if (!emailRegex.hasMatch(email)) {

  ScaffoldMessenger.of(context)
      .showSnackBar(

    SnackBar(
      content: Text(
        language == "Français"
            ? "Adresse email invalide."
            : "Invalid email address.",
      ),
    ),

  );

  setState(() {
  _isLoading = false;
});
return;
}
      final response =
          await AuthService.forgotPassword(
        _emailController.text.trim(),
      );

      if (!mounted) return;

      if (response["success"] == true) {

        ScaffoldMessenger.of(context)
            .showSnackBar(

          SnackBar(
            content: Text(
              language == "Français"
                  ? "Code envoyé"
                  : "Code sent",
            ),
          ),

        );

        Navigator.push(

          context,

          MaterialPageRoute(

            builder: (_) =>
                VerifyResetCodeScreen(
              email:
                  _emailController.text
                      .trim(),
            ),

          ),

        );

      } else {

        ScaffoldMessenger.of(context)
            .showSnackBar(

          SnackBar(

            content: Text(
              response["message"] ??
                  "Erreur",
            ),

          ),

        );
      }
    } finally {

      if (mounted) {

        setState(() {
          _isLoading = false;
        });

      }

    }
  }

  @override
  Widget build(BuildContext context) {

    final isFrench =
        language == "Français";

    return Scaffold(

      appBar: AppBar(

        title: Text(

          isFrench
              ? "Mot de passe oublié"
              : "Forgot Password",

        ),
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(24),
        child: Column(

          children: [

            Text(

              isFrench
                  ? "Entrez votre adresse email pour recevoir un code de réinitialisation."
                  : "Enter your email address to receive a reset code.",

            ),

            const SizedBox(height: 20),

            TextField(

              controller:
                  _emailController,

              keyboardType:
                  TextInputType.emailAddress,

              decoration:
                  const InputDecoration(

                labelText: "Email",

                border:
                    OutlineInputBorder(),

              ),

            ),

            const SizedBox(height: 25),

            SizedBox(

              width: double.infinity,

              child: ElevatedButton(

                onPressed:
                    _isLoading
                        ? null
                        : _sendCode,

                child: _isLoading

                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2,
                          color:
                              Colors.white,
                        ),
                      )

                    : Text(

                        isFrench
                            ? "Envoyer le code"
                            : "Send Code",

                      ),

              ),

            ),

          ],
        ),
      ),
    );
  }
}
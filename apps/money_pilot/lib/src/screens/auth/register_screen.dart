import 'package:flutter/material.dart';

import '../../services/language_service.dart';
import '../dashboard/dashboard_screen.dart';
import '../../services/user_service.dart';
import '../../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  
  @override
  State<RegisterScreen> createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState
    extends State<RegisterScreen> {

       final nameController =
    TextEditingController();

final emailController =
    TextEditingController();

final passwordController =
    TextEditingController();
      final confirmPasswordController =
    TextEditingController();
    bool obscurePassword = true;

        String language = "Français";

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
@override
void dispose() {

  nameController.dispose();
  emailController.dispose();
  passwordController.dispose();
  confirmPasswordController.dispose();

  super.dispose();
}

  @override
  Widget build(BuildContext context) {

    final isFrench =
        language == "Français";

    return Scaffold(

      appBar: AppBar(

        title: Text(

          isFrench
              ? "Créer un compte"
              : "Create Account",

        ),

      ),

      body: SingleChildScrollView(
  child: Padding(
    padding: const EdgeInsets.all(24),
    child: Column(
      children: [

            const SizedBox(height: 20),

            TextField(
            controller:
                nameController,

              decoration:
                  InputDecoration(

                labelText:
                    isFrench
                        ? "Nom complet"
                        : "Full Name",

                border:
                    const OutlineInputBorder(),

              ),

            ),

            const SizedBox(height: 20),

            TextField(
            controller:
                emailController,

              decoration:
                  InputDecoration(

                labelText:
                    "Email",

                border:
                    const OutlineInputBorder(),

              ),

            ),

            const SizedBox(height: 20),

            TextField(
  controller: passwordController,
  obscureText: obscurePassword,
  decoration: InputDecoration(
    labelText:
        isFrench
            ? "Mot de passe"
            : "Password",
    border:
        const OutlineInputBorder(),
    suffixIcon: IconButton(
      icon: Icon(
        obscurePassword
            ? Icons.visibility
            : Icons.visibility_off,
      ),
      onPressed: () {
        setState(() {
          obscurePassword =
              !obscurePassword;
        });
      },
    ),
  ),
),
const SizedBox(height: 20),

TextField(
  controller:
      confirmPasswordController,
  obscureText: obscurePassword,
  decoration: InputDecoration(
    labelText:
        isFrench
            ? "Confirmer le mot de passe"
            : "Confirm Password",
    border:
        const OutlineInputBorder(),
  ),
),

            const SizedBox(height: 30),

            SizedBox(

              width: double.infinity,

              child: ElevatedButton(

             onPressed: () async {
final password =
    passwordController.text;

final regex = RegExp(
  r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$',
);

if (!regex.hasMatch(password)) {

  ScaffoldMessenger.of(context)
      .showSnackBar(

    SnackBar(
      content: Text(
        isFrench
            ? "Le mot de passe doit contenir au moins 8 caractères, dont au moins une majuscule, un chiffre et un caractère spécial."
            : "The password must contain at least 8 characters, including at least one uppercase letter, one number, and one special character.",
      ),
    ),

  );

  return;
}
if (
  passwordController.text !=
  confirmPasswordController.text
) {

  ScaffoldMessenger.of(context)
      .showSnackBar(

    SnackBar(
      content: Text(
        isFrench
            ? "Les mots de passe ne correspondent pas."
            : "Passwords do not match.",
      ),
    ),

  );

  return;
}
  final response =
      await AuthService.register(

    fullName:
        nameController.text.trim(),

    email:
        emailController.text.trim(),

    password:
        passwordController.text,

  );

  if (!context.mounted) return;

  if (response["success"] == true) {

  final loginResponse =
      await AuthService.login(

    email:
        emailController.text.trim(),

    password:
        passwordController.text,

  );

  if (loginResponse["success"] == true) {

    await AuthService.saveToken(

      loginResponse["token"],

    );

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(

      context,

      MaterialPageRoute(
        builder: (_) =>
            const DashboardScreen(),
      ),

      (route) => false,

    );

  }

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

},

                child: Text(

                  isFrench
                      ? "Créer un compte"
                      : "Create Account",

                ),

              ),

            ),

                    ],
        ),
      ),
    ),
  );
}

 

}
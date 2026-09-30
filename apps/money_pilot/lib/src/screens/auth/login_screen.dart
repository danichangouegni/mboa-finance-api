import 'package:flutter/material.dart';
import '../subscription/subscription_screen.dart';
import '../../services/auth_service.dart';
import '../../services/language_service.dart';
import '../dashboard/dashboard_screen.dart';
import '../../core/app_texts.dart';
import '../../utils/api_error_translator.dart';
import 'forgot_password_screen.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {
  String language = "Français";
bool obscurePassword = true;

  final _emailController =
      TextEditingController();

  final _passwordController =
      TextEditingController();

  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });
final texts = AppTexts(language);
    try {
      final response =
          await AuthService.login(
        email:
            _emailController.text.trim(),
        password:
            _passwordController.text,
      );

      if (
        response["paymentRequired"] ==
            true
      ) {

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                const SubscriptionScreen(),
          ),
        );

        return;
      }
      if (response["success"] == true) {
        await AuthService.saveToken(
          response["token"],
        );

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                const DashboardScreen(),
          ),
        );
      } else {
        if (!mounted) return;

        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(
              ApiErrorTranslator.translate(
                response["code"],
                texts,
              ) ??
                  "Erreur",
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
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
              ? "Connexion"
              : "Sign In",
        ),
      ),
      body: Padding(
        padding:
            const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 30),

            TextField(
              controller:
                  _emailController,
              decoration:
                  InputDecoration(
                labelText: "Email",
                border:
                    const OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

           TextField(
  controller:
      _passwordController,
  obscureText:
      obscurePassword,
  decoration:
      InputDecoration(
    labelText:
        isFrench
            ? "Mot de passe"
            : "Password",
    border:
        const OutlineInputBorder(),
    suffixIcon:
        IconButton(
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

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    _isLoading
                        ? null
                        : _login,
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
                            ? "Se connecter"
                            : "Sign In",
                      ),
              ),
            ),
            Align(
  alignment: Alignment.centerRight,
  child: TextButton(
    onPressed: () {

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              const ForgotPasswordScreen(),
        ),
      );

    },
    child: Text(
      isFrench
          ? "Mot de passe oublié ?"
          : "Forgot Password?",
    ),
  ),
),
          ],

        ),
        
      ),
      
    );
  }
}
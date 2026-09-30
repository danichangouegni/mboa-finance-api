import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../services/language_service.dart';
import 'login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String code;

  const ResetPasswordScreen({
    super.key,
    required this.email,
    required this.code,
  });

  @override
  State<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState
    extends State<ResetPasswordScreen> {
  String language = "Français";

  final _passwordController =
      TextEditingController();

  final _confirmController =
      TextEditingController();

  bool _isLoading = false;

  bool obscurePassword = true;
  bool obscureConfirm = true;

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

  Future<void> _resetPassword() async {
    if (_passwordController.text.isEmpty) {
      return;
    }

    if (_confirmController.text.isEmpty) {
      return;
    }

    if (_passwordController.text !=
        _confirmController.text) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            language == "Français"
                ? "Les mots de passe ne correspondent pas"
                : "Passwords do not match",
          ),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response =
          await AuthService.resetPassword(
        email: widget.email,
        code: widget.code,
        password:
            _passwordController.text,
      );

      if (!mounted) return;

      if (response["success"] == true) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(
              language == "Français"
                  ? "Mot de passe modifié avec succès"
                  : "Password updated successfully",
            ),
          ),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) =>
                const LoginScreen(),
          ),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(
              response["message"] ??
                  (language ==
                          "Français"
                      ? "Erreur"
                      : "Error"),
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
              ? "Nouveau mot de passe"
              : "New Password",
        ),
      ),
      body: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
          children: [
            TextField(
              controller:
                  _passwordController,
              obscureText:
                  obscurePassword,
              decoration: InputDecoration(
                labelText: isFrench
                    ? "Nouveau mot de passe"
                    : "New Password",
                border:
                    const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    obscurePassword
                        ? Icons.visibility
                        : Icons
                            .visibility_off,
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
                  _confirmController,
              obscureText:
                  obscureConfirm,
              decoration: InputDecoration(
                labelText: isFrench
                    ? "Confirmer le mot de passe"
                    : "Confirm Password",
                border:
                    const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    obscureConfirm
                        ? Icons.visibility
                        : Icons
                            .visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      obscureConfirm =
                          !obscureConfirm;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : _resetPassword,
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
                            ? "Modifier le mot de passe"
                            : "Reset Password",
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  
}
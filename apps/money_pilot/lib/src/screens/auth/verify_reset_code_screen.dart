import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import 'reset_password_screen.dart';

class VerifyResetCodeScreen extends StatefulWidget {

  final String email;

  const VerifyResetCodeScreen({
    super.key,
    required this.email,
  });

  @override
  State<VerifyResetCodeScreen> createState() =>
      _VerifyResetCodeScreenState();
}

class _VerifyResetCodeScreenState
    extends State<VerifyResetCodeScreen> {

  final codeController =
      TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {

    codeController.dispose();

    super.dispose();
  }

  Future<void> _verifyCode() async {

    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {

      final response =
          await AuthService.verifyResetCode(
        email: widget.email,
        code: codeController.text.trim(),
      );

      if (!mounted) return;

      if (response["success"] == true) {

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                ResetPasswordScreen(
              email: widget.email,
              code: codeController.text.trim(),
            ),
          ),
        );

      } else {

        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(
              response["message"] ??
                  "Code invalide",
            ),
          ),
        );

      }

    } catch (e) {

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
          isLoading = false;
        });

      }

    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Vérification",
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(

          children: [

            const SizedBox(
              height: 20,
            ),

            Text(
              "Entrez le code reçu pour ${widget.email}",
              textAlign: TextAlign.center,
            ),

            const SizedBox(
              height: 24,
            ),

            TextField(

              controller:
                  codeController,

              keyboardType:
                  TextInputType.number,

              decoration:
                  const InputDecoration(

                labelText:
                    "Code de vérification",

                border:
                    OutlineInputBorder(),

              ),
            ),

            const SizedBox(
              height: 24,
            ),

            SizedBox(

              width: double.infinity,

              child: ElevatedButton(

                onPressed:
                    isLoading
                        ? null
                        : _verifyCode,

                child:
                    isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child:
                                CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            "Vérifier",
                          ),

              ),
            ),

          ],
        ),
        ),
      
    );
  }
}
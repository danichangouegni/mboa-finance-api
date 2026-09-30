import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class AuthLandingScreen extends StatelessWidget {

  final String language;

  const AuthLandingScreen({
    super.key,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {

    final bool isFrench =
        language == "Français";

    return Scaffold(

      body: Stack(

        children: [

          Positioned.fill(

            child: Image.asset(
              "assets/images/auth_background.jpg",
              fit: BoxFit.cover,
            ),

          ),

          Positioned.fill(

            child: Container(

              decoration: BoxDecoration(

                gradient: LinearGradient(

                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,

                  colors: [

                    Colors.green.shade900
                        .withOpacity(0.95),

                    Colors.green.shade700
                        .withOpacity(0.65),

                  ],

                ),

              ),

            ),

          ),
SafeArea(
  child: SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight:
              MediaQuery.of(context)
                  .size
                  .height -
              48,
        ),
        child: IntrinsicHeight(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [

                  const SizedBox(
                    height: 20,
                  ),

                  Container(

                    padding:
                        const EdgeInsets.all(
                      12,
                    ),

                    decoration:
                        BoxDecoration(

                      color: Colors.white,

                      borderRadius:
                          BorderRadius.circular(
                        20,
                      ),

                    ),

                    child: const Icon(

                      Icons
                          .account_balance_wallet,

                      size: 50,

                      color: Color(
                        0xFF005B35,
                      ),

                    ),

                  ),

                  const Spacer(),

                  const Text(

                    "Mboa Finance",

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight:
                          FontWeight.bold,
                    ),

                  ),

                  const SizedBox(height: 10),

                  Text(

                    isFrench
                        ? "Votre assistant financier\nau quotidien"
                        : "Your financial assistant\nfor everyday life",

                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),

                  ),

                  const SizedBox(height: 40),

                  SizedBox(

                    width:
                        double.infinity,

                    child: ElevatedButton(

                     onPressed: () {

                        Navigator.push(

                          context,

                          MaterialPageRoute(
                            builder: (_) =>
                                const RegisterScreen(),
                          ),

                        );

                      },

                      style:
                          ElevatedButton.styleFrom(

                        backgroundColor:
                            Colors.greenAccent,

                        foregroundColor:
                            Colors.black,

                        minimumSize:
                            const Size(
                          double.infinity,
                          55,
                        ),

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            12,
                          ),
                        ),

                      ),

                      child: Text(

                        isFrench
                            ? "Créer un compte"
                            : "Create Account",

                      ),

                    ),

                  ),

                  const SizedBox(height: 15),

                  SizedBox(

                    width:
                        double.infinity,

                    child: OutlinedButton(

                      onPressed: () {

                        Navigator.push(

                          context,

                          MaterialPageRoute(
                            builder: (_) =>
                                const LoginScreen(),
                          ),

                        );

                      },


                      style:
                          OutlinedButton.styleFrom(

                        foregroundColor:
                            Colors.white,

                        side:
                            const BorderSide(
                          color: Colors.white,
                        ),

                        minimumSize:
                            const Size(
                          double.infinity,
                          55,
                        ),

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            12,
                          ),
                        ),

                      ),

                      child: Text(

                        isFrench
                            ? "Se connecter"
                            : "Sign In",

                      ),

                    ),

                  ),

                  const SizedBox(height: 20),

                  Center(

                    child: Text(

                      isFrench
                          ? "Sécurité. Simple. 100% pour vous."
                          : "Security. Simple. 100% for you.",

                      style: const TextStyle(
                        color: Colors.white70,
                      ),

                    ),

                  ),

                  const SizedBox(height: 20),

                ],
              ),
            ),
      ),
              ),

            ),

          ),

        ],

      ),

    );

  }

}

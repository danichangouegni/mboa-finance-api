import 'package:flutter/material.dart';
import '../src/services/payment_service.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [

              const SizedBox(height: 20),

              Container(
                width: double.infinity,

                padding: const EdgeInsets.all(24),

                decoration: BoxDecoration(
                  color: const Color(0xFF006C3D),

                  borderRadius:
                      BorderRadius.circular(28),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(
                        0.25,
                      ),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),

                child: const Column(
                  children: [

                    Icon(
                      Icons.workspace_premium,
                      size: 85,
                      color: Colors.amber,
                    ),

                    SizedBox(height: 16),

                    Text(
                      "MBOA Premium",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 12),

                    Text(
                      "Votre période d'essai gratuite est terminée.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),

                    SizedBox(height: 8),

                    Text(
                      "Passez à Premium pour continuer à gérer vos finances en toute sérénité.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Container(
                width: double.infinity,

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(20),
                ),

                child: const Padding(
                  padding: EdgeInsets.all(16),

                  child: Column(
                    children: [

                      ListTile(
                        leading: Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                        title: Text(
                          "Dépenses illimitées",
                        ),
                      ),

                      Divider(),

                      ListTile(
                        leading: Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                        title: Text(
                          "Statistiques avancées",
                        ),
                      ),

                      Divider(),

                      ListTile(
                        leading: Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                        title: Text(
                          "Sauvegarde Cloud",
                        ),
                      ),

                      Divider(),

                      ListTile(
                        leading: Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                        title: Text(
                          "Synchronisation multi-appareils",
                        ),
                      ),

                      Divider(),

                      ListTile(
                        leading: Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                        title: Text(
                          "Fonctionnalités intelligentes à venir",
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Container(
                width: double.infinity,

                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(20),
                ),

                child: const Column(
                  children: [

                    Text(
                      "Abonnement Premium",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 10),

                    Text(
                      "1850 FCFA",
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight:
                            FontWeight.bold,
                        color: Color(0xFF006C3D),
                      ),
                    ),

                    Text(
                      "par mois",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton.icon(

                onPressed: () async {
                  final ok =
                      await PaymentService.subscribe(
                    provider: "orange",
                  );

                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    SnackBar(
                      content: Text(
                        ok
                            ? "Paiement lancé"
                            : "Erreur paiement",
                      ),
                    ),
                  );
                },

                  icon: const Icon(
                    Icons.phone_android,
                  ),

                  label: const Text(
                    "Payer avec Orange Money",
                  ),

                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.orange,
                    foregroundColor:
                        Colors.white,

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        14,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton.icon(

                onPressed: () async {
                  final ok =
                      await PaymentService.subscribe(
                    provider: "mtn",
                  );

                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    SnackBar(
                      content: Text(
                        ok
                            ? "Paiement lancé"
                            : "Erreur paiement",
                      ),
                    ),
                  );
                },
                  icon: const Icon(
                    Icons.phone_android,
                  ),

                  label: const Text(
                    "Payer avec MTN MoMo",
                  ),

                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFFFFCC00),
                    foregroundColor:
                        Colors.black,

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        14,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              SizedBox(
                width: double.infinity,
                height: 55,

                child: OutlinedButton.icon(

                  onPressed: () {
                    // Carte bancaire
                  },

                  icon: const Icon(
                    Icons.credit_card,
                  ),

                  label: const Text(
                    "Payer par Carte Bancaire",
                  ),

                  style:
                      OutlinedButton.styleFrom(
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        14,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                "Paiement 100% sécurisé",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
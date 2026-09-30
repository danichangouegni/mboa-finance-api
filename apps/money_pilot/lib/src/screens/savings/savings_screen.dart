import 'package:flutter/material.dart';

import '../../utils/currency_formatter.dart';
import '../../services/savings_service.dart';
import '../../services/settings_service.dart';

class SavingsScreen extends StatefulWidget {
  const SavingsScreen({super.key});

  @override
  State<SavingsScreen> createState() =>
      _SavingsScreenState();
}

class _SavingsScreenState
    extends State<SavingsScreen> {

  final TextEditingController
      targetController =
      TextEditingController();

  double currentAmount = 0;
  double targetAmount = 0;
  String userCurrency = "FCFA";

  @override
  void initState() {
    super.initState();
    _loadSavings();
    _loadCurrency();
  }

Future<void> _loadCurrency() async {

  final currency =
      await SettingsService.getCurrency();

  if (!mounted) return;

  setState(() {

    userCurrency = currency;

  });
}

  Future<void> _loadSavings() async {

    try {

      final data =
          await SavingsService
              .getSavings();

      if (!mounted) return;

      setState(() {

        currentAmount =
            double.parse(
          data["current_amount"]
              .toString(),
        );

        targetAmount =
            double.parse(
          data["target_amount"]
              .toString(),
        );

      });

    } catch (e) {

      debugPrint(
        e.toString(),
      );

    }

  }

  @override
  void dispose() {
    targetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final progress =
        targetAmount == 0
            ? 0.0
            : (currentAmount /
                    targetAmount)
                .clamp(0.0, 1.0);

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Objectif d'épargne",
        ),
      ),

      body: Padding(

        padding:
            const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            const Text(
              "Progression",
              style: TextStyle(
                fontSize: 20,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            LinearProgressIndicator(
              value: progress,
              minHeight: 15,
            ),

            const SizedBox(
              height: 10,
            ),

            Text(
              "${(progress * 100).toInt()} %",
            ),

            const SizedBox(
              height: 30,
            ),

            Text(
              "Actuel : ${CurrencyFormatter.format(currentAmount.toInt())} ${userCurrency}",
            ),

            const SizedBox(
              height: 10,
            ),

            Text(
              "Objectif : ${CurrencyFormatter.format(targetAmount.toInt())} ${userCurrency}",
            ),

            const SizedBox(
              height: 20,
            ),

            ElevatedButton(

              onPressed: () async {

                final controller =
                    TextEditingController();

                final result =
                    await showDialog<String>(

                  context: context,

                  builder: (context) {

                    return AlertDialog(

                      title: const Text(
                        "Nouvel objectif",
                      ),

                      content: TextField(
                        controller:
                            controller,
                        keyboardType:
                            TextInputType.number,
                      ),

                      actions: [

                        TextButton(

                          onPressed: () {
                            Navigator.pop(
                              context,
                            );
                          },

                          child: const Text(
                            "Annuler",
                          ),

                        ),

                        ElevatedButton(

                          onPressed: () {
                            Navigator.pop(
                              context,
                              controller.text,
                            );
                          },

                          child: const Text(
                            "Enregistrer",
                          ),

                        ),

                      ],

                    );

                  },

                );

                if (result == null ||
                    result.isEmpty) {
                  return;
                }

                final target =
                    double.tryParse(
                  result,
                );

                if (target == null) {
                  return;
                }

                await SavingsService
                    .saveSavings(

                  currentAmount:
                      currentAmount,

                  targetAmount:
                      target,

                );

                await _loadSavings();

              },

              child: const Text(
                "Définir l'objectif",
              ),

            ),

            const SizedBox(
              height: 30,
            ),

            TextField(

              controller:
                  targetController,

              keyboardType:
                  TextInputType.number,

              decoration:
                  const InputDecoration(

                labelText:
                    "Ajouter à l'épargne",

                border:
                    OutlineInputBorder(),

              ),

            ),

            const SizedBox(
              height: 20,
            ),

            SizedBox(

              width: double.infinity,

              child: ElevatedButton(

                onPressed: () async {

                  if (targetController.text
                      .trim()
                      .isEmpty) {

                    return;

                  }

                  final amount =
                      double.tryParse(
                    targetController.text,
                  );

                  if (amount == null) {
                    return;
                  }

                  final newAmount =
                      currentAmount + amount;

                  final saved =
                      await SavingsService
                          .saveSavings(

                    currentAmount:
                        newAmount,

                    targetAmount:
                        targetAmount,

                  );

                  if (!saved) {

                    if (!context.mounted) {
                      return;
                    }

                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(

                      const SnackBar(
                        content: Text(
                          "Erreur d'enregistrement",
                        ),
                      ),

                    );

                    return;

                  }

                  targetController.clear();

                  await _loadSavings();

                },

                child: const Text(
                  "Ajouter",
                ),

              ),

            ),

          ],

        ),

      ),

    );

  }

}
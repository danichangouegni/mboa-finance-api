import 'package:flutter/material.dart';

import '../../data/finance_data.dart';
import '../../models/transaction_model.dart';
import '../../services/transaction_service.dart';

class AddIncomeScreen extends StatefulWidget {
  const AddIncomeScreen({super.key});

  @override
  State<AddIncomeScreen> createState() => _AddIncomeScreenState();
}

class _AddIncomeScreenState extends State<AddIncomeScreen> {
  final amountController = TextEditingController();
  final sourceController = TextEditingController();
  final noteController =   TextEditingController();
  bool _isSaving = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nouveau revenu"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: noteController,
              decoration: const InputDecoration(
                labelText: "Note",
                border: OutlineInputBorder(),
              ),
            ),


            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Montant",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: sourceController,
              decoration: const InputDecoration(
                labelText: "Source",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(

                      style: ElevatedButton.styleFrom(

                        backgroundColor:
                            const Color(0xFF006C3D),

                        foregroundColor:
                            Colors.white,

                      ),
           onPressed: _isSaving
    ? null
    : () async {

        if (_isSaving) return;

        if (amountController.text.isEmpty ||
            sourceController.text.isEmpty) {
          return;
        }

        setState(() {
          _isSaving = true;
        });

        try {

          final response =
              await TransactionService
                  .createTransaction(

            title:
                sourceController.text,

            amount: double.parse(
              amountController.text,
            ),

            transactionType:
                "income",

            transactionDate:
                DateTime.now()
                    .toIso8601String()
                    .split("T")
                    .first,

            notes:
                noteController.text,

          );

          if (response["success"] != true) {

            if (!context.mounted) return;

            ScaffoldMessenger.of(context)
                .showSnackBar(

              const SnackBar(
                content: Text(
                  "Erreur lors de l'enregistrement",
                ),
              ),

            );

            return;
          }

          if (mounted) {
            Navigator.pop(context);
          }

        } finally {

          if (mounted) {

            setState(() {
              _isSaving = false;
            });

          }

        }
      },

child: _isSaving
    ? const SizedBox(
        width: 20,
        height: 20,
        child:
            CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.white,
        ),
      )
    : const Text(
        "Enregistrer",
      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

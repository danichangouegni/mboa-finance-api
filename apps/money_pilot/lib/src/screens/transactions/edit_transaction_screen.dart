import 'package:flutter/material.dart';

import '../../services/transaction_service.dart';

class EditTransactionScreen extends StatefulWidget {

 final Map<String, dynamic> transaction;


  const EditTransactionScreen({
    super.key,
    required this.transaction,
  });

  @override
  State<EditTransactionScreen> createState() =>
      _EditTransactionScreenState();
}

class _EditTransactionScreenState
    extends State<EditTransactionScreen> {

  late TextEditingController titleController;

  late TextEditingController descriptionController;

  late TextEditingController amountController;
  late String transactionDate;

  @override
void initState() {
  super.initState();

  titleController =
      TextEditingController(
    text: widget.transaction["title"],
  );

  descriptionController =
      TextEditingController(
    text:
        widget.transaction["notes"] ?? "",
  );

  amountController =
      TextEditingController(
    text:
        widget.transaction["amount"]
            .toString(),
  );

  transactionDate =
    widget.transaction["transaction_date"]
        .toString()
        .substring(0, 10);
}

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Modifier",
        ),
      ),

      body: Padding(

        padding:
            const EdgeInsets.all(16),

        child: Column(

          children: [

            TextField(
              controller: titleController,
              decoration:
                  const InputDecoration(
                labelText: "Titre",
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller:
                  descriptionController,
              decoration:
                  const InputDecoration(
                labelText: "Description",
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: amountController,
              keyboardType:
                  TextInputType.number,
              decoration:
                  const InputDecoration(
                labelText: "Montant",
              ),
            ),

            const SizedBox(height: 24),

ElevatedButton(

  style: ElevatedButton.styleFrom(

    backgroundColor:
        const Color(0xFF006C3D),

    foregroundColor:
        Colors.white,

  ),

   onPressed: () async {

  final updated =
      await TransactionService
          .updateTransaction(

    id:
        widget.transaction["id"],

    title:
        titleController.text,

   amount: double.tryParse(
      amountController.text,
    ) ??
    0,

    transactionType:
        widget.transaction[
            "transaction_type"],

  transactionDate: transactionDate,

    notes:
        descriptionController.text,

  );

  if (!context.mounted) {
    return;
  }

  if (!updated) {

    ScaffoldMessenger.of(context)
        .showSnackBar(

      const SnackBar(
        content: Text(
          "Erreur de modification",
        ),
      ),

    );

    return;

  }

  Navigator.pop(
    context,
    true,
  );

},
child: const Text(
    "Enregistrer",
 ),

            ),

          ],

        ),

      ),

    );

  }

}
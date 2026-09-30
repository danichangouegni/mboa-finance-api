import 'package:flutter/material.dart';

import '../../data/finance_data.dart';
import '../../models/transaction_model.dart';
import '../../core/app_texts.dart';
import '../../services/language_service.dart';
import '../../services/transaction_service.dart';
import '../../utils/category_suggestions.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _amountController = TextEditingController();
  final _categoryController = TextEditingController();
  final _noteController = TextEditingController();
  bool _isSaving = false;
  String paymentMethod = "Orange Money";
  DateTime selectedDate = DateTime.now();
  String language = "Français";

@override
void initState() {
  super.initState();
  _loadLanguage();
}

String translateCategory(
  String category,
) {

  if (language == "Français") {

    switch(category) {

      case "food":
        return "Alimentation";

      case "health":
        return "Santé";

      case "housing":
        return "Logement";

      case "education":
        return "Éducation";

      case "leisure":
        return "Loisirs";

      case "savings":
        return "Épargne";

      case "investment":
        return "Investissement";
      
      case "transport":
        return "Transport";

      case "communication":
        return "Communication";

      default:
        return "Transport";
    }
  }

  return category;
}

Future<void> _loadLanguage() async {

  final savedLanguage =
      await LanguageService.loadLanguage();

  if (!mounted) return;

  setState(() {

    language =
        savedLanguage ??
        "Français";

  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nouvelle dépense"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Montant",
                hintText: "Ex : 25000",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

Autocomplete<String>(
  optionsBuilder: (
    TextEditingValue textEditingValue,
  ) {

    if (textEditingValue.text.isEmpty) {
     return categories.map(
  translateCategory,
);
    }
return categories.where(
  (category) =>
      translateCategory(category)
          .toLowerCase()
          .contains(
            textEditingValue.text
                .toLowerCase(),
          ),
);
  },

 onSelected: (String selection) {

  final selectedCategory =
      categories.firstWhere(
    (category) =>
        translateCategory(
          category,
        ) ==
        selection,
    orElse: () => selection,
  );

  _categoryController.text =
      selectedCategory;
},

fieldViewBuilder: (
  context,
  controller,
  focusNode,
  onFieldSubmitted,
) {

  _categoryController.text =
      controller.text;

  return TextField(
    controller: controller,
    focusNode: focusNode,

    onChanged: (value) {
      _categoryController.text = value;
    },

      decoration: InputDecoration(
        labelText:
            language == "Français"
                ? "Catégorie"
                : "Category",

        hintText:
            language == "Français"
                ? "Transport"
                : "Transport",

        border:
            const OutlineInputBorder(),
      ),
    );
  },
),
            const SizedBox(height: 20),

          DropdownButtonFormField<String>(

  value: paymentMethod,

  decoration: const InputDecoration(

    labelText: "Moyen de paiement",

    border: OutlineInputBorder(),

  ),

  items: const [

    DropdownMenuItem(
      value: "Orange Money",
      child: Text("Orange Money"),
    ),

    DropdownMenuItem(
      value: "MTN Mobile Money",
      child: Text("MTN Mobile Money"),
    ),

    DropdownMenuItem(
      value: "Cash",
      child: Text("Cash"),
    ),

    DropdownMenuItem(
      value: "Carte bancaire",
      child: Text("Carte bancaire"),
    ),

    DropdownMenuItem(
      value: "Virement",
      child: Text("Virement"),
    ),

  ],

  onChanged: (value) {

    if (value == null) return;

    setState(() {

      paymentMethod = value;

    });

  },

),
const SizedBox(height: 20),

InkWell(

  onTap: () async {

    final pickedDate =
        await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) {
      return;
    }

    setState(() {

      selectedDate =
          pickedDate;

    });

  },

  child: InputDecorator(

    decoration:
        const InputDecoration(

      labelText: "Date",

      border:
          OutlineInputBorder(),

    ),

    child: Row(

      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,

      children: [

        Text(

          "${selectedDate.day}/"
          "${selectedDate.month}/"
          "${selectedDate.year}",

        ),

        const Icon(
          Icons.calendar_today,
        ),

      ],

    ),

  ),

),

            const SizedBox(height: 20),

            TextField(
              controller: _noteController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Note",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(

                    style: ElevatedButton.styleFrom(

                      backgroundColor:
                          const Color(0xFF006C3D),

                      foregroundColor:
                          Colors.white,

                    ),
onPressed: _isSaving ? null
    : () async {
    if (_amountController.text.isEmpty) {
               return;
    }
    if (_categoryController.text.isEmpty) {
            return;
    }
    setState(() { _isSaving = true;});

try {
    final response =
        await TransactionService
            .createTransaction(

     title: _categoryController.text,

      amount: double.parse(
        _amountController.text,
      ),

      transactionType:
          "expense",

      transactionDate:
          "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}",

      notes:
          _noteController.text,

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
    Navigator.pop(
      context,
      true,
    );
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
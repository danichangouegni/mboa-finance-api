import 'package:flutter/material.dart';

import '../../data/finance_data.dart';
import '../../models/transaction_model.dart';
import '../../core/app_texts.dart';
import '../../services/language_service.dart';
import 'edit_transaction_screen.dart';
import '../../utils/currency_formatter.dart';
import '../../services/transaction_service.dart';
import '../../services/settings_service.dart';
import '../../utils/currency_helper.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() =>
      _TransactionsScreenState();
}

class _TransactionsScreenState
    extends State<TransactionsScreen> {

  bool showExpenses = true;
  String language = "Français";
  List<dynamic> transactions = [];
  String selectedFilter = "Tout";
  String userCurrency = "FCFA";
@override
void initState() {
  super.initState();
  _loadLanguage();
  _loadTransactions();
  _loadCurrency();
}

@override
void didChangeDependencies() {
  super.didChangeDependencies();
  _loadTransactions();
}

Future<void> _loadCurrency() async {

  final currency =
      await SettingsService.getCurrency();

  if (!mounted) return;

  setState(() {

    userCurrency = currency;

  });
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

String displayCategory(String category) {

  switch (category.toLowerCase()) {

    case "transport":
      return "Transport";

    case "food":
      return "Alimentation";

    case "housing":
      return "Logement";

    case "health":
      return "Santé";

    case "communication":
      return "Communication";

    case "education":
      return "Éducation";

    case "leisure":
      return "Loisirs";

    case "savings":
      return "Épargne";

    case "investment":
      return "Investissement";

    default:
      return category;
  }
}

  Future<void> _loadTransactions() async {

  try {

    final data =
        await TransactionService
            .getTransactions();

    if (!mounted) return;

    setState(() {

      transactions = data;

    });

  } catch (e) {

    debugPrint(
      e.toString(),
    );

  }

}

  String getDateLabel(
  DateTime date,
  AppTexts texts,
){

 final now = DateTime.now().toLocal();

  final yesterday =
      now.subtract(
    const Duration(days: 1),
  );

  if (
      date.day == now.day &&
      date.month == now.month &&
      date.year == now.year) {

    return texts.today;
  }

  if (
      date.day == yesterday.day &&
      date.month == yesterday.month &&
      date.year == yesterday.year) {

    return texts.yesterday;
  }

  return
      "${date.day}/${date.month}/${date.year}";
}
  
  @override
  Widget build(BuildContext context) {
  final texts = AppTexts(language);

List<dynamic> filteredTransactions =
    transactions.where((transaction) {

  if (showExpenses) {
    return transaction["transaction_type"] ==
        "expense";
  }

  return transaction["transaction_type"] ==
      "income";

}).toList();

if (selectedFilter == "Aujourd'hui") {

  final today = DateTime.now();

  filteredTransactions =
      filteredTransactions.where((t) {

    final date = DateTime.parse(
      t["transaction_date"],
    ).toLocal();

    return date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;

  }).toList();

}
if (selectedFilter == "Mois") {

  final today = DateTime.now();

  filteredTransactions =
      filteredTransactions.where((t) {

    final date = DateTime.parse(
      t["transaction_date"],
    ).toLocal();

    return date.month == today.month &&
        date.year == today.year;

  }).toList();

}
if (selectedFilter == "Année") {

  final today = DateTime.now();

  filteredTransactions =
      filteredTransactions.where((t) {

    final date = DateTime.parse(
      t["transaction_date"],
    ).toLocal();

    return date.year == today.year;

  }).toList();

}

filteredTransactions.sort(
  (a, b) {

    final dateA =
        DateTime.parse(
      a["transaction_date"],
    ).toLocal();

    final dateB =
        DateTime.parse(
      b["transaction_date"],
    ).toLocal();

    return dateB.compareTo(
      dateA,
    );

  },
);

    return Scaffold(

     appBar: AppBar(
        title: Text(
          texts.transactions,
        ),
      ),

      body: Column(

        children: [

          Padding(

            padding:
                const EdgeInsets.all(16),

            child: Row(

              children: [

                Expanded(
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(
     backgroundColor: showExpenses
    ? const Color(0xFF006C3D)
    : Colors.grey.shade300,
    ),
    onPressed: () {
      setState(() {
        showExpenses = true;
      });
    },
    child: Text(
     texts.expenses,
      style: TextStyle(
        color: showExpenses
            ? Colors.white
            : Colors.black,
      ),
    ),
  ),
),

                const SizedBox(width: 10),

                Expanded(
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: !showExpenses
    ? const Color(0xFF006C3D)
    : Colors.grey.shade300,

    ),
    onPressed: () {
      setState(() {
        showExpenses = false;
      });
    },
    child: Text(
      texts.income,
      style: TextStyle(
        color: !showExpenses
            ? Colors.white
            : Colors.black,
      ),
    ),
  ),
),

              ],

            ),

          ),
DropdownButton<String>(

  value: selectedFilter,

  items: const [

    DropdownMenuItem(
      value: "Tout",
      child: Text("Tout"),
    ),

    DropdownMenuItem(
      value: "Aujourd'hui",
      child: Text("Aujourd'hui"),
    ),

    DropdownMenuItem(
      value: "Semaine",
      child: Text("Cette semaine"),
    ),

    DropdownMenuItem(
      value: "Mois",
      child: Text("Ce mois"),
    ),

    DropdownMenuItem(
      value: "Année",
      child: Text("Cette année"),
    ),

  ],

  onChanged: (value) {

    if (value == null) return;

    setState(() {

      selectedFilter = value;

    });

  },

),

Expanded(
  child: ListView.builder(

              itemCount:
                    filteredTransactions.length,

              itemBuilder: (context, index) {

                final transaction = filteredTransactions[index];

                final currentDate =
                getDateLabel(
                  DateTime.parse(
                    transaction["transaction_date"],
                  ).toLocal(),
                  texts,
                );

                bool showHeader = true;

                if (index > 0) {
              final previousDate =
                getDateLabel(
                  DateTime.parse(
                    filteredTransactions[index - 1]
                        ["transaction_date"],
                  ).toLocal(),
                  texts,
                );

                  showHeader =
                      currentDate != previousDate;
                }

                return Column(

                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    if (showHeader)

                      Padding(

                        padding:
                            const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 16,
                          bottom: 8,
                        ),

        child: Text(

          currentDate,

          style: const TextStyle(

            fontSize: 18,

            fontWeight:
                FontWeight.bold,

          ),

        ),

      ),

   GestureDetector(

      onTap: () async {

       final result =
    await Navigator.push(

  context,

  MaterialPageRoute(

    builder: (_) =>
        EditTransactionScreen(
      transaction: transaction,
    ),

  ),

);

if (result == true) {

  await _loadTransactions();

}

        setState(() {});

      },

    onLongPress: () async {

  final deleteTransaction =
      await showDialog<bool>(

    context: context,

    builder: (context) {

      return AlertDialog(

        title: Text(
          texts.delete,
        ),

        content: Text(
          texts.deleteTransaction,
        ),

        actions: [

          TextButton(

            onPressed: () {

              Navigator.pop(
                context,
                false,
              );

            },

            child: Text(
              texts.cancel,
            ),

          ),

          ElevatedButton(

            onPressed: () {

              Navigator.pop(
                context,
                true,
              );

            },

            child: Text(
              texts.delete,
            ),

          ),

        ],

      );

    },

  );

  if (deleteTransaction != true) {
    return;
  }

  final deleted =
    await TransactionService
        .deleteTransaction(
      transaction["id"],
    );

if (!deleted) {

  if (!context.mounted) return;

  ScaffoldMessenger.of(context)
      .showSnackBar(

    const SnackBar(
      content: Text(
        "Erreur de suppression",
      ),
    ),

  );

  return;

}

await _loadTransactions();

if (!mounted) return;

setState(() {});

  if (!mounted) return;

  setState(() {});

},

  child: Container(

      margin:
          const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 4,
      ),

      padding:
          const EdgeInsets.all(16),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
            BorderRadius.circular(16),

      ),

      child: Row(

        children: [

          CircleAvatar(

            backgroundColor:

                transaction["transaction_type"] == "expense"
                    ? Colors.red.shade50
                    : Colors.green.shade50,

            child: Icon(

              transaction["transaction_type"] == "expense"
                  ? Icons.remove
                  : Icons.add,

              color:
                  transaction["transaction_type"] == "expense"
                      ? const Color(0xFFD32F2F)
                      : const Color(0xFF006C3D),
            ),

          ),

          const SizedBox(width: 12),

          Expanded(

            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(

                 language == "Français"
                 ? displayCategory(
                 transaction["title"],
                  )
          
              : transaction["title"],

                  style:
                      const TextStyle(
                    fontWeight:
                        FontWeight.bold,
                  ),

                ),

                const SizedBox(height: 4),

                Text(
                  transaction["notes"] ?? "",
                ),

              ],

            ),

          ),

          Text(

          transaction["transaction_type"] == "expense"

    ? "-${CurrencyFormatter.format(
        double.parse(
          transaction["amount"].toString(),
        ).toInt(),
      )} ${CurrencyHelper.symbol(userCurrency)}"

    : "+${CurrencyFormatter.format(
        double.parse(
          transaction["amount"].toString(),
        ).toInt(),
      )} ${CurrencyHelper.symbol(userCurrency)}",
            style: TextStyle(

              color:
                  transaction["transaction_type"] =="expense"
                     ? const Color(0xFFD32F2F)
                     : const Color(0xFF006C3D),
              fontWeight:
                  FontWeight.bold,

            ),

          ),

        ],

      ),

    ),
   ),
  ],

);

},

            ),

          ),

        ],

      ),

    );

  }

}

import 'package:flutter/material.dart';

import '../../services/debt_service.dart';
import '../../core/app_texts.dart';
import '../../services/language_service.dart';
import 'add_debt_screen.dart';
import '../../services/settings_service.dart';
import '../../utils/currency_helper.dart';

class DebtsScreen extends StatefulWidget {

  const DebtsScreen({
    super.key,
  });

  @override
  State<DebtsScreen> createState() =>
      _DebtsScreenState();

}

class _DebtsScreenState
    extends State<DebtsScreen> {

  String language = "Français";
  List<dynamic> debts = [];
  String userCurrency = "FCFA";

  @override
void initState() {

  super.initState();
  _loadCurrency();
  _loadLanguage();
  _loadDebts();

}
Future<void> _loadCurrency() async {

  final currency =
      await SettingsService.getCurrency();

  if (!mounted) return;

  setState(() {

    userCurrency = currency;

  });
}

  bool showReceivable = true;
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

Future<void> _loadDebts() async {

  try {

    final data =
        await DebtService.getDebts();

    if (!mounted) return;

    setState(() {

      debts = data;

    });

  } catch(e) {

    debugPrint(
      e.toString(),
    );

  }

}
  @override
  Widget build(BuildContext context) {

    final texts =
    AppTexts(language);

    final filteredDebts =
    debts.where((debt) {

  if (showReceivable) {

    return debt["debt_type"]
        == "owed_to_me";

  }

  return debt["debt_type"]
      == "i_owe";

}).toList();

    return Scaffold(

      appBar: AppBar(

        title: Text(
          texts.debts,
        ),

      ),

      body: Padding(

        padding:
            const EdgeInsets.all(16),

        child: Column(

          children: [

            Container(

              decoration:
                  BoxDecoration(

                color:
                    Colors.grey.shade200,

                borderRadius:
                    BorderRadius.circular(
                  12,
                ),

              ),

              child: Row(

                children: [

                  Expanded(

                    child: GestureDetector(

                      onTap: () {

                        setState(() {

                          showReceivable =
                              true;

                        });

                      },

                      child: Container(

                        padding:
                            const EdgeInsets.symmetric(
                          vertical: 12,
                        ),

                        decoration:
                            BoxDecoration(

                          color:
                              showReceivable

                                  ? const Color(
                                      0xFF006C3D,
                                    )

                                  : Colors
                                      .transparent,

                          borderRadius:
                              BorderRadius.circular(
                            12,
                          ),

                        ),

                        child: Center(

                          child: Text(

                            texts.oweMe,

                            style: TextStyle(

                              color:
                                  showReceivable

                                      ? Colors.white

                                      : Colors.black,

                            ),

                          ),

                        ),

                      ),

                    ),

                  ),

                  Expanded(

                    child: GestureDetector(

                      onTap: () {

                        setState(() {

                          showReceivable =
                              false;

                        });

                      },

                      child: Container(

                        padding:
                            const EdgeInsets.symmetric(
                          vertical: 12,
                        ),

                        decoration:
                            BoxDecoration(

                          color:
                              !showReceivable

                                  ? const Color(
                                      0xFF006C3D,
                                    )

                                  : Colors
                                      .transparent,

                          borderRadius:
                              BorderRadius.circular(
                            12,
                          ),

                        ),

                        child: Center(

                          child: Text(

                            texts.iOwe,

                            style: TextStyle(

                              color:
                                  !showReceivable

                                      ? Colors.white

                                      : Colors.black,

                            ),

                          ),

                        ),

                      ),

                    ),

                  ),

                ],

              ),

            ),

            const SizedBox(height: 20),

            Expanded(

              child: ListView.builder(

                itemCount:
                    filteredDebts.length,

                itemBuilder:
                    (
                      context,
                      index,
                    ) {

                  final debt = filteredDebts[index];

                  return Card(

                    margin:
                        const EdgeInsets.only(
                      bottom: 12,
                    ),

                    child: Padding(

                      padding:
                          const EdgeInsets.all(
                        16,
                      ),

                      child: Column(

                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [
Row(
  mainAxisAlignment:
      MainAxisAlignment.spaceBetween,
  children: [

    Expanded(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [

          Text(
            debt["person_name"],
            style: const TextStyle(
              fontWeight:
                  FontWeight.bold,
              fontSize: 16,
            ),
          ),

         Text(
            "${debt["amount"]} ${CurrencyHelper.symbol(userCurrency)}",
            overflow: TextOverflow.ellipsis,
          )

        ],
      ),
    ),



IconButton(
  icon: const Icon(
    Icons.edit,
    color: Colors.blue,
  ),
  onPressed: () async {

    final nameController =
        TextEditingController(
      text: debt["person_name"],
    );

    final amountController =
        TextEditingController(
      text: debt["amount"].toString(),
    );
    final dueDateController =
    TextEditingController(
  text: debt["due_date"]
      .toString()
      .split("T")[0],
);

final notesController =
    TextEditingController(
  text: debt["notes"] ?? "",
);

    await showDialog(
      context: context,
      builder: (context) {

        return AlertDialog(

          title: Text(
            texts.editDebt,
          ),

          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

              TextField(
                controller:
                    nameController,
                decoration:
                    InputDecoration(
                  labelText:
                      texts.name,
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              TextField(
                controller:
                    amountController,
                keyboardType:
                    TextInputType.number,
                decoration:
                    InputDecoration(
                  labelText:
                      texts.amount,
                ),
              ),

              const SizedBox(height: 10),

TextField(
  controller: dueDateController,
  readOnly: true,
  decoration: InputDecoration(
    labelText: texts.dueDate,
  ),
  onTap: () async {

    final date =
        await showDatePicker(
      context: context,
      initialDate: DateTime.parse(
        dueDateController.text,
      ),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (date != null) {

      dueDateController.text =
          date
              .toIso8601String()
              .split("T")[0];

    }

  },
),

const SizedBox(height: 10),

TextField(
  controller: notesController,
  maxLines: 3,
  decoration: const InputDecoration(
    labelText: "Notes",
  ),
),

            ],
          ),
),
          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                );
              },
              child: Text(
                texts.cancel,
              ),
            ),

            ElevatedButton(
              onPressed: () async {

                final success =
                    await DebtService
                        .updateDebt(

                  id: debt["id"],

                  personName:
                      nameController.text,

                  amount:
                      double.parse(
                    amountController.text,
                  ),

                  debtType:
                      debt["debt_type"],

                 dueDate:
                      dueDateController.text,

                  notes:
                      notesController.text,

                );

                if (success) {

                  await _loadDebts();

                  if (context.mounted) {

                    Navigator.pop(
                      context,
                    );

                  }

                }

              },
              child:
                  Text(texts.save),
            ),

          ],
        );
      },
    );

  },
),

IconButton(
  icon: const Icon(
    Icons.delete,
    color: Colors.red,
  ),
  onPressed: () async {

    final confirm =
        await showDialog<bool>(
      context: context,
      builder: (context) {

        return AlertDialog(
          title: const Text(
            "Supprimer",
          ),
          content: const Text(
            "Voulez-vous vraiment supprimer cette dette ?",
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

    if (confirm != true) {
      return;
    }

    final success =
        await DebtService.deleteDebt(
      debt["id"],
    );

    if (success) {
      await _loadDebts();
    }
  },
),

  ],
),

                          const SizedBox(
                            height: 6,
                          ),

                          Text(
                            texts.debtRecorded,
                          ),

                          const SizedBox(
                            height: 6,
                          ),

                          Text(

                            "${texts.dueDate} : "
                            "${DateTime.parse(
                                debt["due_date"],
                              ).day}/"
                            "${DateTime.parse(
                                debt["due_date"],
                              ).month}/"
                            "${DateTime.parse(
                                debt["due_date"],
                              ).year}",

                            style:
                                TextStyle(

                              color:
                                  Colors.grey.shade600,

                              fontSize: 12,

                            ),

                          ),

                        ],

                      ),

                    ),

                  );

                },

              ),

            ),

            SizedBox(

              width: double.infinity,

              height: 55,

              child: ElevatedButton.icon(

                onPressed: () async {

                  final result =
                    await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const AddDebtScreen(),
                  ),
                );

                if (result == true) {
                  await _loadDebts();
                }

  if (!mounted) return;

 await _loadDebts();

},

                style:
                    ElevatedButton.styleFrom(

                  backgroundColor:
                      const Color(
                    0xFF006C3D,
                  ),

                ),

                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),

                label:  Text(

                  texts.addDebt,

                  style: TextStyle(
                    color: Colors.white,
                  ),

                ),

              ),

            ),

          ],

        ),

      ),

    );

  }

}

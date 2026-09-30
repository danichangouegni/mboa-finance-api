import 'package:flutter/material.dart';
import '../../services/tontines_storage_service.dart';
import '../../utils/currency_formatter.dart';
import '../../core/app_texts.dart';
import '../../models/tontine_model.dart';
import '../../services/language_service.dart';
import '../../services/settings_service.dart';
import '../../utils/currency_helper.dart';
class TontineDetailsScreen extends StatefulWidget {

  final Map<String, dynamic> tontine;
  final List<Map<String, dynamic>> tontines;

  const TontineDetailsScreen({
  super.key,
  required this.tontine,
  required this.tontines,
});

  @override
  State<TontineDetailsScreen> createState() =>
      _TontineDetailsScreenState();
}

class _TontineDetailsScreenState
    extends State<TontineDetailsScreen> {
      String language = "Français";
      String userCurrency = "FCFA";
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

    language = savedLanguage ??
        "Français";

  });

}

      @override
void initState() {

  super.initState();

  beneficiaries =
      List<Map<String, dynamic>>.from(
    widget.tontine["beneficiaries"] ?? [],
  );

  _loadLanguage();
  _loadCurrency();

}
  late List<Map<String, dynamic>> beneficiaries;

  @override
  Widget build(BuildContext context) {
    final texts =
    AppTexts(language);

    final gainExpected =
        widget.tontine["contribution"] *
        widget.tontine["members"];
    final completedTours =
    beneficiaries.length;

    final totalMembers =
    widget.tontine["members"];

    final nextTour =
    completedTours + 1;
    final gainPerTour =
    widget.tontine["contribution"] *
    widget.tontine["members"];

final distributedAmount =
    completedTours * gainPerTour;

final remainingAmount =
    (totalMembers * gainPerTour) -
    distributedAmount;

    String currentBeneficiary = "";

    if (beneficiaries.isNotEmpty) {
      currentBeneficiary =
          beneficiaries.last["name"];
    }
    return Scaffold(

      appBar: AppBar(
        title: Text(
          widget.tontine["name"],
        ),
      ),
      floatingActionButton:
    FloatingActionButton(
  child: const Icon(Icons.add),

  onPressed: () {

    final controller =
        TextEditingController();

    final noteController =
    TextEditingController();
    final dateController =
    TextEditingController(
  text: DateTime.now()
      .toIso8601String()
      .split('T')
      .first,
);
    showDialog(
      context: context,

      builder: (context) {

        return AlertDialog(

          title: Text(
            texts.addBeneficiary,
          ),

          content: Column(
  mainAxisSize: MainAxisSize.min,

  children: [

    TextField(
      controller: controller,

      decoration:
           InputDecoration(
        labelText:
        texts.beneficiaryName,
      ),
    ),

    const SizedBox(height: 10),
TextField(
  controller: dateController,
  readOnly: true,

  decoration:
    InputDecoration(
  labelText:
      texts.tourDate,
  suffixIcon: const Icon(
    Icons.calendar_month,
  ),
),


  onTap: () async {

    final pickedDate =
        await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      locale:
    language == "Français"
        ? const Locale('fr')
        : const Locale('en'),
    );

    if (pickedDate != null) {

      dateController.text =
          pickedDate
              .toIso8601String()
              .split('T')
              .first;

    }

  },
),

    TextField(
      controller: noteController,

      decoration:
           InputDecoration(
        labelText:
            texts.observation,
      ),
    ),

  ],
),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
             child: Text(
                texts.cancel,
              ),
            ),

            ElevatedButton(
              onPressed: () async {

                if (controller.text
                    .isEmpty) {
                  return;
                }
              setState(() {

              beneficiaries.add({

                "name": controller.text.trim(),

                "date": dateController.text,

                "amount":
                    widget.tontine["contribution"] *
                    widget.tontine["members"],

                "note":
                    noteController.text.trim(),

              });

              widget.tontine["beneficiaries"] =
                  beneficiaries;

            });

            await TontinesStorageService
                .saveTontines(
              widget.tontines,
            );
              if (mounted) {
                setState(() {});
              }        
               
                Navigator.pop(
                  context,
                );

              },

              child: Text(
                texts.add,
              ),
            ),

          ],
        );
      },
    );

  },
),
      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            Text(
"${texts.contribution} : ${CurrencyFormatter.format(widget.tontine["contribution"])} ${userCurrency}"            ),

            const SizedBox(height: 10),

            Text(
              "${texts.members} : ${widget.tontine["members"]}"
            ),

            const SizedBox(height: 10),

           Text(
              "${texts.expectedGain} : ${CurrencyFormatter.format(gainExpected)} ${userCurrency}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 10),

            Text(
              "${texts.progress} : $completedTours / $totalMembers",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),              
            const SizedBox(height: 10),

            LinearProgressIndicator(
              value: totalMembers == 0
                  ? 0
                  : completedTours / totalMembers,
            ),

            const SizedBox(height: 10),

            const SizedBox(height: 10),

            Text(
              "${texts.nextRound} : $nextTour",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 10),

            Text(
  currentBeneficiary.isEmpty
      ? texts.noBeneficiaryYet
      : "${texts.lastBeneficiary} : $currentBeneficiary",
  style: const TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.deepPurple,
  ),
),

            const SizedBox(height: 15),

            Text(
"${texts.distributedAmount} : ${CurrencyFormatter.format(distributedAmount.toInt())} ${userCurrency}",              style: const TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            Text(
"${texts.remainingAmount} : ${CurrencyFormatter.format(remainingAmount)} ${userCurrency}",              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            if (completedTours >= totalMembers)
              Text(
              "✅ ${texts.cycleCompleted}",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(height: 25),

            Text(
                texts.beneficiariesHistory,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(

                itemCount:
                    beneficiaries.length,

                itemBuilder:
                    (context, index) {

                  return ListTile(

  onLongPress: () async {

    final confirm =
        await showDialog<bool>(
      context: context,

      builder: (context) {

        return AlertDialog(

         title: Text(
            texts.deleteBeneficiary,
          ),

          content: Text(
            texts.deleteBeneficiaryQuestion,
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

    if (confirm == true) {

      setState(() {

  beneficiaries.removeAt(index);

  widget.tontine["beneficiaries"] =
      beneficiaries;

});

await TontinesStorageService
    .saveTontines(
  widget.tontines,
);

if (mounted) {
  setState(() {});
}
    }

  },
onTap: () {

  final nameController =
      TextEditingController(
    text: beneficiaries[index]["name"],
  );

  final noteController =
      TextEditingController(
    text:
        beneficiaries[index]["note"] ?? "",
  );

  final dateController =
      TextEditingController(
    text:
        beneficiaries[index]["date"],
  );

  showDialog(
    context: context,

    builder: (context) {

      return AlertDialog(

        title: Text(
          texts.editBeneficiary,
        ),

        content: SingleChildScrollView(
          child: Column(
            mainAxisSize:
                MainAxisSize.min,

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
                    dateController,

                readOnly: true,

                decoration:
                    InputDecoration(
                  labelText:
                      texts.tourDate,
                  suffixIcon: const Icon(
                    Icons.calendar_month,
                  ),
                ),

                onTap: () async {

                  final pickedDate =
                      await showDatePicker(
                    context: context,
                    initialDate:
                        DateTime.now(),
                    firstDate:
                        DateTime(2020),
                    lastDate:
                        DateTime(2035),
                    locale:
                  language == "Français"
                      ? const Locale('fr')
                      : const Locale('en'),
                  );

                  if (pickedDate !=
                      null) {

                    dateController
                        .text = pickedDate
                            .toIso8601String()
                            .split('T')
                            .first;

                  }

                },
              ),

              const SizedBox(
                height: 10,
              ),

              TextField(
                controller:
                    noteController,

                decoration:
                     InputDecoration(
                  labelText:
                       texts.observation,
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

              setState(() {

                beneficiaries[index]
                    ["name"] =
                    nameController.text
                        .trim();

                beneficiaries[index]
                    ["date"] =
                    dateController.text;

                beneficiaries[index]
                    ["note"] =
                    noteController.text
                        .trim();

                widget.tontine[
                    "beneficiaries"] =
                    beneficiaries;

              });
              await TontinesStorageService
                  .saveTontines(
                widget.tontines,
              );
              if (mounted) {
                  setState(() {});
                }
              Navigator.pop(
                context,
              );

            },

           child: Text(
              texts.save,
            )
          ),

        ],
      );

    },
  );

},
  leading: CircleAvatar(
    child: Text(
      "${index + 1}",
    ),
  ),

  title: Text(
    beneficiaries[index]["name"],
  ),

  subtitle: Column(
  crossAxisAlignment:
      CrossAxisAlignment.start,

  children: [

    Text(
      "${beneficiaries[index]["date"]} • Tour ${index + 1}",
          ),

          Text(
           "${CurrencyFormatter.format(beneficiaries[index]["amount"])} ${userCurrency}",
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
          if ((beneficiaries[index]["note"] ?? "")
            .toString()
            .isNotEmpty)

          Text(
            beneficiaries[index]["note"],
            style: const TextStyle(
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
          ),

        ],
      ),

);
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}
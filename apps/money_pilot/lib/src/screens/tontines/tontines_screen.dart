import 'package:flutter/material.dart';
import 'tontine_details_screen.dart';
import '../../utils/currency_formatter.dart';
import '../../core/app_texts.dart';
import '../../services/language_service.dart';
import '../../services/tontine_service.dart';
import '../../services/settings_service.dart';
import '../../utils/currency_helper.dart';

class TontinesScreen extends StatefulWidget {
  const TontinesScreen({super.key});

  @override
  State<TontinesScreen> createState() =>
      _TontinesScreenState();
}

class _TontinesScreenState
    extends State<TontinesScreen> {
    
    List<Map<String, dynamic>> tontines = [];
    String language = "Français";
    String userCurrency = "FCFA";

    Future<void> _loadLanguage() async {

  final savedLanguage = await LanguageService.loadLanguage();
  if (!mounted) return;

  setState(() {

    language =
        savedLanguage ??
        "Français";

  });

}

  @override
void initState() {

  super.initState();

  _loadLanguage();
  _loadTontines();
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

Future<void> _loadTontines() async {

  try {

    final data =
        await TontineService
            .getTontines();

    if (!mounted) return;

    setState(() {

      tontines =
          List<Map<String, dynamic>>
              .from(data);

    });

  } catch (e) {

    debugPrint(
      e.toString(),
    );

  }

}


  @override
  Widget build(BuildContext context) {
        final texts =
    AppTexts(language);

        int totalTontines =
            tontines.length;

        int totalMobilized = 0;

        for (final tontine in tontines) {

        totalMobilized +=
            int.parse(tontine["contribution"].toString(),) *
           int.parse(tontine["members"].toString(),);

        }
    return Scaffold(
        floatingActionButton: FloatingActionButton(
  child: const Icon(Icons.add),

  onPressed: () async {

    final nameController =
        TextEditingController();

    final contributionController =
        TextEditingController();

    final membersController =
        TextEditingController();

    showDialog(
      context: context,

      builder: (context) {

        return AlertDialog(

         title: Text(
            texts.addTontine,
          ),

          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [

                TextField(
                  controller: nameController,

                  decoration:
                       InputDecoration(
                    labelText:
                            texts.tontineName,
                  ),
                ),

                TextField(
                  controller:
                      contributionController,

                  keyboardType:
                      TextInputType.number,

                  decoration:
                      InputDecoration(
                    labelText:
                        texts.contribution,
                  ),
                ),

                TextField(
                  controller:
                      membersController,

                  keyboardType:
                      TextInputType.number,

                  decoration:
                       InputDecoration(
                    labelText:
                          texts.membersCount,
                  ),
                ),

              ],
            ),
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

                if (nameController
                    .text
                    .isEmpty) {
                  return;
                }

                if (contributionController
                    .text
                    .isEmpty) {
                  return;
                }

                if (membersController
                    .text
                    .isEmpty) {
                  return;
                }

                final created =
    await TontineService
        .createTontine(

  name:
      nameController.text,

  contribution:
      int.parse(
    contributionController.text,
  ),

  members:
      int.parse(
    membersController.text,
  ),

);

if (!created) {

  if (!context.mounted) {
    return;
  }

  ScaffoldMessenger.of(context)
      .showSnackBar(

    const SnackBar(
      content: Text(
        "Erreur lors de la création",
      ),
    ),

  );

  return;

}

await _loadTontines();

if (context.mounted) {

  Navigator.pop(
    context,
  );

}

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

      appBar: AppBar(
       title: Text(
          texts.tontines,
        ),
              ),

    body: Column(

  children: [

    Card(

      margin: const EdgeInsets.all(12),

      child: ListTile(

        leading: const Icon(
          Icons.groups,
        ),

        title: Text(
          "$totalTontines ${texts.tontines}",
        ),

        subtitle: Text(
          texts.totalMobilized,
        ),

        trailing: Text(
         "${CurrencyFormatter.format(totalMobilized)} ${CurrencyHelper.symbol(userCurrency)}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

      ),

    ),
Expanded(
  child: ListView.builder(

    itemCount: tontines.length,

    itemBuilder: (context, index) {

      final tontine =
          tontines[index];

     final gainExpected =

    int.parse(
      tontine["contribution"]
          .toString(),
    ) *

    int.parse(
      tontine["members"]
          .toString(),
    );


  final beneficiaries =
    List<Map<String, dynamic>>.from(
  tontine["beneficiaries"] ?? [],
);

final today = DateTime.now();

int completedTours = 0;

for (final beneficiary in beneficiaries) {

  final date =
      DateTime.tryParse(
    beneficiary["date"] ?? "",
  );

  if (date != null &&
      date.isBefore(today)) {

    completedTours++;

  }

}
      String nextBeneficiary = "-";

if (beneficiaries.isNotEmpty) {

  beneficiaries.sort((a, b) {

    final dateA =
        DateTime.tryParse(
          a["date"] ?? "",
        ) ??
        DateTime(2100);

    final dateB =
        DateTime.tryParse(
          b["date"] ?? "",
        ) ??
        DateTime(2100);

    return dateA.compareTo(dateB);

  });

  nextBeneficiary =
      beneficiaries.first["name"] ?? "-";
}

      return Card(

        margin:
            const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),

        elevation: 3,

        shape:
            RoundedRectangleBorder(

          borderRadius:
              BorderRadius.circular(16),

        ),

        child: InkWell(

          borderRadius:
              BorderRadius.circular(16),

          onTap: () {

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    TontineDetailsScreen(
                  tontine: tontine,
                  tontines: tontines,
                ),
              ),
            ).then((_) {
              _loadTontines();
            });

          },

          onLongPress: () async {

            final confirm =
                await showDialog<bool>(

              context: context,

              builder: (context) {

                return AlertDialog(

                  title: Text(
                    texts.deleteTontine,
                  ),

                  content: Text(
                    texts.deleteTontineQuestion,
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

                  tontines.removeAt(index);

             });

            }

          },

          child: Padding(

            padding:
                const EdgeInsets.all(16),

            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Row(

                  children: [

                    const Icon(

                      Icons.groups,

                      color:
                          Color(0xFF006C3D),

                    ),

                    const SizedBox(
                      width: 8,
                    ),

                    Expanded(

                        child: Text(
                        tontine["name"],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF006C3D),
                        ),
                      )
                    ),

                    Row(

  mainAxisSize: MainAxisSize.min,

  children: [

    IconButton(

      icon: const Icon(
        Icons.edit,
      ),

      onPressed: () {

        final nameController =
            TextEditingController(
          text: tontine["name"],
        );

        final contributionController =
            TextEditingController(
          text: tontine["contribution"]
              .toString(),
        );

        final membersController =
            TextEditingController(
          text: tontine["members"]
              .toString(),
        );

        showDialog(

          context: context,

          builder: (context) {

            return AlertDialog(

              title: Text(
                texts.editTontine,
              ),

              content:
                  SingleChildScrollView(

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

                    TextField(

                      controller:
                          contributionController,

                      keyboardType:
                          TextInputType.number,

                      decoration:
                          InputDecoration(
                        labelText:
                            texts.contribution,
                      ),

                    ),

                    TextField(

                      controller:
                          membersController,

                      keyboardType:
                          TextInputType.number,

                      decoration:
                          InputDecoration(
                        labelText:
                            texts.membersCount,
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
    await TontineService.updateTontine(

  id: tontine["id"],

  name:
      nameController.text,

  contribution:
      int.parse(
    contributionController.text,
  ),

  members:
      int.parse(
    membersController.text,
  ),

);

if (success) {

  await _loadTontines();

  if (context.mounted) {

    Navigator.pop(
      context,
    );

  }

}

                     

                  },

                  child: Text(
                    texts.save,
                  ),

                ),

              ],

            );

          },

        );

      },

    ),

    IconButton(

      icon: const Icon(
        Icons.info_outline,
      ),

      onPressed: () {

        Navigator.push(

          context,

          MaterialPageRoute(

            builder: (_) =>
                TontineDetailsScreen(

              tontine: tontine,

              tontines: tontines,

            ),

          ),

        );

      },

    ),

  ],

),
                   

                  ],

                ),

                const SizedBox(
                  height: 12,
                ),

                Text(

                 "${CurrencyFormatter.format(tontine["contribution"])} ${CurrencyHelper.symbol(userCurrency)} / mois",
                  style:
                      const TextStyle(

                    fontSize: 16,

                  ),

                ),

                const SizedBox(
                  height: 10,
                ),

                Row(

                  children: [

                    const Icon(
                      Icons.people,
                      size: 18,
                    ),

                    const SizedBox(
                      width: 4,
                    ),

                    Text(

                      "${tontine["members"]} ${texts.members}",

                    ),

                  ],

                ),


                const SizedBox(
  height: 10,
),

Container(

  padding: const EdgeInsets.symmetric(
    horizontal: 10,
    vertical: 4,
  ),

  decoration: BoxDecoration(

    color:
        ((tontine["beneficiaries"] ?? [])
                    .length >=
                tontine["members"])
            ? Colors.green.shade100
            : Colors.orange.shade100,

    borderRadius:
        BorderRadius.circular(20),

  ),

  child: Text(

    ((tontine["beneficiaries"] ?? [])
                .length >=
            tontine["members"])
        ? "✅ Cycle terminé"
        : "🟢 En cours",

    style: TextStyle(

      color:
          ((tontine["beneficiaries"] ?? [])
                      .length >=
                  tontine["members"])
              ? Colors.green
              : Colors.orange,

      fontWeight:
          FontWeight.bold,

    ),

  ),

),
    const SizedBox(
  height: 12,
),

Text(

  "Prochain bénéficiaire",

  style: TextStyle(
    color: Colors.grey.shade600,
    fontWeight: FontWeight.w500,
  ),

),

const SizedBox(
  height: 4,
),

Text(

  nextBeneficiary,

  style: const TextStyle(

    fontWeight:
        FontWeight.bold,

  ),

),
                const SizedBox(
  height: 12,
),

Text(

 "$completedTours / ${tontine["members"]} tours",

  style: const TextStyle(

    fontWeight: FontWeight.bold,

  ),

),

const SizedBox(
  height: 8,
),

LinearProgressIndicator(

  value:
      tontine["members"] == 0
          ? 0
          : completedTours /
    tontine["members"],

),
                Text(

                  texts.expectedGain,

                  style: TextStyle(
                    color:
                        Colors.grey.shade600,
                  ),

                ),

                const SizedBox(
                  height: 4,
                ),

                Text(

                  "${CurrencyFormatter.format(gainExpected)} ${CurrencyHelper.symbol(userCurrency)}",
                  style:
                      const TextStyle(

                    color: Colors.green,

                    fontWeight:
                        FontWeight.bold,

                    fontSize: 22,

                  ),

                ),

              ],

            ),

          ),

        ),

      );

    },

  ),

),
            
  ],
),

    );
  }
}
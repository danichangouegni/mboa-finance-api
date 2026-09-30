import 'package:flutter/material.dart';

import '../../core/app_texts.dart';
import '../../services/language_service.dart';
import '../../services/goal_service.dart';
import 'add_goal_screen.dart';
import 'edit_goal_screen.dart';
import '../../services/settings_service.dart';
import '../../utils/currency_helper.dart';

class GoalsScreen extends StatefulWidget {

  const GoalsScreen({
    super.key,
  });

  @override
  State<GoalsScreen> createState() =>
      _GoalsScreenState();
}

class _GoalsScreenState
    extends State<GoalsScreen> {

  String language = "Français";
  List<dynamic> goals = [];
  String userCurrency = "FCFA";

  @override
  void initState() {

    super.initState();
    _loadLanguage();
    _loadGoals();
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

  Future<void> _loadGoals() async {

    try {

      final data =
          await GoalService.getGoals();

      if (!mounted) return;

      setState(() {

        goals = data;

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

    return Scaffold(

      appBar: AppBar(
        title: Text(
          texts.goals,
        ),
      ),

      body: Padding(

        padding:
            const EdgeInsets.all(16),

        child: goals.isEmpty

            ? Center(
                child: Text(
                  texts.noGoal,
                ),
              )

            : ListView.builder(

                itemCount:
                    goals.length,

                itemBuilder:
                    (
                      context,
                      index,
                    ) {

                  final goal = goals[index];
                  final targetDate = DateTime.parse(
                    goal["target_date"],
                  );
                  final target = double.parse(
                        goal[
                                "target_amount"]
                            .toString(),
                      );

                  final current = double.parse(
                        goal[
                                "current_amount"]
                            .toString(),
                      );

                 final progress = target <= 0 ? 0.0 : (current / target).clamp(0.0, 1.0);
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
                                MainAxisAlignment
                                    .spaceBetween,

                            children: [

                              Expanded(
                                child: Text(

                                  goal["title"],

                                  style:
                                      const TextStyle(

                                    fontWeight:
                                        FontWeight.bold,

                                    fontSize: 18,

                                  ),
                                ),
                              ),

                             PopupMenuButton<String>(

  itemBuilder: (context) => [

    PopupMenuItem(
      value: "edit",
      child: Text(
        texts.edit,
      ),
    ),

    PopupMenuItem(
      value: "contribution",
      child: Text(
        texts.addContribution,
      ),
    ),

    PopupMenuItem(
      value: "delete",
      child: Text(
        texts.delete,
      ),
    ),

  ],

  onSelected: (value) async {
   if (value == "edit") {

  await Navigator.push(

    context,

    MaterialPageRoute(

      builder: (_) =>
          EditGoalScreen(
        goal: goal,
      ),

    ),

  );

  await _loadGoals();

}

    if (value == "contribution") {

  final controller =
      TextEditingController();

  final amount =
      await showDialog<double>(
    context: context,
    builder: (_) =>
        AlertDialog(
      title: Text(
        texts.addContribution,
      ),
      content: TextField(
        controller: controller,
        keyboardType:
            TextInputType.number,
        decoration:
             InputDecoration(
          hintText:
              texts.amount,
        ),
      ),
      actions: [

        TextButton(
          onPressed: () =>
              Navigator.pop(
            context,
          ),
          child:
               Text(texts.cancel),
        ),

        TextButton(
          onPressed: () {

            Navigator.pop(
              context,

              double.tryParse(
                controller.text,
              ),
            );

          },
          child:
               Text(texts.add),
        ),

      ],
    ),
  );

  if (amount != null) {

  await GoalService.addContribution(
  id: goal["id"],
  contribution: amount,
  currentAmount: current,
  targetAmount: target,
  title: goal["title"],
  targetDate: goal["target_date"],
);

    await _loadGoals();

  }

}

    if (value == "delete") {

      final confirm =
          await showDialog<bool>(

        context: context,

        builder: (_) =>
            AlertDialog(

          title: Text(
            texts.deleteGoal,
          ),

          content: Text(
            texts.deleteGoalQuestion,
          ),

          actions: [

            TextButton(
              onPressed: () =>
                  Navigator.pop(
                context,
                false,
              ),
              child: Text(
                texts.cancel,
              ),
            ),

            TextButton(
              onPressed: () =>
                  Navigator.pop(
                context,
                true,
              ),
              child: Text(
                texts.delete,
              ),
            ),

          ],
        ),
      );

      if (confirm == true) {

        await GoalService.deleteGoal(
          goal["id"],
        );

        await _loadGoals();

      }
    }
  },
)

                            ],
                          ),

                          const SizedBox(
                            height: 10,
                          ),

                          Text(
                            "${texts.targetAmount} : "
                            "${goal["target_amount"]} ${CurrencyHelper.symbol(userCurrency)}",
                          ),

                          Text(
                            "${texts.currentAmount} : "
                            "${goal["current_amount"]} ${CurrencyHelper.symbol(userCurrency)}",
                          ),

                          Text(
                            "${texts.targetDate} : "
                            "${DateTime.parse(goal["target_date"]).day.toString().padLeft(2, '0')}/"
                            "${DateTime.parse(goal["target_date"]).month.toString().padLeft(2, '0')}/"
                            "${DateTime.parse(goal["target_date"]).year}",
                          ),

                          const SizedBox(
                            height: 12,
                          ),

                         LinearProgressIndicator(
                            value: progress,
                          ),

                          const SizedBox(
                            height: 10,
                          ),

                          Text(
                            "${(progress * 100).toStringAsFixed(0)} %",
                          ),

                          if (current >= target)
  Container(

    margin:
        const EdgeInsets.only(
      top: 8,
    ),

    padding:
        const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 6,
    ),

    decoration: BoxDecoration(

      color: Colors.green,

      borderRadius:
          BorderRadius.circular(
        20,
      ),
    ),

    child: Text(

      texts.goalReached,

      style: const TextStyle(
        color: Colors.white,
      ),
    ),
  ),

                        ],
                      ),
                    ),
                  );
                },
              ),
      ),

      floatingActionButton:
          FloatingActionButton(

        backgroundColor:
            const Color(
          0xFF006C3D,
        ),

        onPressed: () async {

          await Navigator.push(

            context,

            MaterialPageRoute(

              builder: (_) =>
                  const AddGoalScreen(),

            ),

          );

          await _loadGoals();

        },

        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
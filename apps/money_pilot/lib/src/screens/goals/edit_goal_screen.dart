import 'package:flutter/material.dart';

import '../../core/app_texts.dart';
import '../../services/language_service.dart';
import '../../services/goal_service.dart';

class EditGoalScreen extends StatefulWidget {

  final Map<String, dynamic> goal;

  const EditGoalScreen({
    super.key,
    required this.goal,
  });

  @override
  State<EditGoalScreen> createState() =>
      _EditGoalScreenState();
}

class _EditGoalScreenState
    extends State<EditGoalScreen> {

  String language = "Français";

  late TextEditingController titleController;
  late TextEditingController targetController;
  late TextEditingController currentController;

  late DateTime targetDate;

  @override
  void initState() {

    super.initState();

    _loadLanguage();

    titleController = TextEditingController(
      text: widget.goal["title"],
    );

    targetController = TextEditingController(
      text: widget.goal["target_amount"].toString(),
    );

    currentController = TextEditingController(
      text: widget.goal["current_amount"].toString(),
    );

    targetDate = DateTime.parse(
      widget.goal["target_date"],
    );
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

    final texts = AppTexts(language);

    return Scaffold(

      appBar: AppBar(
        title: Text(
          texts.editGoal,
        ),
      ),

      body: Padding(

        padding:
            const EdgeInsets.all(20),

        child: Column(

          children: [

            TextField(

              controller:
                  titleController,

              decoration: InputDecoration(
                labelText:
                    texts.goalTitle,
              ),
            ),

            const SizedBox(height: 15),

            TextField(

              controller:
                  targetController,

              keyboardType:
                  TextInputType.number,

              decoration: InputDecoration(
                labelText:
                    texts.targetAmount,
              ),
            ),

            const SizedBox(height: 15),

            TextField(

              controller:
                  currentController,

              keyboardType:
                  TextInputType.number,

              decoration: InputDecoration(
                labelText:
                    texts.currentAmount,
              ),
            ),

            const SizedBox(height: 15),

            OutlinedButton(

              onPressed: () async {

                final selected =
                    await showDatePicker(

                  context: context,

                  initialDate:
                      targetDate,

                  firstDate:
                      DateTime.now(),

                  lastDate:
                      DateTime(2100),

                );

                if (selected != null) {

                  setState(() {

                    targetDate =
                        selected;

                  });

                }
              },

              child: Text(
                "${targetDate.day}/${targetDate.month}/${targetDate.year}",
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(

              width: double.infinity,

              child: ElevatedButton(

                style: ElevatedButton.styleFrom(

                  backgroundColor:
                      const Color(0xFF006C3D),

                  foregroundColor:
                      Colors.white,

                ),

                onPressed: () async {

                  final target =
                      double.tryParse(
                            targetController.text,
                          ) ??
                          0;

                  final current =
                      double.tryParse(
                            currentController.text,
                          ) ??
                          0;

                  final status =
                      current >= target
                          ? "completed"
                          : "active";

                  final success =
                      await GoalService.updateGoal(

                    id: widget.goal["id"],

                    title:
                        titleController.text.trim(),

                    targetAmount:
                        target,

                    currentAmount:
                        current,

                    targetDate:
                        targetDate
                            .toIso8601String()
                            .split("T")[0],

                    status: status,

                  );

                  if (!mounted) return;

                  if (success) {

                    Navigator.pop(
                      context,
                      true,
                    );

                  }
                },

                child: Text(
                  texts.save,
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
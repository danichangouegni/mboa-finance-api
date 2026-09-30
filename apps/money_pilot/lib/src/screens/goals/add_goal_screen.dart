import 'package:flutter/material.dart';

import '../../core/app_texts.dart';
import '../../services/language_service.dart';
import '../../services/goal_service.dart';

class AddGoalScreen extends StatefulWidget {
  const AddGoalScreen({super.key});

  @override
  State<AddGoalScreen> createState() =>
      _AddGoalScreenState();
}

class _AddGoalScreenState
    extends State<AddGoalScreen> {

  final titleController =
      TextEditingController();

  final targetController =
      TextEditingController();

  final currentController =
      TextEditingController();

  String language = "Français";
  bool _isSaving = false;
  DateTime targetDate =
      DateTime.now()
          .add(const Duration(days: 30));

  @override
  void initState() {
    super.initState();
    _loadLanguage();
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

    final texts =
        AppTexts(language);

    return Scaffold(

      appBar: AppBar(
        title: Text(
          texts.addGoal,
        ),
      ),

      body: SingleChildScrollView(

        padding:
            const EdgeInsets.all(20),

        child: Column(

          children: [

            TextField(

              controller:
                  titleController,

              decoration:
                  InputDecoration(

                labelText:
                    texts.goalTitle,

                border:
                    const OutlineInputBorder(),

              ),

            ),

            const SizedBox(
              height: 20,
            ),

            TextField(

              controller:
                  targetController,

              keyboardType:
                  TextInputType.number,

              decoration:
                  InputDecoration(

                labelText:
                    texts.targetAmount,

                border:
                    const OutlineInputBorder(),

              ),

            ),

            const SizedBox(
              height: 20,
            ),

            TextField(

              controller:
                  currentController,

              keyboardType:
                  TextInputType.number,

              decoration:
                  InputDecoration(

                labelText:
                    texts.currentAmount,

                border:
                    const OutlineInputBorder(),

              ),

            ),

            const SizedBox(
              height: 20,
            ),

            InkWell(

              onTap: () async {

                final pickedDate =
                    await showDatePicker(

                  context: context,

                  initialDate:
                      targetDate,

                  firstDate:
                      DateTime.now(),

                  lastDate:
                      DateTime(2100),

                );

                if (pickedDate == null) {
                  return;
                }

                setState(() {

                  targetDate =
                      pickedDate;

                });
              },

  child: InputDecorator(

  decoration: InputDecoration(

    labelText:
        texts.targetDate,

    border:
        const OutlineInputBorder(),

  ),

  child: Row(

    mainAxisAlignment:
        MainAxisAlignment.spaceBetween,

    children: [

      Text(
        "${targetDate.day}/"
        "${targetDate.month}/"
        "${targetDate.year}",
      ),

      const Icon(
        Icons.calendar_today,
      ),

    ],
  ),
),
 ),
   
const SizedBox(
  height: 30,
),

SizedBox(

  width: double.infinity,

  height: 55,

  child: ElevatedButton(

    style:
        ElevatedButton.styleFrom(

      backgroundColor:
          const Color(
        0xFF006C3D,
      ),

    ),

    onPressed: _isSaving ? null
    : () async {

      if (titleController.text.trim().isEmpty) {
        return;
      }

      if (targetController.text.trim().isEmpty) {
        return;
      }
      setState(() { _isSaving = true; });
    try {
      final success = await GoalService.createGoal(

        title:
            titleController.text.trim(),

        targetAmount:
            double.parse(
          targetController.text,
        ),

        currentAmount:
            currentController.text.trim().isEmpty
                ? 0
                : double.parse(
                    currentController.text,
                  ),

        targetDate:
            targetDate
                .toIso8601String()
                .split("T")[0],

      );
   
      if (!success) {

        if (!mounted) return;

        ScaffoldMessenger.of(context)
            .showSnackBar(

          const SnackBar(
            content: Text(
              "Erreur lors de l'ajout",
            ),
          ),

        );

        return;
      }

      Navigator.pop(context);
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
    : Text(
        texts.save,
        style: const TextStyle(
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

                
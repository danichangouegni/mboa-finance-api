import 'package:flutter/material.dart';
import '../../core/app_texts.dart';
import '../../services/language_service.dart';
import '../../services/debt_service.dart';

class AddDebtScreen extends StatefulWidget {

  const AddDebtScreen({
    super.key,
  });

  @override
  State<AddDebtScreen> createState() =>
      _AddDebtScreenState();

}

class _AddDebtScreenState
    extends State<AddDebtScreen> {

  final personController =
      TextEditingController();

  final amountController =
      TextEditingController();

  final descriptionController =
      TextEditingController();
  bool _isSaving = false;
  bool isReceivable = true;

  DateTime dueDate =
      DateTime.now();

    String language = "Français";
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
        texts.addDebt,
        ),

      ),

      body: SingleChildScrollView(

        padding:
            const EdgeInsets.all(20),

        child: Column(

          children: [

            TextField(

              controller:
                  personController,

              decoration:
                    InputDecoration(

                labelText:
                    texts.personName,

                border:
                    const OutlineInputBorder(),

                ),


            ),

            const SizedBox(
              height: 20,
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

                border:
                      const OutlineInputBorder(),


              ),

            ),

            const SizedBox(
              height: 20,
            ),

            TextField(

              controller:
                  descriptionController,

              maxLines: 3,

              decoration:
                    InputDecoration(

                labelText:
                    texts.debtDescription,

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

                  context:
                      context,
                    locale:
                    language == "Français"
                        ? const Locale('fr')
                        : const Locale('en'),
                        
                  initialDate:
                      dueDate,

                  firstDate:
                      DateTime(2020),

                  lastDate:
                      DateTime(2100),

                );

                if (pickedDate == null) {
                  return;
                }

                setState(() {

                  dueDate =
                      pickedDate;

                });

              },

              child: InputDecorator(

                decoration:
                        InputDecoration(

                    labelText:
                        texts.dueDate,

                    border:
                        const OutlineInputBorder(),

                    ),


                child: Row(

                  mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,

                  children: [

                    Text(

                      "${dueDate.day}/"
                      "${dueDate.month}/"
                      "${dueDate.year}",

                    ),

                    const Icon(
                      Icons.calendar_today,
                    ),

                  ],

                ),

              ),

            ),

            const SizedBox(
              height: 20,
            ),

            Align(

            alignment:
                Alignment.centerLeft,

            child: Text(
                texts.debtType,
            ),

            ),


            RadioListTile<bool>(

              value: true,

              groupValue:
                  isReceivable,

              title:
                 Text(
                    texts.oweMe,
                    ),

              onChanged:
                  (value) {

                setState(() {

                  isReceivable =
                      value!;

                });

              },

            ),

            RadioListTile<bool>(

            value: false,

            groupValue:
                isReceivable,

            title: Text(
                texts.iOwe,
            ),

            onChanged: (value) {

                setState(() {

                isReceivable =
                    value!;

                });

            },

            ),

            const SizedBox(
              height: 30,
            ),

            SizedBox(

              width:
                  double.infinity,

              height: 55,

              child:
                  ElevatedButton(

                style:
                    ElevatedButton.styleFrom(

                  backgroundColor:
                      const Color(
                    0xFF006C3D,
                  ),

                ),

                onPressed: _isSaving ? null
                : () async {

                  if (personController
                      .text
                      .isEmpty) {
                    return;
                  }

                  if (amountController
                      .text
                      .isEmpty) {
                    return;
                  }
                  setState(() { _isSaving = true; });
                try {
                  final success = await DebtService.createDebt(

                  personName: personController.text.trim(),

                  amount:double.parse(amountController.text,),

                  debtType:
                      isReceivable
                      ? "owed_to_me"
                      : "i_owe",

                  dueDate:
                      dueDate
                      .toIso8601String()
                      .split("T")[0],

                  notes: "",
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

if (!mounted) return;

Navigator.pop(
  context,
  true,
);
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

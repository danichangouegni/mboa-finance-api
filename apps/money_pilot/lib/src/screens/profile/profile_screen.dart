import 'package:flutter/material.dart';

import '../../core/app_texts.dart';
import '../../services/language_service.dart';

import '../statistics/statistics_screen.dart';
import '../debts/debts_screen.dart';
import '../tontines/tontines_screen.dart';
import '../settings/settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState
    extends State<ProfileScreen> {

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
          savedLanguage ?? "Français";

    });
  }

  @override
  Widget build(BuildContext context) {

    final texts =
        AppTexts(language);

    final isFrench =
        language == "Français";

    return Scaffold(

      appBar: AppBar(
        title: Text(
          texts.profile,
        ),
      ),

      body: ListView(

        children: [

          const SizedBox(height: 20),

          const CircleAvatar(
            radius: 40,
            child: Icon(
              Icons.person,
              size: 40,
            ),
          ),

          const SizedBox(height: 10),

          Center(
            child: Text(
              isFrench
                  ? "Utilisateur Mboa Finance"
                  : "Mboa Finance User",
              style: const TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 20),

          ListTile(
            leading: const Icon(
              Icons.bar_chart,
            ),
            title: Text(
              texts.statistics,
            ),
            trailing: const Icon(
              Icons.chevron_right,
            ),
            onTap: () {

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const StatisticsScreen(),
                ),
              );

            },
          ),

          const Divider(),

          ListTile(
            leading: const Icon(
              Icons.account_balance_wallet,
            ),
            title: Text(
              texts.debts,
            ),
            trailing: const Icon(
              Icons.chevron_right,
            ),
            onTap: () {

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const DebtsScreen(),
                ),
              );

            },
          ),

          const Divider(),

          ListTile(
            leading: const Icon(
              Icons.groups,
            ),
            title: Text(
              texts.tontines,
            ),
            trailing: const Icon(
              Icons.chevron_right,
            ),
            onTap: () {

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const TontinesScreen(),
                ),
              );

            },
          ),

          const Divider(),

          ListTile(
            leading: const Icon(
              Icons.settings,
            ),
            title: Text(
              texts.settings,
            ),
            trailing: const Icon(
              Icons.chevron_right,
            ),
            onTap: () {

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const SettingsScreen(),
                ),
              );

            },
          ),

          const Divider(),

          ListTile(
            leading: const Icon(
              Icons.info_outline,
            ),
            title: Text(
              texts.about,
            ),
            trailing: const Icon(
              Icons.chevron_right,
            ),
            onTap: () {

              showDialog(

                context: context,

                builder: (context) {

                  return AlertDialog(

                    title: Text(
                      texts.aboutTitle,
                    ),

                    content:
                        SingleChildScrollView(

                      child: Column(

                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        mainAxisSize:
                            MainAxisSize.min,

                        children: [

                          Text(
                            texts.aboutDescription,
                          ),

                          const SizedBox(
                            height: 16,
                          ),

                          Text(
                            texts.features,
                            style: const TextStyle(
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(
                            height: 8,
                          ),

                          Text(texts.incomeManagement),
                          Text(texts.expenseManagement),
                          Text(texts.debtManagement),
                          Text(texts.tontineManagement),
                          Text(texts.savingsManagement),
                          Text(texts.financialDashboard),
                          Text(texts. financialStatistics),
                          Text(texts.deadlineNotifications),
                          Text(texts.step1),
                          Text(texts.step2),
                          Text(texts.step3),
                          Text(texts.step4),
                          Text(texts.supportText),
                          
                          const Text(
                            "danichangouegni@gmail.com",
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
                          texts.close,
                        ),
                      ),

                    ],
                  );
                },
              );
            },
          ),

        ],
      ),
    );
  }
}
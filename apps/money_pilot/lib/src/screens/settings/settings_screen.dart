import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../services/language_service.dart';
import '../../services/settings_service.dart';

import '../auth/auth_landing_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() =>
      _SettingsScreenState();
}

class _SettingsScreenState
    extends State<SettingsScreen> {

  bool notificationsEnabled = true;
  String currency = "FCFA";
  String language = "Français";

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

 Future<void> _loadSettings() async {

  final savedCurrency =
      await SettingsService.getCurrency();

  final savedLanguage =
      await LanguageService.loadLanguage();

  final notifications =
      await SettingsService
          .getNotificationsEnabled();

  if (!mounted) return;

  setState(() {

    language =
        savedLanguage ?? "Français";

    notificationsEnabled =
        notifications;

    currency =
        savedCurrency;

  });
}


  Future<void> _changeLanguage() async {

    await showDialog(

      context: context,

      builder: (context) {

        return AlertDialog(

          title: Text(
            language == "Français"
                ? "Choisir la langue"
                : "Choose language",
          ),

          content: Column(

            mainAxisSize:
                MainAxisSize.min,

            children: [

              ListTile(

                title: const Text(
                  "Français",
                ),

                onTap: () async {

                  await LanguageService
                      .saveLanguage(
                    "Français",
                  );

                  if (!mounted) return;

                  setState(() {

                    language =
                        "Français";

                  });

                  Navigator.pop(
                    context,
                  );
                },
              ),

              ListTile(

                title: const Text(
                  "English",
                ),

                onTap: () async {

                  await LanguageService
                      .saveLanguage(
                    "English",
                  );

                  if (!mounted) return;

                  setState(() {

                    language =
                        "English";

                  });

                  Navigator.pop(
                    context,
                  );
                },
              ),

            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    final isFrench =
        language == "Français";

    return Scaffold(

      appBar: AppBar(

        title: Text(

          isFrench
              ? "Paramètres"
              : "Settings",

        ),
      ),

      body: ListView(

        children: [

          ListTile(

            leading: const Icon(
              Icons.language,
            ),

            title: Text(
              isFrench
                  ? "Langue"
                  : "Language",
            ),

            subtitle: Text(
              language,
            ),

            onTap: _changeLanguage,
          ),

          const Divider(),

          SwitchListTile(

            secondary: const Icon(
              Icons.notifications,
            ),

            title: Text(
              isFrench
                  ? "Notifications"
                  : "Notifications",
            ),

            value:
                notificationsEnabled,

            onChanged:
                (value) async {

              await SettingsService
                  .setNotificationsEnabled(
                value,
              );

              setState(() {

                notificationsEnabled =
                    value;

              });
            },
          ),

const Divider(),

ListTile(

  leading: const Icon(
    Icons.attach_money,
  ),

  title: Text(
    isFrench
        ? "Devise"
        : "Currency",
  ),

  subtitle: Text(currency),

  trailing: DropdownButton<String>(

    value: currency,

    items: const [

      DropdownMenuItem(
        value: "FCFA",
        child: Text("FCFA"),
      ),

      DropdownMenuItem(
        value: "USD",
        child: Text("USD"),
      ),

      DropdownMenuItem(
        value: "EUR",
        child: Text("EUR"),
      ),

      DropdownMenuItem(
        value: "GBP",
        child: Text("GBP"),
      ),

      DropdownMenuItem(
        value: "NGN",
        child: Text("NGN"),
      ),

      DropdownMenuItem(
        value: "CDF",
        child: Text("CDF"),
      ),

    ],

    onChanged: (value) async {

      if (value == null) return;

      await SettingsService
          .saveCurrency(value);

      setState(() {

        currency = value;

      });

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(

          content: Text(

            isFrench
                ? "Devise enregistrée"
                : "Currency saved",

          ),

        ),

      );

    },

  ),

),
          const Divider(),

          ListTile(

            leading: const Icon(
              Icons.lock,
            ),

            title: Text(
              isFrench
                  ? "Sécurité"
                  : "Security",
            ),

            subtitle: Text(
              isFrench
                  ? "Bientôt disponible"
                  : "Coming soon",
            ),

            onTap: () {},
          ),

          const Divider(),

          ListTile(

            leading: const Icon(
              Icons.info_outline,
            ),

            title: Text(
              isFrench
                  ? "À propos"
                  : "About",
            ),

            onTap: () {

              showAboutDialog(

                context: context,

                applicationName:
                    "Mboa Finance",

                applicationVersion:
                    "1.0.0",

                children: [

                  Text(

                    isFrench
                        ? "Application de gestion financière personnelle : revenus, dépenses, dettes, tontines et objectifs d'épargne."
                        : "Personal finance application: income, expenses, debts, tontines and savings goals.",

                  ),

                ],
              );
            },
          ),

          const Divider(),

          ListTile(

            leading: const Icon(
              Icons.system_update,
            ),

            title: Text(
              isFrench
                  ? "Version"
                  : "Version",
            ),

            subtitle: const Text(
              "1.0.0",
            ),
          ),

          const Divider(),

          ListTile(

            leading: const Icon(
              Icons.logout,
              color: Colors.red,
            ),

            title: Text(
              isFrench
                  ? "Déconnexion"
                  : "Logout",
            ),

            onTap: () async {

              await AuthService.logout();

              if (!mounted) return;

              Navigator.pushAndRemoveUntil(

                context,

                MaterialPageRoute(

                  builder: (_) =>
                      AuthLandingScreen(
                    language: language,
                  ),

                ),

                (route) => false,

              );
            },
          ),

        ],
      ),
    );
  }
}
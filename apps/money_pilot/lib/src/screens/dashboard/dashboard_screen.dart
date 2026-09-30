import 'package:flutter/material.dart';
import '../transactions/transactions_screen.dart';
import '../transactions/add_expense_screen.dart';
import '../../data/finance_data.dart';
import '../savings/savings_screen.dart';
import '../transactions/add_income_screen.dart';
import '../statistics/statistics_screen.dart';
import '../profile/profile_screen.dart';
import '../../core/app_texts.dart';
import '../../services/language_service.dart';
import '../../services/user_service.dart';
import '../../utils/currency_formatter.dart';
import '../auth/auth_landing_screen.dart';
import '../../services/auth_service.dart';
import '../../services/transaction_service.dart';
import '../goals/goals_screen.dart';
import '../../services/goal_service.dart';
import '../notifications/notifications_screen.dart';
import '../../services/settings_service.dart';
import '../../utils/currency_helper.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  String language = "Français";
  String userCurrency = "FCFA";
  String userName = "Utilisateur";

  bool hideBalance = false;
  List<dynamic> transactions = [];
  List<dynamic> goals = [];
  
Future<void> _checkAuth() async {

  try {

    final profile =
        await AuthService.getProfile();

    if (profile["success"] != true) {

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

      return;
    }

    _loadLanguage();
    _loadUser();
    _loadTransactions();
    _loadGoals();

  } catch (e) {

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
  }
}
  @override
void initState() {

  super.initState();
  _loadCurrency();
  WidgetsBinding.instance
      .addPostFrameCallback((_) {

    _checkAuth();

  });

}
Future<void> _loadCurrency() async {

  final currency =
      await SettingsService.getCurrency();

  if (!mounted) return;

  setState(() {

    userCurrency = currency;

  });
}
  Future<void> _loadUser() async {

  try {

    final profile =
        await AuthService.getProfile();

    if (!mounted) return;

    if (profile["success"] == true) {

      setState(() {

        userName =
            profile["user"]["full_name"];

      });

    }

  } catch (e) {

    debugPrint(e.toString());

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


Future<void> _loadGoals() async {

  try {

    final data =
        await GoalService.getGoals();

    if (!mounted) return;

    setState(() {

      goals = data;

    });

  } catch (e) {

    debugPrint(e.toString());

  }
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

  Future<void> _logout() async {

  await AuthService.logout();

  if (!mounted) return;

  Navigator.pushAndRemoveUntil(

    context,

    MaterialPageRoute(
     builder: (_) => AuthLandingScreen(
  language: language,
),
    ),

    (route) => false,

  );

}

  @override
  Widget build(BuildContext context) {

    final texts =
        AppTexts(language);


    double income = 0;
double expense = 0;

for (var transaction in transactions) {

  final amount =
      double.tryParse(
        transaction["amount"]
            .toString(),
      ) ??
      0;

  if (
      transaction["transaction_type"] ==
      "expense") {

    expense += amount;

  } else {

    income += amount;

  }

}

    final balance = income - expense;

    final transactionCount = transactions.length;

    final categoryCount =
    FinanceData.transactions
        .map((t) => t.title)
        .toSet()
        .length;
    
    final goalCount = goals.length;

double savedAmount = 0;

double savingsGoal = 0;

for (final goal in goals) {

  savedAmount +=
      double.tryParse(
        goal["current_amount"].toString(),
      ) ??
      0;

  savingsGoal +=
      double.tryParse(
        goal["target_amount"].toString(),
      ) ??
      0;
}

final savingsProgress =
    savingsGoal == 0
        ? 0.0
        : (savedAmount / savingsGoal)
            .clamp(0.0, 1.0);

final savingsPercentage =
    (savingsProgress * 100)
        .round();

      final firstName =
    userName.split(' ').first;

  int notificationCount = 0;
  for (final goal in goals) {

  final targetDate =
      DateTime.parse(
    goal["target_date"],
  );

  final days =
      targetDate
          .difference(
            DateTime.now(),
          )
          .inDays;

  if (days >= 0 &&
      days <= 7) {

    notificationCount++;

  }
}
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(

  title: const Text(
    "MBOA",
  ),

  actions: [

    IconButton(

      icon: const Icon(
        Icons.logout,
      ),

      onPressed: _logout,

    ),

  ],

),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF006C3D),

        onPressed: () async {

              final choice = await showModalBottomSheet<String>(
                context: context,
                builder: (context) {

                  return SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        ListTile(
                          leading: const Icon(Icons.remove_circle),
                          title: const Text("Nouvelle dépense"),
                          onTap: () {
                            Navigator.pop(
                              context,
                              "expense",
                            );
                          },
                        ),

                        ListTile(
                          leading: const Icon(Icons.add_circle),
                          title: const Text("Nouveau revenu"),
                          onTap: () {
                            Navigator.pop(
                              context,
                              "income",
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              );

              if (choice == "expense") {
                final result =
                    await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AddExpenseScreen(),
                  ),
                );

                if (result == true) {
                  await _loadTransactions();
                }
              }

              if (choice == "income") {

                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AddIncomeScreen(),
                  ),
                );

                await _loadTransactions();
              }
            },


        child: const Icon(Icons.add),
      ),

      bottomNavigationBar: NavigationBar(
           selectedIndex: 0,

        onDestinationSelected: (index) {

          if (index == 1) {

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const TransactionsScreen(),
              ),
            );

          }

          if (index == 2) {

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const GoalsScreen(),
                ),
              );

          }

          if (index == 3) {

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ProfileScreen(),
              ),
            );

          }

        },

          destinations: [

            NavigationDestination(
              icon: Icon(Icons.home),
             label: texts.dashboard,
            ),

            NavigationDestination(
                  icon: Icon(Icons.receipt_long),
                  label: texts.transactions,
                ),

                NavigationDestination(
                  icon: Icon(Icons.savings),
                  label: texts.goals,
                ),

                

              NavigationDestination(
                icon: Icon(Icons.person),
                label: texts.settings,
              ),
            ],
          ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),

          children: [

          Row(

  mainAxisAlignment:
      MainAxisAlignment.spaceBetween,

  crossAxisAlignment:
      CrossAxisAlignment.start,

  children: [

    Column(

      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        Text(
          language == "Français"
              ? "Bonjour"
              : "Hello",

          style: const TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          "$firstName 👋",

          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),

      ],

    ),
  Stack(
  children: [

    InkWell(
      onTap: () {

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                const NotificationsScreen(),
          ),
        );

      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.notifications_none,
          size: 20,
        ),
      ),
    ),

   if (notificationCount > 0)
  Positioned(
      right: 0,
      top: 0,
      child: Container(
        width: 18,
        height: 18,
        decoration: const BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
      child: Center(
  child: Text(
    notificationCount.toString(),
    style: const TextStyle(
      color: Colors.white,
      fontSize: 10,
      fontWeight: FontWeight.bold,
    ),
  ),
),
      ),
    ),

  ],
)

  ],

),
                
            Container(
              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: const Color(0xFF006C3D),
                borderRadius: BorderRadius.circular(24),
              ),

       child: Column(

  crossAxisAlignment:
      CrossAxisAlignment.start,

  children: [

    Row(

      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,

      children: [

        Text(
          texts.balance,

          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),

        IconButton(

          padding: EdgeInsets.zero,
          constraints:
              const BoxConstraints(),

          onPressed: () {

              setState(() {

                      hideBalance =
                          !hideBalance;

                    });

              },

              icon: Icon(

                hideBalance
                    ? Icons.visibility_off
                    : Icons.visibility,

                color: Colors.white,

              ),

        ),

      ],

    ),

    const SizedBox(height: 8),

  Text(
  hideBalance
      ? "••••••••"
      : "${CurrencyFormatter.format(balance)} ${CurrencyHelper.symbol(userCurrency)}",
  style: const TextStyle(
color: Colors.white,
fontSize: 28,
fontWeight: FontWeight.bold,
),
)

  ],

),


    ),

            const SizedBox(height: 16),


            Row(
              children: [

                Expanded(
                 child: _StatCard(
                  title: language == "Français"
                      ? "Revenus"
                      : "Income",
                  value:
                      "${CurrencyFormatter.format(income)} ${CurrencyHelper.symbol(userCurrency)}",
                  color: Colors.green,
                ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: _StatCard(
                    title: language == "Français"
                        ? "Dépenses"
                        : "Expenses",
                    value:
                        "${CurrencyFormatter.format(expense)} ${CurrencyHelper.symbol(userCurrency)}",
                    color: Colors.red,
                  ),
                ),
              ],
            ),

           const SizedBox(height: 16),

Container(
  padding: const EdgeInsets.all(16),

  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
  ),

  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,

    children: [

      Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,

        children: [

          Text(
            language == "Français"
                ? "Épargne ce mois"
                : "Monthly Savings",

            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          Column(
            crossAxisAlignment:
                CrossAxisAlignment.end,

            children: [

              Text(
                "$savingsPercentage%",

                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
                Text(
                 "${CurrencyFormatter.format(savedAmount)} ${CurrencyHelper.symbol(userCurrency)}"
" / "
"${CurrencyFormatter.format(savingsGoal)} ${CurrencyHelper.symbol(userCurrency)}",
                )

            ],
          ),

        ],
      ),

      const SizedBox(height: 10),

      LinearProgressIndicator(
        value: savingsProgress,
        minHeight: 8,
        borderRadius:
            BorderRadius.circular(20),
      ),

    ],
  ),
),

const SizedBox(height: 16),


Card(
  child: Padding(
    padding: const EdgeInsets.all(12),

    child: Column(
      children: [

        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,

          children: [

            Text(
              language == "Français"
                  ? "Résumé du mois"
                  : "Monthly Summary",

              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            TextButton(

              onPressed: () {

                Navigator.push(

                  context,

                  MaterialPageRoute(
                    builder: (_) =>
                        const StatisticsScreen(),
                  ),

                );

              },

              child: Text(

                language == "Français"
                    ? "Voir tout"
                    : "See all",

              ),

            ),

          ],
        ),

        const Divider(),

        _SummaryRow(
          label: language == "Français"
              ? "Transactions"
              : "Transactions",
          value: transactionCount.toString(),
        ),

        const Divider(),

        _SummaryRow(
          label: language == "Français"
              ? "Catégories"
              : "Categories",
          value: categoryCount.toString(),
        ),

        const Divider(),

        _SummaryRow(
          label: language == "Français"
              ? "Objectifs"
              : "Goals",
          value: goalCount.toString(),
        ),

      ],
    ),
  ),
),
             const SizedBox(height: 20),

                  ],
      ),
    ),
  );
}

}



class _StatCard extends StatelessWidget {

  final String title;
  final String value;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
            BorderRadius.circular(20),

      ),

      child: Column(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Text(

            title,

            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
            ),

          ),

          const SizedBox(height: 6),

          Text(

            value,

            overflow:
                TextOverflow.ellipsis,

            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight:
                  FontWeight.bold,
            ),

          ),

        ],

      ),

    );

  }

}
class _SummaryRow extends StatelessWidget {

  final String label;
  final String value;

  const _SummaryRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {

    return Padding(

      padding: const EdgeInsets.symmetric(
        horizontal: 20,

        vertical: 16,
      ),

      child: Row(

        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,

        children: [

          Text(label),

          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

        ],

      ),

    );

  }



}


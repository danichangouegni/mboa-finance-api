import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../core/app_texts.dart';
import '../../services/language_service.dart';
import '../../services/transaction_service.dart';
import '../../utils/category_helper.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() =>
      _StatisticsScreenState();
}

class _StatisticsScreenState
    extends State<StatisticsScreen> {

  String language = "Français";
  int selectedMonth =  DateTime.now().month;
  List<dynamic> transactions = [];

  @override
void initState() {
  super.initState();

  _loadLanguage();

  _loadTransactions();
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

String displayCategory(
  String category,
) {

  switch (category) {

    case "transport":
      return language == "Français"
          ? "Transport"
          : "Transport";

    case "food":
      return language == "Français"
          ? "Alimentation"
          : "Food";

    case "housing":
      return language == "Français"
          ? "Logement"
          : "Housing";

    case "health":
      return language == "Français"
          ? "Santé"
          : "Health";

    case "communication":
      return language == "Français"
          ? "Communication"
          : "Communication";

    case "education":
      return language == "Français"
          ? "Éducation"
          : "Education";

    case "leisure":
      return language == "Français"
          ? "Loisirs"
          : "Leisure";

    case "savings":
      return language == "Français"
          ? "Épargne"
          : "Savings";

    case "investment":
      return language == "Français"
          ? "Investissement"
          : "Investment";

    default:
      return language == "Français"
          ? "Autres"
          : "Others";
  }
}

  @override
  Widget build(BuildContext context) {


final months =
    language == "Français"

        ? [
            "Janvier",
            "Février",
            "Mars",
            "Avril",
            "Mai",
            "Juin",
            "Juillet",
            "Août",
            "Septembre",
            "Octobre",
            "Novembre",
            "Décembre",
          ]

        : [
            "January",
            "February",
            "March",
            "April",
            "May",
            "June",
            "July",
            "August",
            "September",
            "October",
            "November",
            "December",
          ];

final filteredTransactions =
    transactions.where(
      (transaction) {

    final date =
        DateTime.parse(
      transaction[
          "transaction_date"],
    );

    return date.month ==
        selectedMonth;

  },
).toList();

final Map<String, int>
    categoryTotals = {};

    for (final transaction
    in filteredTransactions) {

      if (
    transaction[
        "transaction_type"] !=
    "expense") {

  continue;

}

final amount =
    double.parse(
      transaction["amount"]
          .toString(),
    ).toInt();

final category =
    CategoryHelper.normalize(
      transaction["title"] ?? "",
    );

categoryTotals.update(
  category,
  (value) => value + amount,
  ifAbsent: () => amount,
);
    }

    final totalExpenses =
        categoryTotals.values.fold(
      0,
      (sum, value) =>
          sum + value,
    );
  final sortedCategories =
    categoryTotals.entries.toList()
      ..sort(
        (a, b) =>
            b.value.compareTo(a.value),
      );

    final Map<int, double>
    monthlyExpenses = {};
   for (final transaction
    in transactions) {

  if (
    transaction[
        "transaction_type"] !=
    "expense") {

  continue;

}

 final month =
    DateTime.parse(
      transaction["transaction_date"],
    ).month;


  monthlyExpenses.update(

  month,

  (value) =>
      value +
      double.parse(
        transaction["amount"]
            .toString(),
      ),

  ifAbsent: () =>
      double.parse(
        transaction["amount"]
            .toString(),
      ),

);
  
}
final List<FlSpot>
    evolutionSpots = [];
    for (int month = 1;
    month <= 12;
    month++) {

  evolutionSpots.add(

    FlSpot(

      month.toDouble(),

      monthlyExpenses[
              month] ??
          0,

    ),

  );
}

/*final now = DateTime.now();*/

final currentMonth =
    selectedMonth;

final previousMonth =
    currentMonth == 1
        ? 12
        : currentMonth - 1;

final currentMonthAmount =
    monthlyExpenses[
        currentMonth] ??
    0;

final previousMonthAmount =
    monthlyExpenses[
        previousMonth] ??
    0;

double variation = 0;

if (previousMonthAmount > 0) {

  variation =

      ((currentMonthAmount -
                  previousMonthAmount) /
              previousMonthAmount) *
          100;

}

    final colors = [
  const Color(0xFF4285F4), // bleu
  const Color(0xFF34A853), // vert
  const Color(0xFFFBBC05), // jaune
  const Color(0xFFEA4335), // rouge
  const Color(0xFF9C27B0), // violet
];

    return Scaffold(

      appBar: AppBar(
        title: Text(
          language == "Français"
              ? "Statistiques"
              : "Statistics",
        ),
      ),

      body: ListView(

        padding:
            const EdgeInsets.all(16),

        children: [

          DropdownButtonFormField<int>(

  value: selectedMonth,

  decoration:
      const InputDecoration(
    border:
        OutlineInputBorder(),
  ),

  items:

      List.generate(

    12,

    (index) {

      return DropdownMenuItem(

        value: index + 1,

        child: Text(
          months[index],
        ),

      );

    },

  ),

  onChanged: (value) {

    if (value == null) return;

    setState(() {

      selectedMonth = value;

    });

  },

),

          const SizedBox(height: 24),

          Text(

            language ==
                    "Français"

                ? "Dépenses par catégorie"

                : "Expenses by category",

            style: const TextStyle(
              fontSize: 18,
              fontWeight:
                  FontWeight.bold,
            ),

          ),

          const SizedBox(height: 20),

         SizedBox(

  height: 180,

  child: Row(

    crossAxisAlignment:
        CrossAxisAlignment.start,

    children: [

      Expanded(

        flex: 2,

        child: PieChart(

          PieChartData(

            centerSpaceRadius: 50,

            sections:

                sortedCategories
                    .toList()
                    .asMap()
                    .entries
                    .map((entry) {

              final index =
                  entry.key;

              final amount =
                  entry.value.value;

              final percent =
                  totalExpenses == 0
                      ? 0.0
                      : (amount /
                              totalExpenses) *
                          100;

              return PieChartSectionData(

                color: colors[
                    index %
                        colors.length],

                value: percent,

                radius: 30,

                title: "",

              );

            }).toList(),

          ),

        ),

      ),

      const SizedBox(width: 16),

      Expanded(

        flex: 2,

        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children:

             sortedCategories
                  .toList()
                  .asMap()
                  .entries
                  .map((entry) {

            final index =
                entry.key;

            final amount =
                entry.value.value;

            final percent =
                totalExpenses == 0
                    ? 0
                    : ((amount /
                                totalExpenses) *
                            100)
                        .round();

            return Padding(

              padding:
                  const EdgeInsets.only(
                bottom: 10,
              ),

              child: Row(

                children: [

                  Container(

                    width: 10,

                    height: 10,

                    decoration:
                        BoxDecoration(

                      color: colors[
                          index %
                              colors.length],

                      shape:
                          BoxShape.circle,

                    ),

                  ),

                  const SizedBox(
                    width: 8,
                  ),

                  Expanded(

                    child: Text(
                      displayCategory(
                        entry.value.key,
                      ),
                      overflow:
                          TextOverflow
                              .ellipsis,
                    ),

                  ),

                  Text(
                    "$percent%",
                  ),

                ],

              ),

            );

          }).toList(),

        ),

      ),

    ],

  ),

),

const SizedBox(height: 30),

Row(

  mainAxisAlignment:
      MainAxisAlignment.spaceBetween,

  children: [

    Text(

      language == "Français"
          ? "Évolution"
          : "Trend",

      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),

    ),

    Column(

      crossAxisAlignment:
          CrossAxisAlignment.end,

      children: [

        Text(

          "${variation.toStringAsFixed(1)}%",

          style: TextStyle(

            color:
                variation >= 0
                    ? const Color(0xFF006C3D)
                    : const Color(0xFFD32F2F),

            fontWeight:
                FontWeight.bold,

          ),

        ),

        Text(

          language == "Français"
              ? "par rapport au mois dernier"
              : "vs last month",

          style: const TextStyle(
            fontSize: 10,
          ),

        ),

      ],

    ),

  ],

),

const SizedBox(height: 20),

SizedBox(

  height: 180,

  child: LineChart(

    LineChartData(

      borderData: FlBorderData(
        show: false,
      ),

      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
      ),

      titlesData: FlTitlesData(
      topTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: false,
        ),
      ),

      rightTitles: AxisTitles(
sideTitles: SideTitles(
showTitles: false,
),
),

  leftTitles: AxisTitles(

  sideTitles: SideTitles(

    showTitles: true,

    reservedSize: 40,

    getTitlesWidget:
        (value, meta) {

      if (value == 0) {
        return const SizedBox();
      }

      return Text(

        "${(value / 1000).round()}K",

        style: const TextStyle(
          fontSize: 10,
        ),

      );

    },

  ),

),

        bottomTitles: AxisTitles(

          sideTitles: SideTitles(

            showTitles: true,

           getTitlesWidget:
    (value, meta) {

  final index =
      value.toInt();

  if (
      index < 1 ||
      index > 12) {

    return const SizedBox();
  }

  final months =
      language == "Français"

          ? [
              '',
              'Jan',
              'Fév',
              'Mar',
              'Avr',
              'Mai',
              'Juin',
              'Juil',
              'Aoû',
              'Sep',
              'Oct',
              'Nov',
              'Déc',
            ]

          : [
              '',
              'Jan',
              'Feb',
              'Mar',
              'Apr',
              'May',
              'Jun',
              'Jul',
              'Aug',
              'Sep',
              'Oct',
              'Nov',
              'Dec',
            ];

  if (index.isEven) {

    return const SizedBox();

  }

  return Padding(

    padding:
        const EdgeInsets.only(
      top: 8,
    ),

    child: Text(

      months[index],

      style:
          const TextStyle(
        fontSize: 11,
      ),

    ),

  );

},
              

          ),

        ),

      ),

      lineBarsData: [

        LineChartBarData(

          spots:
              evolutionSpots,

          isCurved: true,

          color: const Color(0xFF34A853),

          barWidth: 4,

         dotData: FlDotData(

            getDotPainter:
                (spot, percent, bar, index) {

              return FlDotCirclePainter(

                radius: 2.5,

                color: const Color(0xFF34A853),

                strokeWidth: 0,

              );

            },

          ),

        belowBarData: BarAreaData(

          show: true,

          color: const Color(0xFF006C3D).withOpacity(
            0.05,
          ),

        ),
        ),

      ],

    ),

  ),

),
],

),
);
}
}

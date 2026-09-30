import 'package:flutter/material.dart';

import '../../services/goal_service.dart';
import '../../services/debt_service.dart';
import '../../services/tontine_service.dart';

import '../goals/goals_screen.dart';
import '../debts/debts_screen.dart';
import '../tontines/tontines_screen.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({
    super.key,
  });

  @override
  State<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState
    extends State<NotificationsScreen> {

  List<Map<String, dynamic>>
      notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void>
      _loadNotifications() async {

    final List<Map<String, dynamic>>
        items = [];

    try {

      final goals =
          await GoalService.getGoals();

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

          items.add({
            "type": "goal",
            "title":
                "Objectif proche",
            "message":
                "${goal["title"]} arrive à échéance dans $days jour(s)",
            "data": goal,
          });
        }
      }

      final debts =
          await DebtService.getDebts();

      for (final debt in debts) {

        final dueDate =
            DateTime.parse(
          debt["due_date"],
        );

        final days =
            dueDate
                .difference(
                  DateTime.now(),
                )
                .inDays;

        if (days >= 0 &&
            days <= 7) {

          items.add({
            "type": "debt",
            "title":
                "Dette proche",
            "message":
                "${debt["person_name"]} - échéance dans $days jour(s)",
            "data": debt,
          });
        }
      }

    
      
      

      if (!mounted) return;

      setState(() {

        notifications = items;

      });

    } catch (e) {

      debugPrint(
        e.toString(),
      );

    }
  }

  IconData _getIcon(
    String type,
  ) {

    switch (type) {

      case "goal":
        return Icons.flag;

      case "debt":
        return Icons.warning;

      case "tontine":
        return Icons.groups;

      default:
        return Icons.notifications;

    }
  }

  Color _getColor(
    String type,
  ) {

    switch (type) {

      case "goal":
        return Colors.blue;

      case "debt":
        return Colors.orange;

      case "tontine":
        return Colors.green;

      default:
        return Colors.grey;

    }
  }

  void _openNotification(
    Map<String, dynamic> notification,
  ) {

    if (notification["type"] ==
        "goal") {

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              const GoalsScreen(),
        ),
      );
    }

    if (notification["type"] ==
        "debt") {

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              const DebtsScreen(),
        ),
      );
    }

    if (notification["type"] ==
        "tontine") {

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              const TontinesScreen(),
        ),
      );
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Notifications",
        ),
      ),

      body: notifications.isEmpty

          ? const Center(
              child: Text(
                "Aucune notification",
              ),
            )

          : ListView.builder(

              itemCount:
                  notifications.length,

              itemBuilder:
                  (
                    context,
                    index,
                  ) {

                final item =
                    notifications[index];

                return Card(

                  margin:
                      const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),

                  child: ListTile(

                    leading: Icon(
                      _getIcon(
                        item["type"],
                      ),
                      color: _getColor(
                        item["type"],
                      ),
                    ),

                    title: Text(
                      item["title"],
                    ),

                    subtitle: Text(
                      item["message"],
                    ),

                    trailing:
                        const Icon(
                      Icons
                          .arrow_forward_ios,
                      size: 16,
                    ),

                    onTap: () {
                      _openNotification(
                        item,
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
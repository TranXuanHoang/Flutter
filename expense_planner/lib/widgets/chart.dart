import 'package:expense_planner/widgets/chart_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(/*Days of Week*/ 7, (index) {
      // Find the most recent day-th
      var weekday = DateTime.now().subtract(Duration(days: index));

      var totalSum = 0.0;

      // Calculate total amount of each recent day-th
      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekday.day &&
            recentTransactions[i].date.month == weekday.month &&
            recentTransactions[i].date.year == weekday.year) {
          totalSum += recentTransactions[i].amount;
        }
      }

      // Return a map object
      return {
        'day': DateFormat.E().format(weekday),
        'amount': totalSum,
      };
    }).reversed.toList();
  }

  double get totalSpendingAmount {
    return groupedTransactionValues.fold(0, (sum, tx) {
      return sum + tx['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(20),
      elevation: 6,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            ...groupedTransactionValues.map((transaction) {
              return Flexible(
                // Usse Flexible with FlexFit.tight to force ChartBar flexes in its available space
                fit: FlexFit.tight,
                child: ChartBar(
                  dateLabel: transaction['day'],
                  totalAmount: transaction['amount'],
                  spendingPercent: totalSpendingAmount == 0.0
                      ? 0
                      : (transaction['amount'] as double) / totalSpendingAmount,
                ),
              );
            }).toList()
          ],
          mainAxisAlignment: MainAxisAlignment.spaceAround,
        ),
      ),
    );
  }
}

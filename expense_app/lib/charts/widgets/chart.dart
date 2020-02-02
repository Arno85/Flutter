import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../transactions/models/transaction.dart';
import '../models/ChartColumn.dart';
import 'chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;
  static const maxPerDay = 250.0;

  Chart(this.recentTransactions);

  List<ChartColumn> get groupedTransactionValues {
    return List.generate(7, (index) {
      final currentDate = DateTime.now().subtract(Duration(days: index));
      final formatedDay = DateFormat.E().format(currentDate).substring(0, 1);
      var totalSum = 0.0;

      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == currentDate.day &&
            recentTransactions[i].date.month == currentDate.month &&
            recentTransactions[i].date.year == currentDate.year) {
          totalSum += recentTransactions[i].amount;
        }
      }

      return ChartColumn(day: formatedDay, currentDate: currentDate, totalSum: totalSum);
    }).reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(     
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                label: data.day,
                spendingAmount: data.totalSum,
                spendingPctOfTotal:
                    data.totalSum >= maxPerDay ? 1.0 : data.totalSum / maxPerDay,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

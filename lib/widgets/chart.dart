import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'chart_bar.dart';
import '../models/transactions.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      var totalAmount = 0.0;
      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalAmount += recentTransactions[i].amount;
        }
      }
      // print('${DateFormat.E().format(weekDay)}, ${totalAmount}');
      return {'Day': DateFormat.E().format(weekDay), 'Amount': totalAmount};
    }).reversed.toList();
  }

  double get totalspending {
    return groupedTransactionValues.fold(0.0, (previousValue, element) {
      return previousValue += element['Amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(groupedTransactionValues);
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues.map((tx) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                tx['Day'],
                tx['Amount'],
                totalspending == 0.0
                    ? 0.0
                    : (tx['Amount'] as double) / totalspending,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

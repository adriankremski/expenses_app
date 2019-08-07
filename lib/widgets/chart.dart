import 'package:expenses_app/models/transaction.dart';
import 'package:expenses_app/widgets/chart_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChartWidget extends StatelessWidget {
  final List<Transaction> recentTransactions;

  const ChartWidget(this.recentTransactions);

  List<TransactionChartData> get groupedTransactionsValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );

      double totalPrice = 0.0;

      for (var i = 0; i < this.recentTransactions.length; ++i) {
        final transaction = recentTransactions[i];

        if (transaction.date.day == weekDay.day &&
            transaction.date.month == weekDay.month &&
            transaction.date.year == weekDay.year) {
          totalPrice += transaction.price;
        }
      }

      return TransactionChartData(
          DateFormat.E().format(weekDay).substring(0, 1), totalPrice);
    });
  }

  double get totalWeekSpending {
    return groupedTransactionsValues.fold(0.0, (sum, item) {
      return sum + item.totalPrice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Container(
          padding: EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: groupedTransactionsValues.map((transaction) {
              final spendingPercentage = totalWeekSpending == 0
                  ? 0.0
                  : transaction.totalPrice / totalWeekSpending;

              return Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: ChartBar(transaction.dayName, transaction.totalPrice,
                      spendingPercentage));
            }).toList(),
          )),
    );
  }
}

class TransactionChartData {
  final String dayName;
  final double totalPrice;

  TransactionChartData(this.dayName, this.totalPrice);
}

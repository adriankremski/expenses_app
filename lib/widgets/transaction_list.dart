import 'package:expenses_app/models/transaction.dart';
import 'package:expenses_app/widgets/transaction_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TransactionListWidget extends StatelessWidget {
  final List<Transaction> userTransactions;
  final Function deleteTransaction;

  const TransactionListWidget(this.userTransactions, this.deleteTransaction);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: userTransactions.isEmpty
            ? LayoutBuilder(builder: (context, constraints) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text("No transactionas added yet!",
                        style: Theme.of(context).textTheme.title),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: constraints.maxHeight * 0.6,
                      child: Image.asset(
                        "assets/images/waiting.png",
                        fit: BoxFit.contain,
                      ),
                    )
                  ],
                );
              })
            : ListView.builder(
                itemBuilder: (context, position) {
                  final transaction = userTransactions[position];

                  return new TransactionItem(
                    key: ValueKey(transaction.id),
                    userTransaction: transaction,
                    deleteTransaction: () =>
                        deleteTransaction(transaction.id),
                  );
                },
                itemCount: userTransactions.length));
  }
}

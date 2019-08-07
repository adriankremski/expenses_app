import 'package:expenses_app/widgets/chart.dart';
import 'package:expenses_app/widgets/new_transaction.dart';
import 'package:expenses_app/widgets/transaction_list.dart';
import 'package:flutter/material.dart';

import 'models/transaction.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
          primarySwatch: Colors.lightBlue,
          fontFamily: "Quicksand",
          textTheme: ThemeData.light().textTheme.copyWith(
              button: TextStyle(color: Colors.white),
              title: TextStyle(
                  fontFamily: "OpenSans",
                  fontWeight: FontWeight.bold,
                  fontSize: 18)),
          appBarTheme: AppBarTheme(
              textTheme: ThemeData.light().textTheme.copyWith(
                  title: TextStyle(
                      fontFamily: "OpenSans",
                      fontWeight: FontWeight.bold,
                      fontSize: 20))),
          accentColor: Colors.yellow),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    Transaction(
        id: DateTime.now().toString(),
        title: "1. New shoes",
        price: 69.99,
        date: DateTime.now()),
    Transaction(
        id: DateTime.now().toString(),
        title: "2. New shoes",
        price: 69.99,
        date: DateTime.now()),
    Transaction(
        id: DateTime.now().toString(),
        title: "3. New shoes",
        price: 69.99,
        date: DateTime.now()),
    Transaction(
        id: DateTime.now().toString(),
        title: "4. New shoes",
        price: 69.99,
        date: DateTime.now()),
    Transaction(
        id: DateTime.now().toString(),
        title: "5. New shoes",
        price: 69.99,
        date: DateTime.now()),
    Transaction(
        id: DateTime.now().toString(),
        title: "6. New shoes",
        price: 69.99,
        date: DateTime.now()),
  ];

  bool _showChart = false;

  List<Transaction> get recentTransactions {
    return _userTransactions.where((transaction) {
      return transaction.date
          .isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _addNewTransaction(String title, double price, DateTime chosenDate) {
    final newTransaction = Transaction(
        id: DateTime.now().toString(),
        title: title,
        price: price,
        date: chosenDate);

    setState(() {
      _userTransactions.add(newTransaction);
    });
  }

  void startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (builderContext) {
          return NewTransactionWidget(addTransaction: _addNewTransaction);
        });
  }

  void _deleteTransaction(String transactionId) {
    setState(() {
      _userTransactions.removeWhere((transaction) {
        return transaction.id == transactionId;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final appBar = AppBar(
      title: Text('Personal Expenses'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            startAddNewTransaction(context);
          },
        )
      ],
    );

    final transactionsListWidget = Container(
        height: (MediaQuery.of(context).size.height -
                appBar.preferredSize.height -
                MediaQuery.of(context).padding.top) *
            0.7,
        child: TransactionListWidget(_userTransactions, _deleteTransaction));

    final chartWidget = Container(
        height: (MediaQuery.of(context).size.height -
                appBar.preferredSize.height -
                MediaQuery.of(context).padding.top) *
            (isLandscape ? 0.7 : 0.3),
        child: ChartWidget(recentTransactions));

    final portraitWidgets = [chartWidget, transactionsListWidget];

    final landscapeWidgets = [
      Row(
        children: <Widget>[
          Text('Show Chart'),
          Switch(
            value: _showChart,
            onChanged: (value) {
              setState(() {
                _showChart = value;
              });
            },
          )
        ],
      ),
      _showChart ? chartWidget : transactionsListWidget,
    ];

    return Scaffold(
        appBar: appBar,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: !isLandscape ? portraitWidgets : landscapeWidgets,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            startAddNewTransaction(context);
          },
        ));
  }
}

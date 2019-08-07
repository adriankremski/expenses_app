import 'package:expenses_app/models/transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    Key key,
    @required this.userTransaction,
    this.deleteTransaction,
  }) : super(key: key);

  final Transaction userTransaction;
  final Function deleteTransaction;

  Widget createDeleteButton(BuildContext context, Function onPressed) {
    final wideScreen = MediaQuery.of(context).size.width > 360;
    final deleteButton = wideScreen
        ? FlatButton.icon(
            onPressed: onPressed,
            color: Theme.of(context).errorColor,
            icon: Icon(Icons.delete),
            label: Text("Delete"))
        : IconButton(
            icon: Icon(Icons.delete),
            color: Theme.of(context).errorColor,
            onPressed: onPressed);

    return deleteButton;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      title: Text(
        "${userTransaction.title}",
        style: Theme.of(context).textTheme.title,
      ),
      subtitle: Text(
        "${DateFormat('dd MMM, yy').format(userTransaction.date)}",
        style: Theme.of(context).textTheme.body1,
      ),
      leading: CircleAvatar(
        radius: 30,
        child: FittedBox(
            child: Padding(
                padding: EdgeInsets.all(6),
                child: Text("${userTransaction.price}",
                    style: TextStyle(fontSize: 12)))),
      ),
      trailing: createDeleteButton(context, deleteTransaction),
    ));
  }
}

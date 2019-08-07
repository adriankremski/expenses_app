import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransactionWidget extends StatefulWidget {
  final Function addTransaction;

  NewTransactionWidget({@required this.addTransaction});

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransactionWidget> {
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  DateTime _chosenDate = null;

  void _submitData() {
    if (_priceController.text.isEmpty) {
      return;
    }

    final enteredTitle = _titleController.text;
    final enteredPrice = double.parse(_priceController.text);

    if (enteredTitle.isEmpty || enteredPrice <= 0 || _chosenDate == null) {
      return;
    }

    widget.addTransaction(enteredTitle, enteredPrice, _chosenDate);

    Navigator.of(context).pop();
  }

  void _showDatePicker(BuildContext context) {
    final dateFuture = showDatePicker(
        context: context,
        lastDate: DateTime.now().add(Duration(days: 1)),
        firstDate: DateTime.now().subtract(Duration(days: 365)),
        initialDate: DateTime.now());
    dateFuture.then((date) {
      if (date != null) {
        setState(() {
          _chosenDate = date;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
          elevation: 5,
          child: Container(
            padding: EdgeInsets.only(
                top: 10,
                left: 10,
                right: 10,
                bottom: MediaQuery.of(context).viewInsets.bottom + 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(labelText: "Title"),
                  controller: _titleController,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Price"),
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  onSubmitted: (_) => _submitData(),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Text(_chosenDate == null
                              ? "No date chosen!"
                              : "Picked date: ${DateFormat.yMd().format(_chosenDate)}")),
                      FlatButton(
                        textColor: Theme.of(context).primaryColor,
                        child: Text('Choose Date',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        onPressed: () {
                          _showDatePicker(context);
                        },
                      )
                    ],
                  ),
                ),
                RaisedButton(
                  child: Text("Add transaction"),
                  color: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).buttonColor,
                  onPressed: _submitData,
                )
              ],
            ),
          )),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;
  final Function deleteTransactionHandler;

  TransactionCard(this.transaction, this.deleteTransactionHandler);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      child: Row(
        children: <Widget>[
          Container(
            width: 60,
            height: 60,
            padding: EdgeInsets.only(top: 5, bottom: 5),
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColorDark,
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).primaryColorDark,
                width: 2,
              ),
            ),
            child: FittedBox(
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Text(
                  '\$${transaction.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).textTheme.button.color),
                ),
              ),
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  transaction.title,
                  style: Theme.of(context).textTheme.title,
                ),
                Text(
                  DateFormat('yyyy-MM-dd').format(transaction.date),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                )
              ],
            ),
          ),
          MediaQuery.of(context).size.width > 460
              ? Flexible(
                  fit: FlexFit.tight,
                  flex: 2,
                  child: FlatButton.icon(
                    icon: Icon(Icons.delete),
                    textColor: Theme.of(context).errorColor,
                    label: Text('Delete', style: TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: () => deleteTransactionHandler(transaction.id),
                  ),
                )
              : Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: IconButton(
                    icon: Icon(Icons.delete),
                    color: Theme.of(context).errorColor,
                    onPressed: () => deleteTransactionHandler(transaction.id),
                  ),
                )
        ],
      ),
    );
  }
}

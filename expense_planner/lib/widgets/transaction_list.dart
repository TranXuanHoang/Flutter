import 'package:flutter/material.dart';

import './transaction_item.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTransactionHandler;

  TransactionList({this.transactions, this.deleteTransactionHandler});

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 800,
      child: transactions.isEmpty
          ? LayoutBuilder(
              builder: (context, constrains) {
                return Column(
                  children: <Widget>[
                    Container(
                      height: constrains.maxHeight * 0.1,
                      child: Text(
                        'No transactions added yet',
                        style: Theme.of(context).textTheme.title,
                      ),
                    ),
                    SizedBox(
                      height: constrains.maxHeight * 0.02,
                    ),
                    Container(
                      height: constrains.maxHeight * 0.85,
                      child: Image.asset("assets/images/waiting.png"),
                    ),
                  ],
                );
              },
            )
          : ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                return TransactionItem(
                  transaction: transactions[index],
                  deleteTransactionHandler: deleteTransactionHandler,
                );
              },
            ),
    );
  }
}

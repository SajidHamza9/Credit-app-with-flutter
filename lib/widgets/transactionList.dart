import 'package:credit_app/providers/clients.dart';
import 'package:credit_app/widgets/clientItem.dart';
import 'package:credit_app/widgets/transactionItem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as String;
    final clients = Provider.of<Clients>(context);
    final transactions = clients.getTransactionsById(args);

    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 5),
      separatorBuilder: (context, index) {
        return Divider();
      },
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        return TransactionItem(transactions[index]);
      },
    );
  }
}

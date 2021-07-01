import 'package:credit_app/models/transaction.dart';
import 'package:credit_app/models/enums.dart';
import 'package:credit_app/providers/clients.dart';
import 'package:credit_app/screens/newTransactionScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TransactionItem extends StatelessWidget {
  final Transaction _transaction;

  TransactionItem(this._transaction);
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as String;
    final clients = Provider.of<Clients>(context, listen: false);

    return Dismissible(
      direction: DismissDirection.endToStart,
      onDismissed: (direction) async {
        if (direction == DismissDirection.endToStart) {
          await clients.deleteTransaction(args, _transaction.id);
        }
      },
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Are you sure?'),
                  content: Text('Do you want to remove this transaction?'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop(false);
                        },
                        child: Text('Cancel')),
                    TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop(true);
                        },
                        child: Text('Confirm')),
                  ],
                ));
      },
      background: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: Colors.red),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        padding: EdgeInsets.only(right: 8),
        alignment: Alignment.centerRight,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      key: ValueKey(_transaction.id),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ListTile(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewTransactionScreen({
                    'clientId': args,
                    'type': ScreenType.UPDATE,
                    'transaction': _transaction
                  }),
                ));
          },
          trailing: Text(
            '${_transaction.montant} DH',
            style: TextStyle(
                color: _transaction.type == Type.CASH_IN
                    ? Colors.green
                    : Colors.red,
                fontSize: 15,
                fontWeight: FontWeight.bold),
          ),
          horizontalTitleGap: 6,
          contentPadding: EdgeInsets.symmetric(horizontal: 0),
          title: Text(
            DateFormat('dd/MM/yyyy').format(_transaction.date),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
              _transaction.type == Type.CASH_IN ? 'Payé' : 'Reste à payer'),
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).primaryColor,
            child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 26,
                child: _transaction.type == Type.CASH_OUT
                    ? Icon(Icons.arrow_upward)
                    : Icon(Icons.arrow_downward)),
          ),
        ),
      ),
    );
  }
}

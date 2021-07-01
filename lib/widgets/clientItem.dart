import 'package:credit_app/models/enums.dart';
import 'package:credit_app/providers/clients.dart';
import 'package:credit_app/screens/profileScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClientItem extends StatelessWidget {
  final String id;
  final String name;
  final String phoneNumber;

  ClientItem(this.id, this.name, this.phoneNumber);
  @override
  Widget build(BuildContext context) {
    final clients = Provider.of<Clients>(context);
    final balance = clients.getBalanceById(id);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ListTile(
        onTap: () {
          Navigator.pushNamed(context, ProfileScreen.routeName, arguments: id);
          FocusScope.of(context).requestFocus(FocusNode());
        },
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${balance['montant']} DH',
              style: TextStyle(
                  color: clients.getBalanceById(id)['type'] == Type.CASH_IN
                      ? Colors.green
                      : Colors.red,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              balance['type'] == Type.CASH_IN ? 'Payé' : 'Reste à payer',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),
          ],
        ),
        horizontalTitleGap: 6,
        contentPadding: EdgeInsets.symmetric(horizontal: 0),
        title: FittedBox(
          alignment: Alignment.centerLeft,
          fit: BoxFit.scaleDown,
          child: Text(
            name,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        subtitle: Text(clients.getDateById(id)),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          radius: 30,
          child: Text(
            name[0].toUpperCase(),
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

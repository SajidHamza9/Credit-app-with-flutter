import 'package:credit_app/providers/clients.dart';
import 'package:credit_app/widgets/clientItem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClientList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final clients = Provider.of<Clients>(context);
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 5),
      separatorBuilder: (context, index) {
        return Divider();
      },
      itemCount: clients.clients.length,
      itemBuilder: (context, index) {
        return ClientItem(clients.clients[index].id,
            clients.clients[index].name, clients.clients[index].phoneNumber);
      },
    );
  }
}

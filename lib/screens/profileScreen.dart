import 'package:credit_app/models/enums.dart';
import 'package:credit_app/models/transactionsPdf.dart';
import 'package:credit_app/providers/clients.dart';
import 'package:credit_app/screens/newTransactionScreen.dart';
import 'package:credit_app/services/pdfGenerator.dart';
import 'package:credit_app/services/pdfIO.dart';
import 'package:credit_app/widgets/headerProfile.dart';
import 'package:credit_app/widgets/transactionList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = '/profile';
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as String;
    final clients = Provider.of<Clients>(context);

    final appBar = AppBar(
      elevation: 0.0,
      actions: [
        IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewTransactionScreen({
                      'clientId': args,
                      'type': ScreenType.ADD,
                    }),
                  ));
            },
            icon: Icon(Icons.add)),
        PopupMenuButton(
          onSelected: (int value) async {
            showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                      title: Text('Are you sure?'),
                      content: Text(
                          'Do you want to remove ${value == 1 ? 'this client' : 'all transactions'}?'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop(false);
                            },
                            child: Text('Cancel')),
                        TextButton(
                            onPressed: () async {
                              Navigator.of(ctx).pop(true);
                              if (value == 1) {
                                Navigator.pop(context);
                                await Provider.of<Clients>(context,
                                        listen: false)
                                    .deleteClient(args);
                              } else {
                                await Provider.of<Clients>(context,
                                        listen: false)
                                    .deleteAllTransactions(args);
                              }
                            },
                            child: Text('Confirm')),
                      ],
                    ));
          },
          icon: Icon(Icons.more_vert),
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: Text('Supprimer le client'),
                value: 1,
              ),
              PopupMenuItem(
                child: Text('Supprimer toutes les transactions'),
                value: 2,
              )
            ];
          },
        ),
      ],
    );
    final mediaQuery = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top -
        270;
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderProfile(),
            SizedBox(
              height: mediaQuery * 0.03,
            ),
            Container(
              height: 40,
              padding: EdgeInsets.only(left: 15),
              child: Row(
                children: [
                  Text(
                    'Transactions (${clients.getTransactionsById(args).length})',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 19),
                  ),
                  Spacer(),
                  IconButton(
                      onPressed: () async {
                        TransactionsPdf pdfData =
                            Provider.of<Clients>(context, listen: false)
                                .getTransactionsPdf(args);

                        final pdfFile = await PdfGenerator.generateTr(pdfData);
                        await PdfIO.openFile(pdfFile);
                      },
                      icon: Icon(Icons.picture_as_pdf)),
                ],
              ),
            ),
            SizedBox(
              height: mediaQuery * 0.03,
            ),
            Container(
              height: mediaQuery * 0.94,
              child: TransactionList(),
            )
          ],
        ),
      ),
    );
  }
}

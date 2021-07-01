import 'package:credit_app/models/contact.dart';
import 'package:credit_app/models/enums.dart';
import 'package:credit_app/providers/clients.dart';
import 'package:credit_app/screens/newClientScreen.dart';
import 'package:credit_app/services/launcher.dart';
import 'package:credit_app/services/sms.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HeaderProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as String;
    final clientInfo = Provider.of<Clients>(context).getClientInfoById(args);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      color: Theme.of(context).primaryColor,
      width: double.infinity,
      height: 230,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Color.fromRGBO(245, 244, 246, 1),
                  child: Text(
                    clientInfo['name'][0].toUpperCase(),
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w900),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      clientInfo['name'],
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, NewClientScreen.routeName,
                            arguments: {
                              'clientId': args,
                              'contact': Contact(
                                  name: clientInfo['name'],
                                  phoneNumber: clientInfo['phoneNumber']),
                              'type': ScreenType.UPDATE,
                            });
                      },
                      child: Text(
                        'Modifier le profile',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                            fontSize: 13),
                      ),
                    )
                  ],
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      iconSize: 20,
                      color: Colors.white,
                      icon: Icon(Icons.phone),
                      onPressed: () {
                        Launcher.makePhoneCall(
                            'tel:${clientInfo['phoneNumber']}');
                      },
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      iconSize: 20,
                      color: Colors.white,
                      icon: Icon(Icons.message),
                      onPressed: () async {
                        await SmsService.sendSmsMsg(
                            "Hello ${clientInfo['name']}",
                            [clientInfo['phoneNumber']]);
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Payé',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      '${clientInfo['cashIn']} DH',
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Reste à payer',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      '${clientInfo['cashOut']} DH',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Divider(
                  color: Colors.white,
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Balance',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      '${clientInfo['balance']} DH',
                      style: TextStyle(
                          color: clientInfo['balanceType'] == Type.CASH_IN
                              ? Colors.green
                              : Colors.red,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

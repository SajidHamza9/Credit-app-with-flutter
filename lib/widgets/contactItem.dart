import 'package:credit_app/models/contact.dart';
import 'package:credit_app/models/enums.dart';
import 'package:credit_app/screens/newClientScreen.dart';
import 'package:flutter/material.dart';

class ContactItem extends StatelessWidget {
  final Contact _contact;

  ContactItem(this._contact);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ListTile(
        onTap: () {
          Navigator.pushNamed(context, NewClientScreen.routeName,
              arguments: {'contact': _contact, 'type': ScreenType.ADD});
          FocusScope.of(context).requestFocus(FocusNode());
        },
        horizontalTitleGap: 6,
        contentPadding: EdgeInsets.symmetric(horizontal: 0),
        title: Text(
          _contact.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(_contact.phoneNumber),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          radius: 30,
          child: Text(
            _contact.name[0].toUpperCase(),
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

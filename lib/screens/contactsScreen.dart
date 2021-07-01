import 'package:contacts_service/contacts_service.dart';
import 'package:credit_app/models/contact.dart' as cnt;
import 'package:credit_app/widgets/contactItem.dart';
import 'package:flutter/material.dart';

class ContactScreen extends StatefulWidget {
  static const routeName = '/contacts';

  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  Iterable<Contact> _contacts = [];
  Iterable<Contact> _contactsSearch = [];

  @override
  void initState() {
    getContacts();
    super.initState();
  }

  search(String text) {
    setState(() {
      if (text.trim().isEmpty) {
        _contactsSearch = _contacts;
        return;
      }
      _contactsSearch = _contacts.where((contact) {
        return contact.displayName
            ?.toLowerCase()
            .contains(text.trim().toLowerCase()) as bool;
      });
    });
  }

  Future<void> getContacts() async {
    try {
      final Iterable<Contact> contacts =
          await ContactsService.getContacts(withThumbnails: false);
      setState(() {
        _contacts = contacts;
        _contactsSearch = contacts;
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text('Contacts', style: TextStyle(fontSize: 16)),
    );
    final mediaQuery = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top -
        80;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: appBar,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Container(
                height: 50,
                child: TextField(
                  onChanged: (value) => search(value),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    hintText: 'Recherche',
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Icon(Icons.search),
                    ),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                  ),
                ),
              ),
            ),
            Container(
              height: mediaQuery * 1,
              child: ListView.separated(
                padding: EdgeInsets.symmetric(vertical: 5),
                separatorBuilder: (context, index) {
                  return Divider();
                },
                itemCount: _contactsSearch.length,
                itemBuilder: (context, index) {
                  Contact contact = _contactsSearch.elementAt(index);
                  String name = contact.displayName as String;
                  String phoneNumber = contact.phones?.first.value as String;
                  return ContactItem(
                      cnt.Contact(name: name, phoneNumber: phoneNumber));
                },
              ),
            ),
          ],
        ));
  }
}

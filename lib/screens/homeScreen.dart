import 'package:credit_app/models/contact.dart';
import 'package:credit_app/models/enums.dart';
import 'package:credit_app/providers/auth.dart';
import 'package:credit_app/providers/clients.dart';
import 'package:credit_app/models/pdfData.dart';
import 'package:credit_app/screens/landingScreen.dart';
import 'package:credit_app/services/pdfGenerator.dart';
import 'package:credit_app/services/pdfIO.dart';
import 'package:credit_app/screens/contactsScreen.dart';
import 'package:credit_app/screens/newClientScreen.dart';
import 'package:credit_app/services/permission.dart';
import 'package:credit_app/widgets/clientList.dart';
import 'package:credit_app/widgets/header.dart';
import 'package:credit_app/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final searchController = TextEditingController();
  late Future<void> _loadData;

  Future askContactPermission(BuildContext context) async {
    final permission = await ContactPermission.getContactPermission();

    switch (permission) {
      case PermissionStatus.granted:
        Navigator.pushNamed(context, ContactScreen.routeName);
        break;
      case PermissionStatus.permanentlyDenied:
        break;
      default:
        print('TEST');
        break;
    }
  }

  void openBottomModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (bCtx) {
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 55),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, NewClientScreen.routeName,
                          arguments: {
                            'contact': Contact(),
                            'type': ScreenType.ADD
                          });
                    },
                    child: Text(
                      'Créer nouveau contact',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    )),
                SizedBox(
                  height: 10,
                ),
                OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                          color: Theme.of(context).primaryColor, width: 2),
                      minimumSize: Size(double.infinity, 55),
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                      await askContactPermission(context);
                    },
                    child: Text(
                      'Importer contact',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ))
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    _loadData = Provider.of<Clients>(context, listen: false)
        .loadData(Provider.of<Auth>(context, listen: false).userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      elevation: 0.0,
      title: Text(Provider.of<Auth>(context).userName),
      actions: [
        IconButton(
            onPressed: () {
              openBottomModal(context);
            },
            icon: Icon(Icons.person_add)),
        IconButton(
            onPressed: () async {
              await Provider.of<Auth>(context, listen: false).signOut();
              Navigator.pushReplacementNamed(context, LandingScreen.routeName);
            },
            icon: Icon(Icons.logout)),
      ],
    );
    final row = Row(
      children: [
        Expanded(
          child: TextField(
            controller: searchController,
            onChanged: (value) {
              Provider.of<Clients>(context, listen: false).searchValue = value;
            },
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
        Container(
          margin: EdgeInsets.only(left: 15),
          child: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(100)),
            onTap: () async {
              PdfData pdfData = Provider.of<Clients>(context, listen: false)
                  .getPdfData(
                      Provider.of<Auth>(context, listen: false).userName);
              final pdfFile = await PdfGenerator.generate(pdfData);
              await PdfIO.openFile(pdfFile);
            },
            child: Container(
              child: Icon(Icons.picture_as_pdf),
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).primaryColor, width: 0.5),
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
            ),
          ),
        ),
      ],
    );
    final mediaQuery = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top -
        210;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 160,
              child: Header(),
            ),
            SizedBox(
              height: mediaQuery * 0.03,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              alignment: Alignment.center,
              height: 50,
              child: row,
            ),
            SizedBox(
              height: mediaQuery * 0.03,
            ),
            Container(
              height: mediaQuery * 0.94,
              child: FutureBuilder(
                future: _loadData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Loading();
                  } else {
                    if (snapshot.error != null) {
                      return Center(
                        child: Text('ERROR'),
                      );
                    } else {
                      return ClientList();
                    }
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

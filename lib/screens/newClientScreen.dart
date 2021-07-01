import 'package:credit_app/models/enums.dart';
import 'package:credit_app/providers/auth.dart';
import 'package:credit_app/providers/clients.dart';
import 'package:credit_app/screens/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewClientScreen extends StatefulWidget {
  static const routeName = '/newClient';

  @override
  _NewClientScreenState createState() => _NewClientScreenState();
}

class _NewClientScreenState extends State<NewClientScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    nameController.text = args['contact'].name;
    phoneNumberController.text = args['contact'].phoneNumber;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          args['type'] == ScreenType.UPDATE
              ? 'Modifier un client'
              : 'Ajouter un client',
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(
                    Icons.person,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Nom du client',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                        fontSize: 18),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the name';
                  }
                  return null;
                },
                controller: nameController,
                decoration: InputDecoration(
                    labelText: 'Nom',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 1),
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(
                    Icons.phone,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Numero de telephone',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                        fontSize: 18),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the phone number';
                  }
                  return null;
                },
                controller: phoneNumberController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    labelText: 'Numero de telephone',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 1),
                    )),
              ),
              Spacer(),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 55),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (args['type'] == ScreenType.ADD) {
                        await Provider.of<Clients>(context, listen: false)
                            .addClient(
                                nameController.text,
                                phoneNumberController.text,
                                Provider.of<Auth>(context, listen: false)
                                    .userId);
                        Navigator.pushNamedAndRemoveUntil(
                            context, HomeScreen.routeName, (route) => false);
                      } else {
                        await Provider.of<Clients>(context, listen: false)
                            .updateClient(args['clientId'], nameController.text,
                                phoneNumberController.text);
                        Navigator.pop(context);
                      }
                    }
                  },
                  child: Text(
                    args['type'] == ScreenType.ADD ? 'Ajouter' : 'Modifier',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

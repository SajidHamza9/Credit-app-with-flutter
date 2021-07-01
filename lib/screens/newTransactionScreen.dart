import 'package:credit_app/models/enums.dart';
import 'package:credit_app/models/transaction.dart';
import 'package:credit_app/providers/clients.dart';
import 'package:credit_app/widgets/calculator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NewTransactionScreen extends StatefulWidget {
  static const routeName = '/newTransaction';
  final Map<String, dynamic> args;
  NewTransactionScreen(this.args);

  @override
  _NewTransactionScreenState createState() => _NewTransactionScreenState();
}

class _NewTransactionScreenState extends State<NewTransactionScreen> {
  Type type = Type.CASH_IN;
  List<bool> isSelected = [true, false];
  double montant = 0.0;
  String operation = '';
  DateTime date = DateTime.now();
  final remarqueController = TextEditingController();

  _showDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2021),
            lastDate: DateTime.now())
        .then((value) {
      if (value == null) {
        return;
      } else {
        setState(() {
          date = value;
        });
      }
    });
  }

  updateMontant(double montant) {
    setState(() {
      this.montant = montant;
    });
  }

  updateOperation(String operation) {
    setState(() {
      this.operation = operation;
    });
  }

  addNewTransaction(String clientId) async {
    await Provider.of<Clients>(context, listen: false)
        .addTransaction(clientId, montant, type, date, remarqueController.text);
  }

  updateTransaction(String clientId, String trId) {
    Transaction transaction = Transaction(
        id: trId,
        montant: montant,
        type: type,
        remarque: remarqueController.text,
        date: date);
    Provider.of<Clients>(context, listen: false)
        .updateTransaction(clientId, transaction);
  }

  @override
  void initState() {
    if (widget.args['type'] == ScreenType.UPDATE) {
      montant = widget.args['transaction'].montant;
      date = widget.args['transaction'].date;
      type = widget.args['transaction'].type;
      remarqueController.text = widget.args['transaction'].remarque;
      if (type == Type.CASH_OUT) {
        isSelected = [false, true];
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text(
        widget.args['type'] == ScreenType.UPDATE
            ? 'Modifier la transaction'
            : 'Ajouter une transaction',
        style: TextStyle(fontSize: 16),
      ),
      actions: [
        IconButton(
            onPressed: () async {
              if (montant <= 0) {
                final snackbar = SnackBar(
                  content: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      'Montant non valide',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  backgroundColor: Colors.white,
                  duration: Duration(seconds: 2),
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  behavior: SnackBarBehavior.floating,
                  shape: StadiumBorder(),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
                return;
              }
              if (widget.args['type'] == ScreenType.UPDATE) {
                await updateTransaction(
                    widget.args['clientId'], widget.args['transaction'].id);
              } else {
                await addNewTransaction(widget.args['clientId']);
              }
              Navigator.pop(context);
            },
            icon: Icon(Icons.save))
      ],
    );
    final mediaQuery = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Montant:',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '$montant DH',
                              style: TextStyle(
                                  color: type == Type.CASH_IN
                                      ? Colors.green
                                      : Colors.red,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            if (operation.isNotEmpty)
                              Text(
                                operation,
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: mediaQuery * 0.03,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Date:',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                        InkWell(
                          onTap: () {
                            _showDatePicker();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    color: Theme.of(context).primaryColor)),
                            padding: EdgeInsets.all(8),
                            child: Row(
                              children: [
                                Icon(Icons.event_available),
                                Text(DateFormat('dd/MM/yyyy').format(date),
                                    style: TextStyle(color: Colors.grey))
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: mediaQuery * 0.03,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Type:',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                        ToggleButtons(
                            borderRadius: BorderRadius.circular(5),
                            borderColor: Theme.of(context).primaryColor,
                            selectedBorderColor: type == Type.CASH_IN
                                ? Colors.green
                                : Colors.red,
                            fillColor: type == Type.CASH_IN
                                ? Colors.green
                                : Colors.red,
                            selectedColor: Colors.white,
                            onPressed: (int index) {
                              setState(() {
                                type =
                                    index == 0 ? Type.CASH_IN : Type.CASH_OUT;
                                print(type);
                                for (int i = 0; i < isSelected.length; i++) {
                                  if (i == index) {
                                    isSelected[i] = true;
                                  } else {
                                    isSelected[i] = false;
                                  }
                                }
                              });
                            },
                            children: [
                              Container(
                                  alignment: Alignment.center,
                                  width: 100,
                                  child: Text("Payé",
                                      style: TextStyle(fontSize: 15))),
                              Container(
                                  alignment: Alignment.center,
                                  width: 100,
                                  child: Text("Reste à payer",
                                      style: TextStyle(fontSize: 15))),
                            ],
                            isSelected: isSelected)
                      ],
                    ),
                    SizedBox(
                      height: mediaQuery * 0.03,
                    ),
                    Text(
                      'Remarque:',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    SizedBox(
                      height: mediaQuery * 0.03,
                    ),
                    TextField(
                      controller: remarqueController,
                      maxLines: 3,
                      decoration: InputDecoration(
                          labelText: 'Remarque',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(width: 1),
                          )),
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: mediaQuery * 0.45,
            child: Calculator(
              h: (mediaQuery * 0.45) / 5,
              w: MediaQuery.of(context).size.width / 4,
              operation: operation,
              updateMontant: updateMontant,
              updateOperation: updateOperation,
            ),
          )
        ],
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:credit_app/models/client.dart';
import 'package:credit_app/models/pdfClient.dart';
import 'package:credit_app/models/transaction.dart' as Tr;
import 'package:credit_app/models/enums.dart';
import 'package:credit_app/models/pdfData.dart';
import 'package:credit_app/models/transactionsPdf.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class Clients with ChangeNotifier {
  CollectionReference clientsCollection =
      FirebaseFirestore.instance.collection('clients');
  CollectionReference transactionsCollection =
      FirebaseFirestore.instance.collection('transactions');

  List<Client> _clients = [];
  List<Client> filtredClients = [];
  String value = '';

  set searchValue(String v) {
    value = v;
    notifyListeners();
  }

  void filter(Type value) {
    if (value == Type.ALL) {
      filtredClients = [..._clients];
    } else {
      filtredClients = _clients
          .where((client) => getBalanceById(client.id)['type'] == value)
          .toList();
    }
    notifyListeners();
  }

  Future<void> loadData(String userId) async {
    try {
      final List<Client> loadedClients = [];
      QuerySnapshot querySnapshot =
          await clientsCollection.where('userId', isEqualTo: userId).get();
      querySnapshot.docs.forEach((clientDoc) async {
        loadedClients.insert(
            0,
            Client(
                id: clientDoc.id,
                name: clientDoc['name'],
                phoneNumber: clientDoc['phoneNumber'],
                transactions: []));
      });
      await () async {
        await Future.forEach(loadedClients, (client) async {
          QuerySnapshot querySnapshot = await transactionsCollection
              .where('clientId', isEqualTo: (client as Client).id)
              .get();
          querySnapshot.docs.forEach((trDoc) {
            client.transactions.insert(
                0,
                Tr.Transaction(
                    date: trDoc['date'].toDate(),
                    id: trDoc.id,
                    montant: trDoc['montant'],
                    remarque: trDoc['remarque'],
                    type: trDoc['type'] ? Type.CASH_IN : Type.CASH_OUT));
          });
        });
      }();

      _clients = loadedClients;
      filtredClients = loadedClients;

      notifyListeners();
    } catch (error) {
      throw error.toString();
    }
  }

  List<Client> get clients {
    List<Client> list = [...filtredClients];
    if (value.isNotEmpty) {
      list = filtredClients
          .where((client) => client.name
              .toLowerCase()
              .trim()
              .contains(value.toLowerCase().trim()))
          .toList();
    }
    return list;
  }

  Map<String, dynamic> getBalanceById(String id) {
    int index = _clients.indexWhere((client) => client.id == id);
    double balance = 0.0;
    _clients[index].transactions.forEach((tr) {
      if (tr.type == Type.CASH_IN) {
        balance += tr.montant;
      } else {
        balance -= tr.montant;
      }
    });
    print(balance);
    return {
      'montant': balance.abs(),
      'type': balance < 0 ? Type.CASH_OUT : Type.CASH_IN,
    };
  }

  Map<String, double> getSum() {
    double cashIn = 0.0;
    double cashOut = 0.0;

    _clients.forEach((client) {
      Map<String, dynamic> balance = getBalanceById(client.id);
      if (balance['type'] == Type.CASH_IN) {
        cashIn += balance['montant'];
      } else {
        cashOut += balance['montant'];
      }
    });

    return {
      'cashIn': cashIn,
      'cashOut': cashOut,
    };
  }

  String getDateById(String id) {
    int index = _clients.indexWhere((client) => client.id == id);
    if (_clients[index].transactions.isEmpty) {
      return 'aucune transaction';
    }
    return DateFormat('dd/MM/yyyy')
        .format(_clients[index].transactions.first.date);
  }

  Future<void> addClient(String name, String phoneNumber, String userId) async {
    DocumentReference documentReference = await clientsCollection
        .add({'userId': userId, 'name': name, 'phoneNumber': phoneNumber});
    Client c = Client(
        id: documentReference.id,
        name: name,
        phoneNumber: phoneNumber,
        transactions: []);
    _clients.insert(0, c);
    notifyListeners();
  }

  List<Tr.Transaction> getTransactionsById(String id) {
    int index = _clients.indexWhere((client) => client.id == id);
    return index < 0 ? [] : _clients[index].transactions;
  }

  Map<String, dynamic> getClientInfoById(String id) {
    int index = _clients.indexWhere((client) => client.id == id);
    if (index < 0) {
      return {};
    }
    double balance = 0.0;
    double cashIn = 0.0;
    double cashOut = 0.0;

    _clients[index].transactions.forEach((tr) {
      if (tr.type == Type.CASH_IN) {
        cashIn += tr.montant;
      } else {
        cashOut += tr.montant;
      }
    });
    balance = cashIn - cashOut;

    return {
      'name': _clients[index].name,
      'phoneNumber': _clients[index].phoneNumber,
      'balance': balance.abs(),
      'balanceType': balance < 0 ? Type.CASH_OUT : Type.CASH_IN,
      'cashIn': cashIn,
      'cashOut': cashOut,
    };
  }

  Future<void> addTransaction(String clientId, double montant, Type type,
      DateTime date, String remarque) async {
    DocumentReference documentReference = await transactionsCollection.add({
      'clientId': clientId,
      'montant': montant,
      'type': type == Type.CASH_IN ? true : false,
      'remarque': remarque,
      'date': date
    });
    int index = _clients.indexWhere((client) => client.id == clientId);
    Tr.Transaction transaction = Tr.Transaction(
        id: documentReference.id,
        montant: montant,
        type: type,
        remarque: remarque,
        date: date);
    _clients[index].transactions.insert(0, transaction);
    notifyListeners();
  }

  Future<void> updateTransaction(
      String clientId, Tr.Transaction transaction) async {
    await transactionsCollection
        .doc(transaction.id)
        .update(transaction.toMap());
    int index = _clients.indexWhere((client) => client.id == clientId);
    int trIndex = _clients[index]
        .transactions
        .indexWhere((tr) => tr.id == transaction.id);
    _clients[index].transactions[trIndex] = transaction;
    notifyListeners();
  }

  Future<void> deleteTransaction(String clientId, String trId) async {
    await transactionsCollection.doc(trId).delete();
    int index = _clients.indexWhere((client) => client.id == clientId);
    _clients[index].transactions.removeWhere((tr) => tr.id == trId);
    notifyListeners();
  }

  Future<void> updateClient(
      String clientId, String name, String phoneNumber) async {
    await clientsCollection.doc(clientId).update({
      'name': name,
      'phoneNumber': phoneNumber,
    });
    int index = _clients.indexWhere((client) => client.id == clientId);

    _clients[index].name = name;
    _clients[index].phoneNumber = phoneNumber;
    notifyListeners();
  }

  Future<void> deleteClient(String clientId) async {
    await clientsCollection.doc(clientId).delete();
    _clients.removeWhere((client) => client.id == clientId);
    notifyListeners();
  }

  Future<void> deleteAllTransactions(String clientId) async {
    QuerySnapshot querySnapshot = await transactionsCollection
        .where('clientId', isEqualTo: clientId)
        .get();
    querySnapshot.docs.forEach((doc) {
      doc.reference.delete();
    });

    () async {
      await Future.forEach(querySnapshot.docs, (doc) async {
        await (doc as QueryDocumentSnapshot).reference.delete();
      });
    }();
    int index = _clients.indexWhere((client) => client.id == clientId);
    _clients[index].transactions.clear();
    notifyListeners();
  }

  List<PdfClient> getPdfClients() {
    List<PdfClient> list = [];
    _clients.forEach((client) {
      PdfClient pdfClient =
          PdfClient(name: client.name, phone: client.phoneNumber);
      Map<String, dynamic> balance = getBalanceById(client.id);
      if (balance['type'] == Type.CASH_IN) {
        pdfClient.cashIn = balance['montant'];
      } else {
        pdfClient.cashOut = balance['montant'];
      }

      list.add(pdfClient);
    });
    return list;
  }

  PdfData getPdfData(String name) {
    List<PdfClient> list = getPdfClients();
    Map<String, double> total = getSum();
    PdfData pdfData = PdfData(
        name: name,
        date: DateTime.now(),
        totalCashOut: total['cashOut'] as double,
        totalChashIn: total['cashIn'] as double,
        pdfClients: list);
    return pdfData;
  }

  TransactionsPdf getTransactionsPdf(String clientId) {
    List<Tr.Transaction> transactions = getTransactionsById(clientId);
    Map<String, dynamic> info = getClientInfoById(clientId);
    return TransactionsPdf(
        name: info['name'],
        phoneNumber: info['phoneNumber'],
        date: DateTime.now(),
        cashIn: info['cashIn'],
        cashOut: info['cashOut'],
        balance: info['balance'],
        balanceType: info['balanceType'],
        transactions: transactions);
  }
}

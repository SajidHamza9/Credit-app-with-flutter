import 'package:credit_app/models/transaction.dart';

class Client {
  String id;
  String name;
  String phoneNumber;
  List<Transaction> transactions;

  Client({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.transactions,
  });
}

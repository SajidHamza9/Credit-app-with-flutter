import 'package:credit_app/models/enums.dart';
import 'package:credit_app/models/transaction.dart';

class TransactionsPdf {
  String name;
  String phoneNumber;
  DateTime date;
  double cashIn;
  double cashOut;
  double balance;
  Type balanceType;
  List<Transaction> transactions;

  TransactionsPdf(
      {required this.name,
      required this.phoneNumber,
      required this.date,
      required this.cashIn,
      required this.cashOut,
      required this.balance,
      required this.balanceType,
      required this.transactions});
}

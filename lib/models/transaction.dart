import 'package:credit_app/models/enums.dart';
import 'package:credit_app/screens/newTransactionScreen.dart';

class Transaction {
  String id;
  double montant;
  var type;
  String remarque;
  DateTime date;

  Transaction(
      {required this.id,
      required this.montant,
      required this.type,
      required this.remarque,
      required this.date});

  Map<String, dynamic> toMap() {
    return {
      'montant': montant,
      'type': type == Type.CASH_IN ? true : false,
      'remarque': remarque,
      'date': date,
    };
  }
}

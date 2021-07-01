import 'package:credit_app/models/enums.dart';
import 'package:credit_app/models/pdfClient.dart';

class PdfData {
  final String name;
  final DateTime date;
  final double totalChashIn;
  final double totalCashOut;
  final List<PdfClient> pdfClients;

  PdfData({
    required this.name,
    required this.date,
    required this.totalCashOut,
    required this.totalChashIn,
    required this.pdfClients,
  });

  Map<String, dynamic> get balance {
    double b = totalChashIn - totalCashOut;

    return {'montant': b.abs(), 'type': b < 0 ? Type.CASH_OUT : Type.CASH_IN};
  }
}

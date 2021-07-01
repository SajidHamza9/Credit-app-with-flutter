import 'dart:io';
import 'package:credit_app/models/enums.dart';
import 'package:credit_app/models/pdfClient.dart';
import 'package:credit_app/models/transaction.dart';
import 'package:credit_app/models/transactionsPdf.dart';
import 'package:credit_app/services/pdfIO.dart';
import 'package:credit_app/models/pdfData.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfGenerator {
  static Future<File> generate(PdfData pdfData) async {
    final pdf = pw.Document();

    pdf.addPage(pw.MultiPage(
      header: (context) {
        return buildHeader(name: pdfData.name, date: pdfData.date);
      },
      build: (context) => [
        pw.SizedBox(height: 20),
        buildInfoSection(
            pdfData.totalChashIn, pdfData.totalCashOut, pdfData.balance),
        pw.SizedBox(height: 20),
        buildTable(pdfData.pdfClients)
      ],
    ));

    return PdfIO.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }

  static Future<File> generateTr(TransactionsPdf pdfData) async {
    final pdf = pw.Document();

    pdf.addPage(pw.MultiPage(
      header: (context) {
        return buildHeader(
            name: pdfData.name,
            date: pdfData.date,
            phoneNumber: pdfData.phoneNumber);
      },
      build: (context) => [
        pw.SizedBox(height: 20),
        buildInfoSection(pdfData.cashIn, pdfData.cashOut,
            {'montant': pdfData.balance, 'type': pdfData.balanceType}),
        pw.SizedBox(height: 20),
        buildTrTable(pdfData.transactions)
      ],
    ));

    return PdfIO.saveDocument(
        name: '${pdfData.name}-${pdfData.date.millisecond}.pdf', pdf: pdf);
  }

  static pw.Widget buildTrTable(List<Transaction> list) {
    final headers = ['Date', 'Payé', 'Reste à payer'];
    final data = list.map((e) {
      return [
        DateFormat('dd/MM/yyyy').format(e.date),
        e.type == Type.CASH_IN ? '${e.montant} DH' : '-',
        e.type == Type.CASH_OUT ? '${e.montant} DH' : '-'
      ];
    }).toList();
    return pw.Table.fromTextArray(
        headers: headers,
        data: data,
        border: null,
        cellHeight: 30,
        cellStyle: pw.TextStyle(fontSize: 10),
        cellAlignments: {
          0: pw.Alignment.centerLeft,
          1: pw.Alignment.center,
          2: pw.Alignment.center,
        },
        headerStyle: pw.TextStyle(
            fontWeight: pw.FontWeight.bold, color: PdfColors.white),
        headerDecoration: pw.BoxDecoration(color: PdfColor.fromHex('#76789D')));
  }

  static pw.Widget buildTable(List<PdfClient> list) {
    final headers = ['Client', 'Numero de telephone', 'Payé', 'Reste à payer'];
    final data = list
        .map((e) => [e.name, e.phone, '${e.cashIn} DH', '${e.cashOut} DH'])
        .toList();
    return pw.Table.fromTextArray(
        headers: headers,
        data: data,
        border: null,
        cellHeight: 30,
        cellStyle: pw.TextStyle(fontSize: 10),
        cellAlignments: {
          0: pw.Alignment.centerLeft,
          1: pw.Alignment.centerLeft,
          2: pw.Alignment.centerLeft,
          3: pw.Alignment.centerLeft
        },
        headerStyle: pw.TextStyle(
            fontWeight: pw.FontWeight.bold, color: PdfColors.white),
        headerDecoration: pw.BoxDecoration(color: PdfColor.fromHex('#76789D')));
  }

  static pw.Widget buildInfoSection(
      double cashIn, double cashOut, Map<String, dynamic> balance) {
    return pw.Container(
        width: double.infinity,
        child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Payé:', style: pw.TextStyle(fontSize: 10)),
                    pw.Text("$cashIn DH",
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.green,
                            fontSize: 10)),
                  ]),
              pw.SizedBox(height: 10),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Reste à payer:',
                        style: pw.TextStyle(fontSize: 10)),
                    pw.Text("$cashOut DH",
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.red,
                            fontSize: 10)),
                  ]),
              pw.SizedBox(height: 10),
              pw.Divider(height: 3, color: PdfColor.fromHex('#232343')),
              pw.SizedBox(height: 10),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Balance:', style: pw.TextStyle(fontSize: 10)),
                    pw.Text("${balance['montant']} DH",
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            color: balance['type'] == Type.CASH_IN
                                ? PdfColors.green
                                : PdfColors.red,
                            fontSize: 10)),
                  ])
            ]));
  }

  static pw.Widget buildHeader(
      {required String name, required DateTime date, String phoneNumber = ''}) {
    return pw.Container(
        padding: pw.EdgeInsets.all(20),
        child: pw
            .Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Rapport',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.white,
                        fontSize: 20)),
                pw.Text(name,
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.white,
                        fontSize: 15)),
              ]),
          pw.SizedBox(height: 10),
          pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(DateFormat('dd/MM/yyyy hh:mm').format(date),
                    style: pw.TextStyle(color: PdfColors.white, fontSize: 12)),
                pw.Text(phoneNumber,
                    style: pw.TextStyle(color: PdfColors.white, fontSize: 10)),
              ])
        ]),
        width: double.infinity,
        color: PdfColor.fromHex('#232343'));
  }
}

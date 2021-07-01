class PdfClient {
  final String name;
  final String phone;
  double cashIn;
  double cashOut;

  PdfClient({
    required this.name,
    required this.phone,
    this.cashIn = 0.0,
    this.cashOut = 0.0,
  });
}

import 'package:flutter_sms/flutter_sms.dart';

class SmsService {
  static Future<void> sendSmsMsg(String message, List<String> recipents) async {
    try {
      await sendSMS(message: message, recipients: recipents);
    } catch (error) {
      throw error;
    }
  }
}

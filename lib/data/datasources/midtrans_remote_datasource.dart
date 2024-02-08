import 'dart:convert';

import 'package:fic11_starter_pos/data/model/response/qris_response_model.dart';
import 'package:fic11_starter_pos/data/model/response/qris_status_response_model.dart';
import 'package:http/http.dart' as http;

class MidtransRemoteDatasource {
  String generateBasicAuthHeader(String serverKey) {
    final base64Credentials = base64Encode(utf8.encode(serverKey + ':'));
    final authHeader = 'Basic $base64Credentials';
    return authHeader;
  }

  Future<QrisResponseModel> generateQRCode(
      String orderId, int grossAmount) async {
    final headers = {
      'Accept': 'application/json',
      'Authorization':
          generateBasicAuthHeader('SB-Mid-server-QZ1Wc96q_oyicT_y_d-eGWLC'),
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'payment_type': 'gopay',
      'transaction_details': {
        'gross_amount': grossAmount,
        'order_id': orderId,
      }
    });

    final response = await http.post(
      Uri.parse('https://api.sandbox.midtrans.com/v2/charge'),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      return QrisResponseModel.fromJson(response.body);
    } else {
      throw Exception('Failed to generate QR code');
    }
  }

  Future<QrisStatusResponseModel> checkPaymentStatus(String orderId) async {
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization':
          generateBasicAuthHeader('SB-Mid-server-QZ1Wc96q_oyicT_y_d-eGWLC'),
    };

    final response = await http.get(
      Uri.parse('https://api.sandbox.midtrans.com/v2/$orderId/status'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return QrisStatusResponseModel.fromJson(response.body);
    } else {
      throw Exception('Failed to check payment status');
    }
  }
}

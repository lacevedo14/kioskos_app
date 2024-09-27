import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_videocall/models/entities/entities.dart';
import 'package:http/http.dart' as http;

class LoginService extends ChangeNotifier {
  final String _baseUrl = 'http://192.168.1.6:8000/api';

  bool isLoading = true;
  Future loginUser(data) async {
    final response =
        await http.post(Uri.parse('$_baseUrl/patient-logins'), body: {
      "document_type_id": data.documentTypeId,
      "document_number": data.documentNumber,
      "payment_code": data.paymentCode,
    });
    var jsonResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      final data = jsonResponse['patient'];
      final patient = Patient.fromJson(data);
      isLoading = false;
      return {
        "success": true,
        "message": jsonResponse['message'],
        "patient": patient
      };
    } else {
      isLoading = false;
      return {"success": false, "message": jsonResponse['message']};
    }
  }

  Future registerPatient(data) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };
    final response = await http.post(Uri.parse('$_baseUrl/register-patients'),
        headers: headers, body: data.patient);
    final jsonResponse = json.decode(response.body);
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_videocall/models/entities/entities.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginService extends ChangeNotifier {
  final String _baseUrl = 'https://citamedicas.site/api_kioskos/api';

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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('tokenGeneral', jsonResponse['access_token']);
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
        headers: headers, body: jsonEncode(data.patient.toJson()));
    final jsonResponse = json.decode(response.body);
    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('tokenGeneral', jsonResponse['access_token']);
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
}

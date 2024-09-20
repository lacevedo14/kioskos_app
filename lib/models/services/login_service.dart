
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_videocall/models/entities/entities.dart';
import 'package:http/http.dart' as http;

class LoginService extends ChangeNotifier {
  final String _baseUrl = 'http://192.168.1.12:8000/api';

  bool isLoading = true;

  Future loginUser(data) async {
    
    final response = await http.post(Uri.parse('$_baseUrl/patient-logins'), body: data.toJson());
    final jsonResponse = json.decode(response.body);

    if (response.statusCode == 200) {
    
      return jsonResponse['message'];
     
    } else {
      return jsonResponse['messaje'];
    }
  }

  Future registerPatient(RegisterPatient patient) async {

    Map<String, String>  headers = {
        "Content-Type": "application/json",
      };
    final response = await http.post(Uri.parse('$_baseUrl/register-patients'),headers:headers, body: patient.toJson());
    final jsonResponse = json.decode(response.body);

  }

}
import 'dart:convert';

import 'package:flutter_videocall/models/entities/entities.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl = 'http://192.168.1.6:8000/api';

  Future<List<TypeDocuments>> getTypePRovider() async {
    final response = await http.get(Uri.parse('$_baseUrl/document-types'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((job) => TypeDocuments.fromJson(job)).toList();
    } else {
      throw Exception('Error al cargar');
    }
  }

  Future<List<CodePhone>> getCodePhone() async {
    final response = await http.get(Uri.parse('$_baseUrl/phone-codes'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((job) => CodePhone.fromJson(job)).toList();
    } else {
      throw Exception('Error al cargar');
    }
  }

  Future<List<Opcion>> getGender() async {
    final response = await http.get(Uri.parse('$_baseUrl/genders'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((job) => Opcion.fromJson(job)).toList();
    } else {
      throw Exception('Error al cargar');
    }
  }

    Future getRoom(patientId) async {

    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final DateFormat hourformatter = DateFormat.Hms();
    final String formatted = formatter.format(now);
    final String hour = hourformatter.format(now);
    print(formatted);
    print(hour);
    final response = await http.post(Uri.parse('$_baseUrl/medical-appointments'),
        body: {
          "patient_id": patientId,
          "appointment_date": formatted,
          "appointment_hour": hour,
        });
    final jsonResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      return {"success": true, "token": jsonResponse['token_twilio'], "room": jsonResponse['room']};
    } else {
      return {"success": false, "message": jsonResponse['message']};
    }
  }
}

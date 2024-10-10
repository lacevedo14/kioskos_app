import 'dart:convert';

import 'package:flutter_videocall/models/entities/entities.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
    final response =
        await http.post(Uri.parse('$_baseUrl/medical-appointments'), body: {
      "patient_id": patientId,
      "appointment_date": formatted,
      "appointment_hour": hour,
    });
    final jsonResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      return {
        "success": true,
        "token": jsonResponse['token_twilio'],
        "room": jsonResponse['room']
      };
    } else {
      return {"success": false, "message": jsonResponse['message']};
    }
  }

  Future getCodeScan(patientId) async {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd').add_Hms();
    final String hour = formatter.format(now);

    final response = await http.post(Uri.parse('$_baseUrl/face-scans'), body: {
      "patient_id": patientId,
      "date": hour,
    });
    final jsonResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      return {
        "success": true,
        "face_scan_id": jsonResponse['face_scan_id'],
        "face_scan_code": jsonResponse['face_scan_code']
      };
    } else {
      return {"success": false, "message": jsonResponse['message']};
    }
  }

  Future sendResultScan(id, data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final idPatient = prefs.getInt('idPatient');
    final scanCode = prefs.getString('scanCode');
    Map<String, String> resultsJson = {};
    for (var result in data) {
      String label = result['subtitleText']!;
      String englishLabel = result['mainText']!.replaceAll(' ', '');
      resultsJson[englishLabel] = result['mainText']!;
    }

    String dataSend = json.encode({"results": resultsJson, "room": scanCode});

    final response = await http.post(Uri.parse('$_baseUrl/face-scans'), body: {
      "patient_id": idPatient,
      "scan_id": id,
      "results": dataSend,
    });
    final jsonResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      return {"success": true};
    } else {
      return {"success": false, "message": jsonResponse['message']};
    }
  }

  Future getPaymentCode() async {
    final response =
        await http.post(Uri.parse('$_baseUrl/booth-code-payments'));
    final jsonResponse = json.decode(response.body);
    if (response.statusCode == 200) {
      return {
        "success": true,
        "code": jsonResponse['payment_code'],
        "message": jsonResponse['message']
      };
    } else {
      return {"success": false, "message": response.body};
    }
  }
}

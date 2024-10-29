import 'dart:convert';
import 'package:flutter_videocall/models/entities/entities.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String _baseUrl = 'https://citamedicas.site/api_kioskos/api';

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

  Future getCodeScan(int patientId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('tokenGeneral');

    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd').add_Hms();
    final String hour = formatter.format(now);

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
    final response = await http.post(Uri.parse('$_baseUrl/face-scans'),
        headers: headers,
        body: jsonEncode({
          "patient_id": patientId.toString(),
          "date": hour,
        }));
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
    final token = prefs.getString('tokenGeneral');

    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final DateFormat hourformatter = DateFormat.Hms();
    final String formatted = formatter.format(now);
    final String hour = hourformatter.format(now);

    Map<String, dynamic> resultsJson = {};
    if (data.isNotEmpty) {
      for (var result in data) {
        String label = result['subtitleText']!;
        String englishLabel = label.replaceAll(' ', '');
        resultsJson[englishLabel] = {"value": result['mainText']!};
      }
    }

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
    final finalData = jsonEncode({
      "patient_id": idPatient.toString(),
      "scan_id": id.toString(),
      "appointment_date": formatted,
      "appointment_hour": hour,
      "results": {"vitals": resultsJson, "room": scanCode},
    });

    final response = await http.post(Uri.parse('$_baseUrl/face-scan-results'),
        headers: headers, body: finalData);

    final jsonResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setInt(
          'idAppointment', jsonResponse['appointment_id'] as int);
      await prefs.setString('room', jsonResponse['room']);
      await prefs.setString('token', jsonResponse['token_twilio']);
      if (jsonResponse['doctor_id'] != null) {
        await prefs.setInt('idDoctor', jsonResponse['doctor_id'] as int);
        await prefs.setString('professionalCard', jsonResponse['doctor_tuition_number']);
      } else {
        await prefs.setInt('idDoctor', 0);
        await prefs.setString('professionalCard','');
      }
      return {"success": true, "message": jsonResponse['message']};
    } else {
      return {"success": false, "message": jsonResponse['message']};
    }
  }

  Future getPaymentCode() async {
    final response =
        await http.post(Uri.parse('$_baseUrl/booth-code-payments'));
    final jsonResponse = json.decode(response.body);
    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('codePayment', jsonResponse['payment_code']);
      return {
        "success": true,
        "code": jsonResponse['payment_code'],
        "message": jsonResponse['message']
      };
    } else {
      return {"success": false, "message": response.body};
    }
  }

  Future getQuestionsSurvey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('tokenGeneral');

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
    final response = await http.get(
      Uri.parse('$_baseUrl/surveys?language=spa'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return {
        "success": true,
        "question": jsonResponse,
      };
    } else {
      throw Exception('Error al cargar');
    }
  }

  Future sendDataSurvey(data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final idDoctor = prefs.getInt('idDoctor');
    final idAppointment = prefs.getInt('idAppointment');
    final token = prefs.getString('tokenGeneral');

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
    final response = await http.post(Uri.parse('$_baseUrl/survey-responses'),
        headers: headers,
        body: jsonEncode({
          "doctor_id": idDoctor.toString(),
          "appointment_id": idAppointment.toString(),
          "responses": [
            {"survey_id": 1, "response": data['satisfaction']},
            {"survey_id": 2, "response": data['recommendationAttention']},
            {"survey_id": 3, "response": data['medicalInformation']},
            {"survey_id": 4, "response": data['qualityConsultation']},
            {"survey_id": 5, "response": data['comfortable']},
          ]
        }));
    final jsonResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      return {"success": true};
    } else {
      return {"success": false, "message": jsonResponse['message']};
    }
  }

  Future getCheckDoctor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final room = prefs.getString('room');
    final token = prefs.getString('tokenGeneral');

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    final response = await http.get(
      Uri.parse('$_baseUrl/medical-appointments/$room'),
      headers: headers,
    );
    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (data[0]['doctor_id'] != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('idDoctor', data[0]['doctor_id'] as int);
        await prefs.setString('professionalCard', data[0]['tuition_number']);
        return {
          "success": true,
          "doctor_id": data[0]['doctor_id'] as int,
          "tuition_number": data[0]['tuition_number'],
        };
      } else {
        return {"success": false, "doctor_id": 0, "tuition_number": ''};
      }
    } else {
      return {"success": false, "message": data['message']};
    }
  }
}

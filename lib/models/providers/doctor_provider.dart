import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DoctorCheckerProvider extends ChangeNotifier {
  int _idDoctor = 0;
  String _nameDoctor = '';
  Future<void> checkDoctorValue() async {
    try {
      const String baseUrl = 'https://citamedicas.site/api_kioskos/api';
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final room = prefs.getString('room');
      final token = prefs.getString('tokenGeneral');

      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };

      final response =
          await http.get(Uri.parse('$baseUrl/medical-appointments/$room'),headers: headers,);
      final data = jsonDecode(response.body);

      if (data['doctor_id'] != null) {
        idDoctor = data['id'];
        nameDoctor = data['nombre'];

        timer?.cancel();
        print('Valor encontrado!');
      }
    } catch (e) {
      print('main() finished handling ${e.runtimeType}.');
    }
  }

  Timer? timer;

  void startChecking() {
    const duration = Duration(seconds: 45);
    timer = Timer.periodic(duration, (timer) async {
      await checkDoctorValue();
    });
  }

  int get idDoctor => _idDoctor;

  set idDoctor(int newId) {
    _idDoctor = newId;
    notifyListeners();
  }

  String get nameDoctor => _nameDoctor;
  set nameDoctor(String newName) {
    _nameDoctor = newName;
    notifyListeners();
  }
}


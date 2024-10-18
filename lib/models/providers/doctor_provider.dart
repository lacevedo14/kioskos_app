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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final room = prefs.getString('room');
      final response = await http.get(Uri.parse('medical-appointments/$room'));
      final data = jsonDecode(response.body);

      if (data['idDoctor'] != null) {
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
    const duration = Duration(seconds: 5);
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

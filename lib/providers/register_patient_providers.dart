import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_videocall/models/entities/entities.dart';

class RegisterPatientProvider extends ChangeNotifier {
  GlobalKey<FormState> registerKey = GlobalKey<FormState>();

  RegisterPatient patient = RegisterPatient();
 bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
     bool isValidForm() {
      print(registerKey.currentState?.validate());

      print('$patient.documentTypeId - $patient.documentTypeId - $patient.paymentCode');

      return registerKey.currentState?.validate() ?? false;
    }
}

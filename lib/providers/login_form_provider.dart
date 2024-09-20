import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginFormProvider extends ChangeNotifier {
  
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String documentTypeId    = '';
  String documentNumber = '';
  String paymentCode = '';

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

    bool isValidForm() {
      print(formKey.currentState?.validate());

      print('$documentTypeId - $documentTypeId - $paymentCode');

      return formKey.currentState?.validate() ?? false;
    }
}

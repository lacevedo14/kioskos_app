import 'package:flutter/material.dart';


class LoginFormProvider extends ChangeNotifier {

  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  String codePayment    = '';
  String typeDocument = '';
  String document = '';

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  set isLoading( bool value ) {
    _isLoading = value;
    notifyListeners();
  }

  
  bool isValidForm() {

    print(formKey.currentState?.validate());

    print('$codePayment - $typeDocument - $document');

    return formKey.currentState?.validate() ?? false;
  }

  

}
import 'package:flutter/material.dart';
import 'package:flutter_videocall/models/services/api_service.dart';
import 'package:flutter_videocall/pages/translations.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GeneratePaymentCode extends StatefulWidget {
  const GeneratePaymentCode({super.key});
  @override
  State<GeneratePaymentCode> createState() => _GeneratePaymentCode();
}

class _GeneratePaymentCode extends State<GeneratePaymentCode> {
  final String _selectedLanguage = 'ESP';
  bool enabled = false;
  @override
  void initState() {
    super.initState();
    clearVariables();
  }

  Future<void> clearVariables() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: size.height * 0.2,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage('assets/logo_egd.png'),
                  fit: BoxFit.scaleDown,
                )),
              ),
              const SizedBox(height: 20),
              Text(
                translations[_selectedLanguage]!['welcome']!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 20),
              Text(
                translations[_selectedLanguage]!['payment_tittle']!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 20),
              SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          disabledColor: Colors.grey,
                          elevation: 0,
                          color: Colors.indigo,
                          onPressed: enabled
                              ? null
                              : () async {
                                  setState(() {
                                    enabled = true;
                                  });
                                  final ApiService _apiService = ApiService();
                                  final data =
                                      await _apiService.getPaymentCode();
                                  if (data['success']) {
                                    context.goNamed('view-code',
                                        pathParameters: {'code': data['code']});
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(data['message'])),
                                    );
                                  }
                                  setState(() {
                                    enabled = true;
                                  });
                                },
                          child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 15),
                              child: Text(
                                translations[_selectedLanguage]![
                                    'generate_code']!,
                                style: const TextStyle(color: Colors.white),
                              ))),
                      const SizedBox(height: 50),
                    ],
                  )),
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

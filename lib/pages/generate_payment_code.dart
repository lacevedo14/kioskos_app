import 'package:flutter/material.dart';
import 'package:flutter_videocall/models/services/api_service.dart';
import 'package:flutter_videocall/pages/translations.dart';
import 'package:go_router/go_router.dart';

class GeneratePaymentCode extends StatelessWidget {
  const GeneratePaymentCode({super.key});
  final String _selectedLanguage = 'ESP';

  @override
  Widget build(BuildContext context) {
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
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/logo_egd.png'),
                        fit: BoxFit.scaleDown)),
              ),
              Text(
                translations[_selectedLanguage]!['payment_tittle']!,
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
                          child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 15),
                              child: Text(
                                translations[_selectedLanguage]!['trigger']!,
                                style: TextStyle(color: Colors.white),
                              )),
                          onPressed: () async {
                             final ApiService _apiService = ApiService();
                              final data = await _apiService.getPaymentCode();
                              if (data['success']) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(data['message'])),
                                );
                                context.go('/entry-page');
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(data['message'])),
                                );
                              }
                          }),
                      const SizedBox(height: 20),
                    ],
                  )),
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

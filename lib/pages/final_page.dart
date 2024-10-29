import 'package:flutter/material.dart';
import 'package:flutter_videocall/main.dart';
import 'package:flutter_videocall/pages/translations.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FinalPage extends StatefulWidget {
  const FinalPage({super.key});
  @override
  State<FinalPage> createState() => _FinalPage();
}

class _FinalPage extends State<FinalPage> {
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
                  image: AssetImage('assets/images/logo_planimedic.png'),
                  fit: BoxFit.scaleDown,
                )),
              ),
              const SizedBox(height: 20),
              Text(
                translations[_selectedLanguage]!['medical_prescription']!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.clear();
                  RestartWidget.restartApp(context);
                  context.go('/');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2087C9),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
                  translations[_selectedLanguage]!['finish'] ?? 'Finalizar',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

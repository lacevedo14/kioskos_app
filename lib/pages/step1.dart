import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'translations.dart';
import 'device_info_storage.dart'; // Importar el archivo con las variables globales

class Step1Screen extends StatefulWidget {
  const Step1Screen({Key? key}) : super(key: key);

  @override
  _Step1ScreenState createState() => _Step1ScreenState();
}

class _Step1ScreenState extends State<Step1Screen> {
  String _selectedLanguage = 'ESP';
  bool _isStartButtonEnabled = false;
  bool _hasFetchedInformation = false;
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    // Cargar el valor de room desde SharedPreferences, si está guardado
    SharedPreferences prefs = await SharedPreferences.getInstance();
    room = prefs.getString('scanCode') ?? '';
  

    if (room.isNotEmpty) {
      print('room: $room');

      setState(() {
        _isStartButtonEnabled = true;
        _hasFetchedInformation = true;
      });
    } else {
      _resetGlobalVariables();
      await _loadLanguagePreference();
    }
  }

  void _resetGlobalVariables() {
    room = '';
    secretk = '';
    _isStartButtonEnabled = false;
    _hasFetchedInformation = false;
  }

  Future<void> _loadLanguagePreference() async {
    setState(() {
      _selectedLanguage = 'ESP';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65.0),
        child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: const Color(0xFF3A598F),
            elevation: 0,
            title: const Text('')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    translations[_selectedLanguage]!['description'] ??
                        'Description',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _isStartButtonEnabled
                        ? () {
                            context.go('/step2');
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(
                      translations[_selectedLanguage]!['start'] ?? 'Start',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

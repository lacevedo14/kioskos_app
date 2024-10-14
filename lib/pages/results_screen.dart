import 'package:connectivity_plus/connectivity_plus.dart';  // Para verificar la conexión a Internet
import 'package:flutter/material.dart';
import 'package:flutter_videocall/models/models.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'translations.dart';
import 'device_info_storage.dart';
import 'result_item.dart';

class ResultsScreen extends StatefulWidget {
  final List<Map<String, String>> results;
  final String? title;

  const ResultsScreen({Key? key, required this.results, this.title}) : super(key: key);

  @override
  _ResultsScreenState createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  String _selectedLanguage = 'ESP';
  bool _allResultsNa = false;
  bool _hasError = false;
  final Map<String, String> _labelTranslationToEnglish = {
    // Completa tu mapa de traducciones aquí...
  };

  @override
  void initState() {
    super.initState();
    _loadLanguagePreference();
    _checkForErrorsAndProceed();
  }

  Future<void> _loadLanguagePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('selected_language') ?? 'ESP';
    });
    print('Idioma seleccionado: $_selectedLanguage');
  }

  Future<void> _checkForErrorsAndProceed() async {
    _hasError = widget.results.any((result) =>
    (result['mainText']?.toLowerCase().contains('error') ?? false));
    _allResultsNa = widget.results.every(
            (result) => (result['mainText']?.toUpperCase() == 'N/A'));

    if (_hasError || _allResultsNa) {
      String message = _hasError
          ? 'Error en los resultados, no se enviarán.'
          : translations[_selectedLanguage]!['no_results'] ?? 'No Results';
      print(message);
    } else {
      _sendResults();
    }
  }

  Future<void> _sendResults() async {
    print('Guardando resultados localmente...');

 
    Map<String, String> resultsJson = {};
    for (var result in widget.results) {
      String label = result['subtitleText']!;
      String englishLabel = _labelTranslationToEnglish[label] ?? label;
      String formattedLabel = englishLabel.replaceAll(' ', '');
      resultsJson[formattedLabel] = result['mainText']!;
    }

    String jsonResponse = json.encode({
      "results": resultsJson,
      "room": room
    });

    print('JSON de resultados y datos del dispositivo: $jsonResponse');

    //_guardarEscanerEnBD(jsonResponse);
  }

  Future<bool> _hasInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }


  void _clearDeviceInfo() {
    room = '';
    print('Variables de dispositivo limpiadas.');
  }

  void _resetServices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _clearDeviceInfo();
    print('Servicios y variables reiniciados.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color.fromARGB(255, 246, 247, 248),
          elevation: 0,
          title: Center(
            child: Image.asset(
              'assets/logo_egd.png',
              height: 50,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 25.0),
                      child: Text(
                        translations[_selectedLanguage]!['all_results_warning']!,
                        style: const TextStyle(fontSize: 11, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.results.length,
                    itemBuilder: (context, index) {
                      final result = widget.results[index];
                      return ResultItem(
                        mainText: result['mainText'] ?? '',
                        subtitleText: result['subtitleText'] ?? '',
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: _hasError || _allResultsNa
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      context.read<MeasurementModel>().reset();
                      context.go('/step1');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF3A2C),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                            shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    
                    child: Text(
                      translations[_selectedLanguage]!['repeat_face_scan'] ??
                          'Repetir Escaneo Facial',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () => context.go('/call-screen'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                            shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(
                      translations[_selectedLanguage]!['continue'] ?? 'Continuar',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
                  : Center(
                child: ElevatedButton(
                  onPressed: () {
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF03967F),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: Text(
                    translations[_selectedLanguage]!['finish'] ?? 'Finalizar',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

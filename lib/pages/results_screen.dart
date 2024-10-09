import 'package:connectivity_plus/connectivity_plus.dart';  // Para verificar la conexión a Internet
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_videocall/models/models.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'step1.dart';
import 'translations.dart';
import 'device_info_storage.dart';
import 'result_item.dart';
import '../main.dart';  // Asegúrate de importar donde esté `RestartWidget`

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
      //_showMaterialBanner(message, false);
      print(message);
    } else {
      _sendResults();
    }
  }

  Future<void> _sendResults() async {
    print('Guardando resultados localmente...');

    // Aquí accedes directamente a las variables globales de device_info_storage.dart
    Map<String, String> resultsJson = {};
    for (var result in widget.results) {
      String label = result['subtitleText']!;
      String englishLabel = _labelTranslationToEnglish[label] ?? label;
      String formattedLabel = englishLabel.replaceAll(' ', '');
      resultsJson[formattedLabel] = result['mainText']!;
    }

    String jsonResponse = json.encode({
      "results": resultsJson,
      "deviceIdentifier": deviceIdentifier,  // Usar las variables globales sin redeclararlas
      "osVersion": osVersion,
      "deviceModel": deviceModel,
      "deviceUUID": deviceUUID,
      "room": room
    });

    print('JSON de resultados y datos del dispositivo: $jsonResponse');

    //_guardarEscanerEnBD(jsonResponse);
  }

  // void _guardarEscanerEnBD(String escanerJson) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   int? usuarioId = prefs.getInt('usuario_id');

  //   if (usuarioId != null) {
  //     DatabaseHelper dbHelper = DatabaseHelper.instance;
  //     int result = await dbHelper.updateUserEscaner(usuarioId, escanerJson);

  //     if (result > 0) {
  //       print('Datos de escáner guardados correctamente en la base de datos.');
  //       var userRecord = await dbHelper.getUserById(usuarioId);

  //       if (userRecord != null) {
  //         print('Registro actualizado: $userRecord');
  //         await _sendDataToApi(userRecord);
  //       } else {
  //         print('No se pudo obtener el registro actualizado.');
  //       }
  //     } else {
  //       print('Error al guardar los datos de escáner en la base de datos.');
  //     }
  //   } else {
  //     print('No se encontró el ID del usuario en SharedPreferences.');
  //   }
  // }

  // Nueva función para verificar la conexión a Internet
  Future<bool> _hasInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  // Nueva función para enviar los datos a la API
  Future<void> _sendDataToApi(Map<String, dynamic> userRecord) async {
    try {
      // Verificar conexión a Internet antes de proceder
      bool isConnected = await _hasInternetConnection();

      if (!isConnected) {
        print("Sin conexión a Internet. No se puede enviar la información.");
        //_showMaterialBanner("No hay conexión a Internet", false);
        return;
      }

      var dio = Dio();
      var headers = {
        'Content-Type': 'application/json',
        'Cookie': 'PHPSESSID=bf069e6595c86a7692ffdfab36d989b6'
      };

      String scanData = userRecord['escaner'] ?? '';
      String patientData = userRecord['usuario'] ?? '';
      String surveyData = userRecord['encuesta'] ?? '';

      var data = json.encode({
        "request": "addScanExtern",
        "token": "JAH36719MF889K1",  // Aquí pondrías tu token de autenticación real
        "scan": scanData,
        "patient": patientData,
        "survey": surveyData,
      });

      print("Enviando los siguientes datos a la API:");
      print(data);

      var response = await dio.request(
        'https://eliteglobaldoctors.com/api//apirest_v1/scan',
        options: Options(
          method: 'PUT',
          headers: headers,
        ),
        data: data,
      );

      if (response.statusCode == 200) {
        print("Respuesta de la API:");
        print(json.encode(response.data));
      } else {
        print("Error al enviar datos a la API: ${response.statusMessage}");
      }
    } catch (e) {
      print("Error en la solicitud API: $e");
    }
  }

  void _clearDeviceInfo() {
    deviceIdentifier = '';
    osVersion = '';
    deviceModel = '';
    deviceUUID = '';
    room = '';
    print('Variables de dispositivo limpiadas.');
  }

  void _resetServices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _clearDeviceInfo();
    print('Servicios y variables reiniciados.');
  }

  void _showMaterialBanner(String message, bool isSuccess) {
    ScaffoldMessenger.of(context).clearMaterialBanners();
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: isSuccess ? const Color(0xFF02bd2f) : Colors.red,
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
            },
            child: const Text(
              'Cerrar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    Future.delayed(const Duration(seconds: 4), () {
      ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
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
          title: Center(
            child: Image.asset(
              'assets/images/logo-elite-footer_65-1.png',
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
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) {
                          context.read<MeasurementModel>().reset();
                          return const Step1Screen();
                        }),
                            (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF3A2C),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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

import 'package:flutter/material.dart';
import 'package:flutter_videocall/models/services/api_service.dart';
import 'package:flutter_videocall/pages/translations.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:io';

String secretk = '';

class ConsentUseScreen extends StatefulWidget {
  const ConsentUseScreen({Key? key}) : super(key: key);

  @override
  _ConsentUseScreenState createState() => _ConsentUseScreenState();
}

class _ConsentUseScreenState extends State<ConsentUseScreen> {
  //SharedPreferencesAsync  prefs = SharedPreferencesAsync();
  String _selectedLanguage = 'ESP';
  late StreamSubscription _internetSubscription;
  bool _isConnected = true;
  bool _isAcceptButtonEnabled = false;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadLanguagePreference();
    _startListeningInternetConnection();
    _initialize();
  }

  Future<void> _loadLanguagePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _selectedLanguage = prefs.getString('language') ?? 'ESP';
  }

  // Escucha continuamente la conexión a internet
  void _startListeningInternetConnection() {
    _internetSubscription =
        Stream.periodic(const Duration(seconds: 5)).listen((_) async {
      bool isConnected = false;
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          isConnected = true;
        }
      } on SocketException catch (_) {
        isConnected = false;
      }

      // Actualiza solo si hay un cambio en la conexión
      if (isConnected != _isConnected) {
        setState(() {
          _isConnected = isConnected;
        });

        if (_isConnected) {
          ScaffoldMessenger.of(context).clearMaterialBanners();
          _initialize(); // Reintenta la inicialización si hay conexión
        } else {
          _showNoInternetBanner();
        }
      }
    });
  }

  // Muestra un MaterialBanner rojo si no hay internet
  void _showNoInternetBanner() {
    // Solo mostrar el banner si no hay banners visibles
    if (ScaffoldMessenger.of(context).mounted) {
      ScaffoldMessenger.of(context).showMaterialBanner(
        MaterialBanner(
          backgroundColor: Colors.red,
          content: const Text(
            'No hay conexión a internet',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              },
              child:
                  const Text('Cerrar', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _initialize() async {
    if (_isConnected) {
      await _getCodeScan();
    } else {
      _showNoInternetBanner();
    }
  }

  Future<void> _getCodeScan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var idPatient = await prefs.getString('idPatient') ?? '';
    final data = await _apiService.getCodeScan(idPatient);
    const secretKey = '4CF183-FF2816-44998A-9A3CD3-08BCAB-BF8C5D';
    if (data != null && data['face_scan_code'] != null) {
      secretk = secretKey; // Usamos '!' para indicar que no es null
      print('SecretKey recibido: $secretk');

      await prefs.setString('secretKey', secretk);
      await prefs.setInt('idScan', data['face_scan_id']);
      await prefs.setString('scanCode', data['face_scan_code']);

      setState(() {
        _isAcceptButtonEnabled = true; // Habilitamos el botón "Aceptar"
      });
    } else {
      print('Error en la autenticación. No se recibió ningún secretKey.');
      setState(() {
        _isAcceptButtonEnabled = false; // Deshabilitamos el botón "Aceptar"
      });
    }
  }

  @override
  void dispose() {
    if (_internetSubscription != null) {
      _internetSubscription.cancel();
    }
    super.dispose();
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
          title: const Text(''),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 20), // Espacio antes del título
              Center(
                child: Text(
                  translations[_selectedLanguage]!['consent_title'] ??
                      'Consentimiento',
                  style: const TextStyle(
                    fontSize: 24, // Tamaño de fuente más grande
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3A598F),
                  ),
                ),
              ),
              const SizedBox(height: 20), // Espacio entre el título y el texto
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                          maxWidth: 600), // Limita el ancho máximo
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            translations[_selectedLanguage]!['consent_use_1'] ??
                                "1) Doy el consentimiento para compartir la información de salud personal. ",
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            translations[_selectedLanguage]!['consent_use_2'] ??
                                "Entiendo que tengo el derecho legal de negar o confirmar mi procedimiento para el uso de la telemedicina/Telesalud en el transcurso de la atención en cualquier momento sin afectar el derecho de recibir atención o tratamiento en el futuro.",
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            translations[_selectedLanguage]!['consent_use_3'] ??
                                "2) Entiendo que tengo el derecho de inspeccionar toda la información recibida y registrada durante la consulta por telemedicina/telesalud y puedo recibir copias de dicha información de acuerdo a la ley.",
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            translations[_selectedLanguage]!['consent_use_4'] ??
                                "Las leyes que protegen la confidencialidad de la información médica también se aplican a la telemedicina, como tal.",
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            translations[_selectedLanguage]!['consent_use_5'] ??
                                "3) Entiendo que la información revelada en transcurso del tratamiento es confidencial.",
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            translations[_selectedLanguage]!['consent_use_6'] ??
                                "4) He leído y entiendo que la información proporcionada anteriormente sobre telemedicina/telesalud ha sido explicada a mi satisfacción por lo que a la presente doy mi consentimiento informado para el uso de la telemedicina/telesalud en la atención médica.",
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            translations[_selectedLanguage]!['consent_use_7'] ??
                                "5) Doy el consentimiento para que mi consulta de telemedicina/telesalud, se grabe como sustento de mi atención médica requerida.",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 16.0), // Espacio adicional entre botón y footer
                child: Padding(
                  padding: const EdgeInsets.only(
                      top:
                          15.0), // Espacio de 15px entre el botón y el borde superior del footer
                  child: Tooltip(
                    message: (_isConnected && _isAcceptButtonEnabled)
                        ? ''
                        : 'No hay conexión a internet o no se pudo obtener la clave',
                    child: ElevatedButton(
                      onPressed: (_isConnected && _isAcceptButtonEnabled)
                          ? () {
                              context.go('/step1');
                            }
                          : null, // Deshabilitar el botón si no hay conexión o no se obtuvo el secretKey
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white, // Texto blanco
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(
                        translations[_selectedLanguage]!['accept'] ?? 'Aceptar',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

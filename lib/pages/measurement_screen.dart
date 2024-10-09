import 'package:binah_flutter_sdk/session/session_state.dart';
import 'package:binah_flutter_sdk/ui/camera_preview_view.dart';
import 'package:binah_flutter_sdk/images/image_data.dart' as sdk_image_data;
import 'package:flutter/material.dart';
import 'package:flutter_videocall/models/services/api_service.dart';
import 'package:flutter_videocall/ui/custom_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_videocall/models/models.dart';
import 'package:flutter_videocall/widgets/widgets.dart';
import 'results_screen.dart';
import 'translations.dart';
import 'dart:async';
import 'device_info_storage.dart';

class MeasurementScreen extends StatefulWidget {
  const MeasurementScreen({Key? key}) : super(key: key);

  @override
  _MeasurementScreenState createState() => _MeasurementScreenState();
}

class _MeasurementScreenState extends State<MeasurementScreen> {
  String _selectedLanguage = 'ESP';
  SharedPreferencesAsync prefs = SharedPreferencesAsync();
    final ApiService _apiService = ApiService(); 
  @override
  void initState() {
    super.initState();
    print('DEBUG: MeasurementScreen: initState llamado'); // DEBUG
    _loadLanguagePreference();

    // Reiniciamos los resultados previos al entrar en la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MeasurementModel>().resetResults();
      print('DEBUG: MeasurementScreen: Resultados reiniciados'); // DEBUG
    });
  }

  Future<void> _loadLanguagePreference() async {
    _selectedLanguage = await prefs.getString('selectedLanguage') ?? 'ESP';
  }

  @override
  Widget build(BuildContext context) {
    var warning =
        context.select<MeasurementModel, String?>((model) => model.warning);
    var error =
        context.select<MeasurementModel, String?>((model) => model.error);
    var bloodPressure = context
        .select<MeasurementModel, String?>((model) => model.finalResultsString);

    print('DEBUG: MeasurementScreen: build llamado'); // DEBUG
    print('DEBUG: MeasurementScreen: warning = $warning'); // DEBUG
    print('DEBUG: MeasurementScreen: error = $error'); // DEBUG
    print('DEBUG: MeasurementScreen: bloodPressure = $bloodPressure'); // DEBUG

    if (warning != null) {
      Fluttertoast.showToast(
          msg: warning,
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.white);
      print('DEBUG: MeasurementScreen: Mostrando toast de warning'); // DEBUG
    }

    if (error != null) {
      showAlert(context, "Error", error);
      print('DEBUG: MeasurementScreen: Mostrando alerta de error'); // DEBUG
    }

    if (bloodPressure != null) {
      showAlert(context, "Results", bloodPressure);
      print(
          'DEBUG: MeasurementScreen: Mostrando alerta de resultados'); // DEBUG
    }

    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return FocusDetector(
      onFocusLost: () {
        print('DEBUG: MeasurementScreen: focus perdido'); // DEBUG
        context.read<MeasurementModel>().screenInFocus(false);
      },
      onFocusGained: () {
        print('DEBUG: MeasurementScreen: focus ganado'); // DEBUG
        context.read<MeasurementModel>().screenInFocus(true);
      },
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 195, 198, 202),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Color(0xFF3A598F),
            elevation: 0,
            title: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo-elite-footer_65-1.png',
                      height: 35,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      translations[_selectedLanguage]!['face_scan']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: const _CameraPreview(),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      color:
                          Color.fromARGB(255, 195, 198, 202).withOpacity(0.5),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const _PulseRate(),
                          const SizedBox(height: 5),
                          _StartStopButtonWithTimer(
                              selectedLanguage: _selectedLanguage),
                        ],
                      ),
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

  Future<void> showAlert(BuildContext context, String? title, String results) async {
    print(
        'DEBUG: MeasurementScreen: showAlert llamado con title="$title" y results="$results"'); // DEBUG

    List<Map<String, String>> parsedResults;

    if (title == "Error" && results.contains('Cause:')) {
      var parts = results.split(' Cause: ');
      String mainText = parts[0];
      String subtitleText = parts.length > 1 ? 'Cause: ${parts[1]}' : 'Error';

      parsedResults = [
        {'mainText': mainText, 'subtitleText': subtitleText}
      ];
      print('DEBUG: MeasurementScreen: Parsed Error - $parsedResults'); // DEBUG
    } else {
      parsedResults = results.split('\n').map((line) {
        var parts = line.split(': ');
        if (parts.length == 2) {
          return {'mainText': parts[1], 'subtitleText': parts[0]};
        }
        return {'mainText': 'N/A', 'subtitleText': parts[0]};
      }).toList();
      print(
          'DEBUG: MeasurementScreen: Parsed Results - $parsedResults');
           var idScan = await prefs.getInt('idScan') ?? '';
          final data = await _apiService.sendResultScan(idScan,parsedResults); // DEBUG
    }
 
    SchedulerBinding.instance.addPostFrameCallback((_) {
      print('DEBUG: MeasurementScreen: Navegando a ResultsScreen');
      context.go('/entry-page');
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) =>
      //         ResultsScreen(results: parsedResults, title: title),
      //   ),
      // );
    });
  }
}

class _StartStopButtonWithTimer extends StatefulWidget {
  final String selectedLanguage;

  const _StartStopButtonWithTimer({Key? key, required this.selectedLanguage})
      : super(key: key);

  @override
  _StartStopButtonWithTimerState createState() =>
      _StartStopButtonWithTimerState();
}

class _StartStopButtonWithTimerState extends State<_StartStopButtonWithTimer> {
  Timer? _timer;
  int _startTime = 0;
  final int _endTime = 70;
  bool _isRunning = false;
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    print('DEBUG: _StartStopButtonWithTimerState: initState llamado'); // DEBUG
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _isButtonEnabled = true;
        print(
            'DEBUG: _StartStopButtonWithTimerState: _isButtonEnabled establecido a true'); // DEBUG
      });
    });
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
      print('DEBUG: _StartStopButtonWithTimerState: Timer iniciado'); // DEBUG
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _startTime++;
        print(
            'DEBUG: _StartStopButtonWithTimerState: _startTime = $_startTime'); // DEBUG
      });

      if (_startTime >= _endTime) {
        print(
            'DEBUG: _StartStopButtonWithTimerState: Tiempo finalizado, deteniendo timer y simulando pulsación de detener'); // DEBUG
        _stopTimer();
        _simulateStopButtonPress();
      }
    });
  }

  void _stopTimer() {
    if (_timer != null) {
      _timer!.cancel();
      setState(() {
        _isRunning = false;
        _startTime = 0;
        print('DEBUG: _StartStopButtonWithTimerState: Timer detenido'); // DEBUG
      });
    }
  }

  void _simulateStopButtonPress() {
    var measurementModel =
        Provider.of<MeasurementModel>(context, listen: false);
    print(
        'DEBUG: _StartStopButtonWithTimerState: Simulando pulsación de botón de detener'); // DEBUG
    measurementModel.startStopButtonClicked();
  }

  @override
  Widget build(BuildContext context) {
    var state = context
        .select<MeasurementModel, SessionState?>((model) => model.sessionState);
    print(
        'DEBUG: _StartStopButtonWithTimerState: build llamado con state = $state'); // DEBUG

    return Column(
      children: [
        Opacity(
          opacity: _isButtonEnabled ? 1.0 : 0.5,
          child: CustomButton(
            width: 279,
            text: state == SessionState.processing
                ? translations[widget.selectedLanguage]!['stop']!
                : translations[widget.selectedLanguage]!['start_button']!,
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 5),
            alignment: Alignment.center,
            variant: ButtonVariant.FillCustomColor,
            shape: ButtonShape.RoundedBorder8,
            padding: ButtonPadding.PaddingAll12,
            onTap: _isButtonEnabled
                ? () {
                    print(
                        'DEBUG: _StartStopButtonWithTimerState: Botón presionado'); // DEBUG
                    var measurementModel =
                        Provider.of<MeasurementModel>(context, listen: false);
                    measurementModel.startStopButtonClicked();
                    print(
                        'DEBUG: _StartStopButtonWithTimerState: startStopButtonClicked llamado'); // DEBUG

                    if (!_isRunning && state != SessionState.processing) {
                      print(
                          'DEBUG: _StartStopButtonWithTimerState: Iniciando timer desde botón'); // DEBUG
                      _startTimer();
                    } else {
                      print(
                          'DEBUG: _StartStopButtonWithTimerState: Deteniendo timer desde botón'); // DEBUG
                      _stopTimer();
                    }
                  }
                : null,
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          width: 279,
          child: LinearProgressIndicator(
            value: _startTime / _endTime,
            minHeight: 8,
            backgroundColor: Colors.grey[300],
            valueColor:
                AlwaysStoppedAnimation<Color>(Colors.green), // Color verde
          ),
        ),
        const SizedBox(height: 10),
        Text(
          '${((_startTime / _endTime) * 100).toStringAsFixed(0)}%',
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 5),
        Text(
          "${translations[widget.selectedLanguage]!['room']!}: $room",
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  @override
  void dispose() {
    print('DEBUG: _StartStopButtonWithTimerState: dispose llamado'); // DEBUG
    _stopTimer();
    super.dispose();
  }
}

class _PulseRate extends StatelessWidget {
  const _PulseRate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var pulseRate =
        context.select<MeasurementModel, String?>((model) => model.pulseRate);
    print(
        'DEBUG: _PulseRate: build llamado con pulseRate = $pulseRate'); // DEBUG

    if (pulseRate == null) {
      return Container();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          pulseRate,
          style: const TextStyle(color: Colors.black, fontSize: 18),
        ),
        const SizedBox(width: 8),
        Image.asset(
          'assets/images/pulse_rate.png',
          width: 25,
          height: 25,
        ),
      ],
    );
  }
}

class _CameraPreview extends StatefulWidget {
  const _CameraPreview({Key? key}) : super(key: key);

  @override
  _CameraPreviewState createState() => _CameraPreviewState();
}

class _CameraPreviewState extends State<_CameraPreview> {
  Size? size;

  @override
  void initState() {
    super.initState();
    print('DEBUG: _CameraPreviewState: initState llamado'); // DEBUG
  }

  @override
  Widget build(BuildContext context) {
    var sessionState = context
        .select<MeasurementModel, SessionState?>((model) => model.sessionState);
    print(
        'DEBUG: _CameraPreviewState: build llamado con sessionState = $sessionState'); // DEBUG

    if (sessionState == null || sessionState == SessionState.initializing) {
      print(
          'DEBUG: _CameraPreviewState: SessionState es null o inicializando'); // DEBUG
      return Container();
    }

    return WidgetSize(
      onChange: (size) {
        setState(() {
          this.size = size;
          print(
              'DEBUG: _CameraPreviewState: Tamaño del widget cambiado a $size'); // DEBUG
        });
      },
      child: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: size?.width ?? MediaQuery.of(context).size.width,
              height:
                  (size?.width ?? MediaQuery.of(context).size.width) * (4 / 3),
              child: Stack(
                children: [
                  const CameraPreviewView(),
                  if (size != null) _FaceDetectionView(size: size),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    print('DEBUG: _CameraPreviewState: dispose llamado'); // DEBUG
    super.dispose();
  }
}

class GappedRectanglePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  GappedRectanglePainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    double gapPercentage = 0.3;
    double gapSizeHorizontal = size.width * gapPercentage;
    double gapSizeVertical = size.height * gapPercentage;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth;

    canvas.drawLine(
      Offset(0, 0),
      Offset((size.width - gapSizeHorizontal) / 2, 0),
      paint,
    );
    canvas.drawLine(
      Offset((size.width + gapSizeHorizontal) / 2, 0),
      Offset(size.width, 0),
      paint,
    );

    canvas.drawLine(
      Offset(0, size.height),
      Offset((size.width - gapSizeHorizontal) / 2, size.height),
      paint,
    );
    canvas.drawLine(
      Offset((size.width + gapSizeHorizontal) / 2, size.height),
      Offset(size.width, size.height),
      paint,
    );

    canvas.drawLine(
      Offset(0, 0),
      Offset(0, (size.height - gapSizeVertical) / 2),
      paint,
    );
    canvas.drawLine(
      Offset(0, (size.height + gapSizeVertical) / 2),
      Offset(0, size.height),
      paint,
    );

    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width, (size.height - gapSizeVertical) / 2),
      paint,
    );
    canvas.drawLine(
      Offset(size.width, (size.height + gapSizeVertical) / 2),
      Offset(size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FaceDetectionView extends StatelessWidget {
  final Size? size;

  const _FaceDetectionView({Key? key, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var imageInfo = context.select<MeasurementModel, sdk_image_data.ImageData?>(
        (model) => model.imageData);
    print(
        'DEBUG: _FaceDetectionView: build llamado con imageInfo = $imageInfo'); // DEBUG

    if (imageInfo == null || size == null) {
      print('DEBUG: _FaceDetectionView: imageInfo o size es null'); // DEBUG
      return Container();
    }

    var roi = imageInfo.roi;
    if (roi == null) {
      print('DEBUG: _FaceDetectionView: ROI es null'); // DEBUG
      return Container();
    }

    var error =
        context.select<MeasurementModel, String?>((model) => model.error);
    var warning =
        context.select<MeasurementModel, String?>((model) => model.warning);
    print(
        'DEBUG: _FaceDetectionView: error = $error, warning = $warning'); // DEBUG

    Color rectangleColor = const Color(0xFF70fb47);

    if (error != null || warning != null) {
      rectangleColor = const Color(0xFFfc0032);
    }

    var screenSize = MediaQuery.of(context).size;
    var videoAspectRatio = imageInfo.imageWidth / imageInfo.imageHeight;
    var screenAspectRatio = screenSize.width / screenSize.height;

    double scaleX, scaleY;
    if (videoAspectRatio > screenAspectRatio) {
      scaleX = screenSize.width / imageInfo.imageWidth;
      scaleY = scaleX;
    } else {
      scaleY = screenSize.height / imageInfo.imageHeight;
      scaleX = scaleY;
    }

    double left = roi.left * scaleX;
    double top = roi.top * scaleY;
    double width = roi.width * scaleX;
    double height = roi.height * scaleY;

    print(
        'DEBUG: _FaceDetectionView: Dibujando cuadro con color $rectangleColor en posición left=$left, top=$top, width=$width, height=$height'); // DEBUG

    return Positioned(
      left: left,
      top: top,
      child: CustomPaint(
        size: Size(width, height),
        painter: GappedRectanglePainter(
          color: rectangleColor,
          strokeWidth: 4,
        ),
      ),
    );
  }
}

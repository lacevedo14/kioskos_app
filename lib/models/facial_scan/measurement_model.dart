// measurement_model.dart

import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:binah_flutter_sdk/images/image_validity.dart';
import 'package:binah_flutter_sdk/license/license_details.dart';
import 'package:binah_flutter_sdk/vital_signs/vitals/vital_sign_blood_pressure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_videocall/pages/pages.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:binah_flutter_sdk/images/image_data_listener.dart';
import 'package:binah_flutter_sdk/images/image_data.dart' as sdk_image_data;
import 'package:binah_flutter_sdk/session/session_builder/face_session_builder.dart';
import 'package:binah_flutter_sdk/session/session.dart';
import 'package:binah_flutter_sdk/vital_signs/vital_sign_types.dart';
import 'package:binah_flutter_sdk/vital_signs/vitals/vital_sign_pulse_rate.dart';
import 'package:binah_flutter_sdk/vital_signs/vital_signs_listener.dart';
import 'package:binah_flutter_sdk/vital_signs/vital_signs_results.dart';
import 'package:binah_flutter_sdk/vital_signs/vitals/vital_sign.dart';
import 'package:binah_flutter_sdk/vital_signs/vitals/vital_sign_oxygen_saturation.dart';
import 'package:binah_flutter_sdk/vital_signs/vitals/vital_sign_hemoglobin.dart';
import 'package:binah_flutter_sdk/vital_signs/vitals/vital_sign_hemoglobin_a1c.dart';
import 'package:binah_flutter_sdk/vital_signs/vitals/vital_sign_lfhf.dart';
import 'package:binah_flutter_sdk/vital_signs/vitals/vital_sign_mean_rri.dart';
import 'package:binah_flutter_sdk/vital_signs/vitals/vital_sign_pns_index.dart';
import 'package:binah_flutter_sdk/vital_signs/vitals/vital_sign_pns_zone.dart';
import 'package:binah_flutter_sdk/vital_signs/vitals/vital_sign_prq.dart';
import 'package:binah_flutter_sdk/vital_signs/vitals/vital_sign_rmssd.dart';
import 'package:binah_flutter_sdk/vital_signs/vitals/vital_sign_rri.dart';
import 'package:binah_flutter_sdk/vital_signs/vitals/vital_sign_respiration_rate.dart';
import 'package:binah_flutter_sdk/vital_signs/vitals/vital_sign_sd1.dart';
import 'package:binah_flutter_sdk/vital_signs/vitals/vital_sign_sd2.dart';
import 'package:binah_flutter_sdk/vital_signs/vitals/vital_sign_sdnn.dart';
import 'package:binah_flutter_sdk/vital_signs/vitals/vital_sign_sns_index.dart';
import 'package:binah_flutter_sdk/vital_signs/vitals/vital_sign_sns_zone.dart';
import 'package:binah_flutter_sdk/vital_signs/vitals/vital_sign_stress_level.dart';
import 'package:binah_flutter_sdk/vital_signs/vitals/vital_sign_stress_index.dart';
import 'package:binah_flutter_sdk/vital_signs/vitals/vital_sign_wellness_index.dart';
import 'package:binah_flutter_sdk/vital_signs/vitals/vital_sign_wellness_level.dart';
import 'package:binah_flutter_sdk/alerts/warning_data.dart';
import 'package:binah_flutter_sdk/alerts/error_data.dart';
import 'package:binah_flutter_sdk/license/license_info.dart';
import 'package:binah_flutter_sdk/session/session_state.dart';
import 'package:binah_flutter_sdk/session/session_enabled_vital_signs.dart';
import 'package:binah_flutter_sdk/session/session_info_listener.dart';
import 'package:binah_flutter_sdk/alerts/alert_codes.dart';
import 'package:binah_flutter_sdk/health_monitor_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MeasurementModel extends ChangeNotifier
    implements SessionInfoListener, VitalSignsListener, ImageDataListener {
  String licenseKey = ''; // Inicializado vacío
  final int measurementDuration = 70;
  Session? _session;
  sdk_image_data.ImageData? imageData;
  String? error;
  String? warning;
  SessionState? sessionState;
  String? pulseRate;
  String? finalResultsString;
  Map<int, String> errorCauses = {};
  String _selectedLanguage = 'EN';

  MeasurementModel() {
    _loadLanguagePreference();
    _loadErrorCauses();
    _loadLicenseKey(); // Cargamos el licenseKey desde SharedPreferences
  }

  Future<void> _loadLanguagePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _selectedLanguage = prefs.getString('language') ?? 'EN';
  }

  Future<void> _loadLicenseKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    licenseKey = prefs.getString('secretKey') ?? '';
    notifyListeners();
  }

  Future<void> _loadErrorCauses() async {
    final String response =
        await rootBundle.loadString('assets/error_data.json');
    final List<dynamic> data = jsonDecode(response);
    for (var item in data) {
      errorCauses[item['code']] = item['cause'];
    }
  }

  String getErrorCause(int code) {
    return errorCauses[code] ?? "Unknown cause";
  }

  screenInFocus(bool focus) async {
    if (focus) {
      if (!await _requestCameraPermission()) {
        return;
      }

      _createSession();
    } else {
      _terminateSession();
    }
  }

  void startStopButtonClicked() {
    switch (sessionState) {
      case SessionState.ready:
        _startMeasuring();
        break;
      case SessionState.processing:
        _stopMeasuring();
        break;
      default:
        break;
    }
  }

  @override
  void onImageData(sdk_image_data.ImageData imageData) {
    this.imageData = imageData;
    if (imageData.imageValidity != ImageValidity.valid) {
      print("Image Validity Error: ${imageData.imageValidity}");
    }
    notifyListeners();
  }

  @override
  void onVitalSign(VitalSign vitalSign) {
    if (vitalSign.type == VitalSignTypes.pulseRate) {
      pulseRate =
          "${translations[_selectedLanguage]!['pulse_rate']} ${(vitalSign as VitalSignPulseRate).value}";
    } else if (vitalSign.type == VitalSignTypes.oxygenSaturation) {
      print(
          "${translations[_selectedLanguage]!['oxygen_saturation']} ${(vitalSign as VitalSignOxygenSaturation).value}");
    } else if (vitalSign.type == VitalSignTypes.respirationRate) {
      print(
          "${translations[_selectedLanguage]!['respiration_rate']} ${(vitalSign as VitalSignRespirationRate).value}");
    }
    notifyListeners();
  }

  @override
  void onFinalResults(VitalSignsResults finalResults) async {
       
    var pulseRateValue = (finalResults.getResult(VitalSignTypes.pulseRate)
                as VitalSignPulseRate?)
            ?.value ?? 0;

    var respirationRate = finalResults.getResult(VitalSignTypes.respirationRate)
        as VitalSignRespirationRate?;
    var respirationRateValue = respirationRate?.value ?? 0;

    var bloodPressure = finalResults.getResult(VitalSignTypes.bloodPressure)
        as VitalSignBloodPressure?;
    var bloodPressureValue = bloodPressure?.value.toString();

    var hemoglobin = finalResults.getResult(VitalSignTypes.hemoglobin)
        as VitalSignHemoglobin?;
    var hemoglobinValue = hemoglobin?.value ?? 0;

    var hemoglobinA1C = finalResults.getResult(VitalSignTypes.hemoglobinA1C)
        as VitalSignHemoglobinA1C?;
    var hemoglobinA1CValue = hemoglobinA1C?.value ?? 0;

    var lfhf = finalResults.getResult(VitalSignTypes.lfhf) as VitalSignLfhf?;
    var lfhfValue = lfhf?.value ?? 0;

    var meanRri =
        finalResults.getResult(VitalSignTypes.meanRri) as VitalSignMeanRri?;
    var meanRriValue = meanRri?.value ?? 0;

    var pnsIndex =
        finalResults.getResult(VitalSignTypes.pnsIndex) as VitalSignPnsIndex?;
    var pnsIndexValue = pnsIndex?.value ?? 0;

    var pnsZone =
        finalResults.getResult(VitalSignTypes.pnsZone) as VitalSignPnsZone?;
    var pnsZoneValue = pnsZone?.value ?? 0;

    var prq = finalResults.getResult(VitalSignTypes.prq) as VitalSignPrq?;
    var prqValue = prq?.value ?? 0;

    var rmssd = finalResults.getResult(VitalSignTypes.rmssd) as VitalSignRmssd?;
    var rmssdValue = rmssd?.value ?? 0;

    var rri = finalResults.getResult(VitalSignTypes.rri) as VitalSignRri?;
    var rriValues = rri?.value.toString();

    var sd1 = finalResults.getResult(VitalSignTypes.sd1) as VitalSignSd1?;
    var sd1Value = sd1?.value ?? 0;

    var sd2 = finalResults.getResult(VitalSignTypes.sd2) as VitalSignSd2?;
    var sd2Value = sd2?.value ?? 0;

    var sdnn = finalResults.getResult(VitalSignTypes.sdnn) as VitalSignSdnn?;
    var sdnnValue = sdnn?.value ?? 0;

    var snsIndex =
        finalResults.getResult(VitalSignTypes.snsIndex) as VitalSignSnsIndex?;
    var snsIndexValue = snsIndex?.value ?? 0;

    var snsZone =
        finalResults.getResult(VitalSignTypes.snsZone) as VitalSignSnsZone?;
    var snsZoneValue = snsZone?.value ?? 0;

    var stressLevel = finalResults.getResult(VitalSignTypes.stressLevel)
        as VitalSignStressLevel?;
    var stressLevelValue = stressLevel?.value;

    var stressIndex = finalResults.getResult(VitalSignTypes.stressIndex)
        as VitalSignStressIndex?;
    var stressIndexValue = stressIndex?.value ?? 0;

    var wellnessIndex = finalResults.getResult(VitalSignTypes.wellnessIndex)
        as VitalSignWellnessIndex?;
    var wellnessIndexValue = wellnessIndex?.value ?? 0;

    var wellnessLevel = finalResults.getResult(VitalSignTypes.wellnessLevel)
        as VitalSignWellnessLevel?;
    var wellnessLevelValue = wellnessLevel?.value;

    finalResultsString =
        "heartRate: $pulseRateValue\n"
        "breathingRate: $respirationRateValue\n"
        "bloodPressure: $bloodPressureValue\n"
        "hemoglobin: $hemoglobinValue\n"
        "hemoglobinA1c $hemoglobinA1CValue\n"
        "lfjf: $lfhfValue\n"
        "meanRri: $meanRriValue\n"
        "pnsIndex: $pnsIndexValue\n"
        "pnsZone: $pnsZoneValue\n"
        "prq: $prqValue\n"
        "rmssd: $rmssdValue\n"
        "pnsZone: $rriValues\n"
        "sd1: $sd1Value\n"
        "sd2: $sd2Value\n"
        "sdnn: $sdnnValue\n"
        "snsIndex: $snsIndexValue\n"
        "snsZone: $snsZoneValue\n"
        "stressLevel: $stressLevelValue\n"
        "stressIndex: $stressIndexValue\n"
        "wellnessIndex: $wellnessIndexValue\n"
        "wellnessLevel: $wellnessLevelValue";

    notifyListeners();
  }

  @override
  void onWarning(WarningData warningData) {
    if (warning != null) {
      return;
    }

    if (warningData.code ==
        AlertCodes.measurementCodeMisdetectionDurationExceedsLimitWarning) {
      pulseRate = "";
    }

    final cause = getErrorCause(warningData.code);
    warning = "Warning: ${warningData.code} Cause: $cause";
    notifyListeners();
    Future.delayed(const Duration(seconds: 1), () {
      warning = null;
    });
  }

  @override
  void onError(ErrorData errorData) {
    final cause = getErrorCause(errorData.code);
    error = "Error: ${errorData.code} Cause: $cause";
    notifyListeners();
  }

  @override
  void onSessionStateChange(SessionState sessionState) {
    this.sessionState = sessionState;
    switch (sessionState) {
      case SessionState.ready:
        WakelockPlus.enable();
        break;
      case SessionState.terminating:
        WakelockPlus.disable();
        break;
      default:
        break;
    }

    notifyListeners();
  }

  @override
  void onEnabledVitalSigns(SessionEnabledVitalSigns enabledVitalSigns) {}

  @override
  void onLicenseInfo(LicenseInfo licenseInfo) {}

  Future<void> _createSession() async {
    if (_session != null) {
      await _terminateSession();
    }

    _reset();
    try {
      if (licenseKey.isEmpty) {
        error = "La clave de licencia no está disponible.";
        notifyListeners();
        return;
      }

      _session = await FaceSessionBuilder()
          .withImageDataListener(this)
          .withVitalSignsListener(this)
          .withSessionInfoListener(this)
          .build(LicenseDetails(licenseKey));
    } on HealthMonitorException catch (e) {
      final cause = getErrorCause(e.code);
      error = "Error: ${e.code} Cause: $cause";
      notifyListeners();
    }
  }

  Future<void> _startMeasuring() async {
    try {
      resetResults(); // Reiniciar resultados antes de cada medición
      await _session?.start(measurementDuration);
      notifyListeners();
    } on HealthMonitorException catch (e) {
      final cause = getErrorCause(e.code);
      error = "Error: ${e.code} Cause: $cause";
      notifyListeners();
    }
  }

  Future<void> _stopMeasuring() async {
    try {
      await _session?.stop();
    } on HealthMonitorException catch (e) {
      final cause = getErrorCause(e.code);
      error = "Error: ${e.code} Cause: $cause";
      notifyListeners();
    }
  }

  Future<void> _terminateSession() async {
    await _session?.terminate();
    _session = null;
  }

  void _reset() {
    error = null;
    warning = null;
    pulseRate = null;
    finalResultsString = null;
    imageData = null;
    notifyListeners();
  }

  void resetResults() {
    finalResultsString = null;
    error = null;
    warning = null;
    pulseRate = null;
    imageData = null;
    notifyListeners();
  }

  void reset() async {
    await _terminateSession();
    _reset();
    sessionState = null;
  }

  Future<bool> _requestCameraPermission() async {
    PermissionStatus result;
    result = await Permission.camera.request();
    return result.isGranted;
  }
}

// measurement_model.dart

import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:binah_flutter_sdk/images/image_validity.dart';
import 'package:binah_flutter_sdk/license/license_details.dart';
import 'package:binah_flutter_sdk/vital_signs/vitals/vital_sign_blood_pressure.dart';
import 'package:flutter/material.dart';
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

class MeasurementModel extends ChangeNotifier
    implements SessionInfoListener, VitalSignsListener, ImageDataListener {
  String licenseKey = '4CF183-FF2816-44998A-9A3CD3-08BCAB-BF8C5D'; // Inicializado vacío
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

  //
  //MeasurementModel() {
    //_loadLanguagePreference();
    //_loadErrorCauses();
    //_loadLicenseKey(); // Cargamos el licenseKey desde SharedPreferences
  //}

  // Future<void> _loadLanguagePreference() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   _selectedLanguage = prefs.getString('language') ?? 'EN';
  // }

  // Future<void> _loadLicenseKey() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   licenseKey = prefs.getString('secretKey') ?? '';
  //   notifyListeners();
  // }

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
      "pulse_rate ${(vitalSign as VitalSignPulseRate).value}";
    } else if (vitalSign.type == VitalSignTypes.oxygenSaturation) {
      print(
          "oxygen_saturation ${(vitalSign as VitalSignOxygenSaturation).value}");
    } else if (vitalSign.type == VitalSignTypes.respirationRate) {
      print(
          "respiration_rate ${(vitalSign as VitalSignRespirationRate).value}");
    }
    notifyListeners();
  }

  @override
  void onFinalResults(VitalSignsResults finalResults) async {
    var pulseRateValue =
        (finalResults.getResult(VitalSignTypes.pulseRate) as VitalSignPulseRate?)
            ?.value ??
            "N/A";

    var respirationRate = finalResults.getResult(VitalSignTypes.respirationRate)
    as VitalSignRespirationRate?;
    var respirationRateValue = respirationRate?.value ?? "N/A";

    var bloodPressure =
    finalResults.getResult(VitalSignTypes.bloodPressure) as VitalSignBloodPressure?;
    var bloodPressureValue = bloodPressure != null
        ? "${bloodPressure.value.systolic}/${bloodPressure.value.diastolic}"
        : "N/A";

    var hemoglobin = finalResults.getResult(VitalSignTypes.hemoglobin)
    as VitalSignHemoglobin?;
    var hemoglobinValue = hemoglobin?.value ?? "N/A";

    var hemoglobinA1C = finalResults.getResult(VitalSignTypes.hemoglobinA1C)
    as VitalSignHemoglobinA1C?;
    var hemoglobinA1CValue = hemoglobinA1C?.value ?? "N/A";

    var lfhf =
    finalResults.getResult(VitalSignTypes.lfhf) as VitalSignLfhf?;
    var lfhfValue = lfhf?.value ?? "N/A";

    var meanRri = finalResults.getResult(VitalSignTypes.meanRri)
    as VitalSignMeanRri?;
    var meanRriValue = meanRri?.value ?? "N/A";

    var pnsIndex = finalResults.getResult(VitalSignTypes.pnsIndex)
    as VitalSignPnsIndex?;
    var pnsIndexValue = pnsIndex?.value ?? "N/A";

    var pnsZone = finalResults.getResult(VitalSignTypes.pnsZone)
    as VitalSignPnsZone?;
    var pnsZoneValue = pnsZone?.value ?? "N/A";

    var prq = finalResults.getResult(VitalSignTypes.prq) as VitalSignPrq?;
    var prqValue = prq?.value ?? "N/A";

    var rmssd = finalResults.getResult(VitalSignTypes.rmssd)
    as VitalSignRmssd?;
    var rmssdValue = rmssd?.value ?? "N/A";

    var rri = finalResults.getResult(VitalSignTypes.rri) as VitalSignRri?;
    var rriValues =
        rri?.value.map((v) => v.toString()).join(", ") ?? "N/A";

    var sd1 = finalResults.getResult(VitalSignTypes.sd1) as VitalSignSd1?;
    var sd1Value = sd1?.value ?? "N/A";

    var sd2 = finalResults.getResult(VitalSignTypes.sd2) as VitalSignSd2?;
    var sd2Value = sd2?.value ?? "N/A";

    var sdnn = finalResults.getResult(VitalSignTypes.sdnn) as VitalSignSdnn?;
    var sdnnValue = sdnn?.value ?? "N/A";

    var snsIndex = finalResults.getResult(VitalSignTypes.snsIndex)
    as VitalSignSnsIndex?;
    var snsIndexValue = snsIndex?.value ?? "N/A";

    var snsZone = finalResults.getResult(VitalSignTypes.snsZone)
    as VitalSignSnsZone?;
    var snsZoneValue = snsZone?.value ?? "N/A";

    var stressLevel = finalResults.getResult(VitalSignTypes.stressLevel)
    as VitalSignStressLevel?;
    var stressLevelValue = stressLevel?.value ?? "N/A";

    var stressIndex = finalResults.getResult(VitalSignTypes.stressIndex)
    as VitalSignStressIndex?;
    var stressIndexValue = stressIndex?.value ?? "N/A";

    var wellnessIndex = finalResults.getResult(VitalSignTypes.wellnessIndex)
    as VitalSignWellnessIndex?;
    var wellnessIndexValue = wellnessIndex?.value ?? "N/A";

    var wellnessLevel = finalResults.getResult(VitalSignTypes.wellnessLevel)
    as VitalSignWellnessLevel?;
    var wellnessLevelValue = wellnessLevel?.value ?? "N/A";

    finalResultsString =
    "pulse_rate $pulseRateValue\n"
        "Respiration Rate: $respirationRateValue\n"
        "blood_pressure $bloodPressureValue\n"
        "hemoglobin $hemoglobinValue\n"
        "hemoglobin_a1c $hemoglobinA1CValue\n"
        "LF/HF: $lfhfValue\n"
        "Mean RRi: $meanRriValue\n"
        "PNS Index: $pnsIndexValue\n"
        "pns_zone $pnsZoneValue\n"
        "PRQ: $prqValue\n"
        "RMSSD: $rmssdValue\n"
        "rri_values $rriValues\n"
        "SD1: $sd1Value\n"
        "SD2: $sd2Value\n"
        "SDNN: $sdnnValue\n"
        "sns_index $snsIndexValue\n"
        "sns_zone $snsZoneValue\n"
        "stress_level $stressLevelValue\n"
        "stress_index $stressIndexValue\n"
        "wellness_index $wellnessIndexValue\n"
        "wellness_level $wellnessLevelValue";

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
           print( "debug session");
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

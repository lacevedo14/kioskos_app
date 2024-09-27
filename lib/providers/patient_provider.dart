import 'package:flutter/material.dart';
import 'package:flutter_videocall/models/entities/entities.dart';

// class PatientNotifier extends StateNotifier<Patient> {
//   PatientNotifier() : super(Patient(id: 0, patientName: ''));

//   void addPatient(Patient patient) {
//     state = patient;
//   }
// }

// final patientProvider = StateNotifierProvider<PatientNotifier, Patient?>((ref) {
//   return PatientNotifier();
// });

// class PatientNotifier extends StateNotifier<Patient?> {
//   PatientNotifier() : super(null);

//   void setPatient(Patient patient) {
//     state = patient;
//   }
// }

class PatientProvider extends ChangeNotifier {
  Patient? _patient;

  Patient? get patient => _patient;

  set patient(Patient? value) {
    _patient = value;
    notifyListeners();
  }
}
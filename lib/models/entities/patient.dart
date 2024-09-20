import 'dart:convert';

Patient patientFromJson(String str) => Patient.fromJson(json.decode(str));

String patientToJson(Patient data) => json.encode(data.toJson());

class Patient {
    int id;
    String patientName;

    Patient({
        required this.id,
        required this.patientName,
    });

    factory Patient.fromJson(Map<String, dynamic> json) => Patient(
        id: json["id"],
        patientName: json["patient_name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "patient_name": patientName,
    };
}

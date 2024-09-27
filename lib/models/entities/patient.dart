class Patient {
    String id;
    String patientName;

    Patient({
        this.id = '',
        this.patientName = '' ,
    });

     factory Patient.fromJson(Map<String, dynamic> json) => Patient(
        id: json["id"].toString(),
        patientName: json["patient_name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "patient_name": patientName,
    };
}

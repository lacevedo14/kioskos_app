class Patient {
    int id;
    String patientName;

    Patient({
        this.id = 0,
        this.patientName = '' ,
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

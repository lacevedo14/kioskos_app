import 'dart:convert';

RegisterPatient registerPatientFromJson(String str) => RegisterPatient.fromJson(json.decode(str));

String registerPatientToJson(RegisterPatient data) => json.encode(data.toJson());

class RegisterPatient {
    String firstName;
    String lastName;
    String documentTypeId;
    String documentNumber;
    String? birthDate;
    String phone;
    String codPhone;
    String email;
    String gender;
    String isoCountry;
    String paymentCode;
    String responsible;
    String responsiblePhoneCode;
    String responsiblePhone;

    RegisterPatient({
        this.firstName = '',
        this.lastName  = '',
        this.documentTypeId  = '',
        this.documentNumber  = '',
        this.birthDate,
        this.phone  = '',
        this.codPhone  = '',
        this.email = '',
        this.gender  = '',
        this.isoCountry = 'VE',
        this.paymentCode = '',
        this.responsible = '',
        this.responsiblePhoneCode = '',
        this.responsiblePhone = '',
    });

    factory RegisterPatient.fromJson(Map<String, dynamic> json) => RegisterPatient(
        firstName: json["first_name"],
        lastName: json["last_name"],
        documentTypeId: json["document_type_id"],
        documentNumber: json["document_number"],
        birthDate: json["birth_date"],
        phone: json["phone"],
        codPhone: json["cod_phone"],
        email: json["email"],
        gender: json["gender"],
        isoCountry: json["iso_country"],
        paymentCode: json["payment_code"],
        responsible: json["responsible"],
        responsiblePhoneCode: json["responsible_phone_code"],
        responsiblePhone: json["responsible_phone"],
    );

    Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "document_type_id": documentTypeId,
        "document_number": documentNumber,
        "birth_date": birthDate,
        "phone": phone,
        "cod_phone": codPhone,
        "email": email,
        "gender": gender,
        "iso_country": isoCountry,
        "payment_code": paymentCode,
        "responsible": responsible,
        "responsible_phone_code": responsiblePhoneCode,
        "responsible_phone": responsiblePhone
        
    };
}

import 'dart:convert';

Login loginFromJson(String str) => Login.fromJson(json.decode(str));

String loginToJson(Login data) => json.encode(data.toJson());

class Login {
  int documentTypeId = 0;
  int documentNumber = 0;
  String paymentCode = '';

  Login({
    required this.documentTypeId,
    required this.documentNumber,
    required this.paymentCode,
  });

  factory Login.fromJson(Map<String, dynamic> json) => Login(
        documentTypeId: json["document_type_id"],
        documentNumber: json["document_number"],
        paymentCode: json["payment_code"],
      );

  Map<String, dynamic> toJson() => {
        "document_type_id": documentTypeId,
        "document_number": documentNumber,
        "payment_code": paymentCode,
      };
}

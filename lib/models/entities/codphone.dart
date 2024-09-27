import 'dart:convert';

List<CodePhone> codePhoneFromJson(String str) => List<CodePhone>.from(json.decode(str).map((x) => CodePhone.fromJson(x)));

String codePhoneToJson(List<CodePhone> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CodePhone {
    String description;
    String codPhone;

    CodePhone({
        required this.description,
        required this.codPhone,
    });

    factory CodePhone.fromJson(Map<String, dynamic> json) => CodePhone(
        description: json["description"],
        codPhone: json["cod_phone"],
    );

    Map<String, dynamic> toJson() => {
        "description": description,
        "cod_phone": codPhone,
    };
}

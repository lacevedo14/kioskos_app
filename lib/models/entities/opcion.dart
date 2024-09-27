
import 'dart:convert';

List<Opcion> opcionFromJson(String str) => List<Opcion>.from(json.decode(str).map((x) => Opcion.fromJson(x)));

String opcionToJson(List<Opcion> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Opcion {
    String id;
    String description;

    Opcion({
        required this.id,
        required this.description,
    });

    factory Opcion.fromJson(Map<String, dynamic> json) => Opcion(
        id: json["id"],
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
    };
}

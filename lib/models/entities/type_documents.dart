
import 'dart:convert';

List<TypeDocuments> typeDocumentsFromJson(String str) => List<TypeDocuments>.from(json.decode(str).map((x) => TypeDocuments.fromJson(x)));

String typeDocumentsToJson(List<TypeDocuments> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TypeDocuments {
    int id;
    String description;

    TypeDocuments({
        required this.id,
        required this.description,
    });

    factory TypeDocuments.fromJson(Map<String, dynamic> json) => TypeDocuments(
        id: json["id"],
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
    };
}

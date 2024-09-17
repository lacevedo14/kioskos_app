import 'dart:convert';

import 'package:flutter_videocall/models/entities/entities.dart';
import 'package:http/http.dart' as http;

class TypeDocumentsService {
  final String _baseUrl = 'http://192.168.1.9:8000/api';
  final List<TypeDocuments> typeDocument = [];
  bool isLoading = true;

  Future<List<TypeDocuments>> getTypePRovider() async {
    final response = await http.get(Uri.parse('$_baseUrl/document-types'));
    print(response.statusCode);

    if (response.statusCode == 200) {
      //final dataList = json.decode(response.data);
        List jsonResponse = json.decode(response.body);
  return jsonResponse.map((job) => TypeDocuments.fromJson(job)).toList();
       
    } else {
      throw Exception('Failed to load album');
    }
  }
}

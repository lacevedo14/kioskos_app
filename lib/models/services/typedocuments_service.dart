import 'dart:convert';

import 'package:flutter_videocall/models/entities/entities.dart';
import 'package:http/http.dart' as http;

class TypeDocumentsService {
  final String _baseUrl = 'http://192.168.1.12:8000/api';
  
  Future<List<TypeDocuments>> getTypePRovider() async {
    final response = await http.get(Uri.parse('$_baseUrl/document-types'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((job) => TypeDocuments.fromJson(job)).toList();
       
    } else {
      throw Exception('Failed to load album');
    }
  }
}

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_videocall/models/entities/entities.dart';

class TypeDocumentsInformation {


  static const String _baseUrl = 'http://api-egd.test/api';
  
  bool isLoading = true;

  static   Future<Object> getTypePRovider() async {
    final dio = Dio();
    final List<TypeDocuments> typeDocument = [];
    await Future.delayed(const Duration(seconds: 2));

    try {
     final response = await dio.get('$_baseUrl/document-types');
    print(response);

    final Map<String, dynamic> typeDocumentMap =
        json.decode(response as String);

    typeDocumentMap.forEach((key, value) {
      final tempProduct = TypeDocuments.fromJson(value);
      tempProduct.id = key as int;
      typeDocument.add(tempProduct);
    });

    return typeDocument;

    } catch (e) {
      return 'Error';
    }

  }


}
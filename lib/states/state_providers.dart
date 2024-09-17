import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_videocall/config/helpers/type_document_Informations.dart';
import 'package:flutter_videocall/models/controllers/web_rtc/webrtc_controller.dart';
import 'package:flutter_videocall/models/entities/entities.dart';
import 'package:flutter_videocall/models/entities/videocall.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final callStateProvider =
    StateNotifierProvider<CallStateNotifier, VideoCall>((ref) {
  return CallStateNotifier();
});

@Riverpod(keepAlive: true)
Future<TypeDocumentsInformation> getTypeDocument(TypeDocuments ref) async {

  final types = await TypeDocumentsInformation();

  return types;
}
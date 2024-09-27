import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_videocall/models/controllers/web_rtc/webrtc_controller.dart';
import 'package:flutter_videocall/models/entities/entities.dart';
import 'package:flutter_videocall/providers/patient_provider.dart';

final callStateProvider =
    StateNotifierProvider<CallStateNotifier, VideoCall>((ref) {
  return CallStateNotifier();
});


import 'webrtc.dart';

class VideoCall {
  final CallState localVideoInfo;
  final CallState remoteVideoInfo;
  String? idPatient;
  bool audioSetting;
  bool finishCall;

  VideoCall({
    required this.localVideoInfo,
    required this.remoteVideoInfo,
    this.idPatient,
    this.audioSetting = true,
    this.finishCall = false,

  });

  String? get getIdPatient => idPatient;
  CallState get getlocalVideoInfo => localVideoInfo;

  static VideoCall copyWith(
      {required CallState localVideoInfo,
      required CallState remoteVideoInfo,
      String? idPatient,
      required bool audioSetting,
      required bool finishCall }) {
    return VideoCall(
      localVideoInfo: localVideoInfo,
      remoteVideoInfo: remoteVideoInfo,
      idPatient: idPatient,
      finishCall: finishCall,
    );
  }
}

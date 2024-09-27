import 'webrtc.dart';

class VideoCall {
  final CallState localVideoInfo;
  final CallState remoteVideoInfo;
  String? idPatient;

  VideoCall({
    required this.localVideoInfo,
    required this.remoteVideoInfo,
    this.idPatient,
  });

 String? get getIdPatient => idPatient;
 CallState get getlocalVideoInfo => localVideoInfo;
 
  static VideoCall copyWith({
    required CallState localVideoInfo,
    required CallState remoteVideoInfo,
    String? idPatient
  }) {
    return VideoCall(
      localVideoInfo: localVideoInfo,
      remoteVideoInfo: remoteVideoInfo,
      idPatient: idPatient,
    );
  }
}

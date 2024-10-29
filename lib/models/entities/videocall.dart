import 'webrtc.dart';
class VideoCall {

  final CallState localVideoInfo ;
  final CallState remoteVideoInfo;
  String? idPatient;
  String? professionalCard;
  bool audioSetting;
  bool finishCall;
  int idDoctor;

  VideoCall({
    required this.localVideoInfo,
    required this.remoteVideoInfo,
    this.idPatient,
    this.professionalCard,
    this.idDoctor = 0,
    this.audioSetting = true,
    this.finishCall = false,

  });

  String? get getIdPatient => idPatient;
  CallState get getlocalVideoInfo => localVideoInfo;
  int get getIdDoctor => idDoctor;
  
  VideoCall copyWith({
      required CallState localVideoInfo,
      required CallState remoteVideoInfo,
      String? idPatient,
      String? professionalCard,
      required int idDoctor,
      required bool audioSetting,
      required bool finishCall }) {
    return VideoCall(
      localVideoInfo: localVideoInfo,
      remoteVideoInfo: remoteVideoInfo,
      idPatient: idPatient,
      professionalCard: professionalCard,
      idDoctor: idDoctor,
      audioSetting: audioSetting,
      finishCall: finishCall,
    );
  }
}

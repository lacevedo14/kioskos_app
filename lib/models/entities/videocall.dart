import 'webrtc.dart';

class VideoCall {
  final CallState localVideoInfo;
  final CallState remoteVideoInfo;

  VideoCall({
    required this.localVideoInfo,
    required this.remoteVideoInfo,
  });

  static VideoCall copyWith({
    required CallState localVideoInfo,
    required CallState remoteVideoInfo,
  }) {
    return VideoCall(
      localVideoInfo: localVideoInfo,
      remoteVideoInfo: remoteVideoInfo,
    );
  }
}

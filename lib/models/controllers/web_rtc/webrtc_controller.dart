import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_videocall/models/entities/videocall.dart';
import 'package:flutter_videocall/models/entities/webrtc.dart';
import 'package:twilio_programmable_video/twilio_programmable_video.dart';
import 'package:uuid/uuid.dart';

final initLocal = CallState(
    isCalling: false,
    id: '',
    widget: const Scaffold(
        appBar: null, body: Center(child: Text('Sala de Espera'))));
final initRemote = CallState(
    isCalling: false,
    id: '',
    widget: const Scaffold(
        appBar: null, body: Center(child: Text('Espera Doctor'))));

class CallStateNotifier extends StateNotifier<VideoCall> {
  CallStateNotifier()
      : super(
            VideoCall(localVideoInfo: initLocal, remoteVideoInfo: initRemote)) {
    debugPrint('$tag: initialized');
    initializeWebRtc();
  }

  static const tag = 'WebRtcController';

  late CameraCapturer _cameraCapturer;
  late Room _room;
  late final List<StreamSubscription> _streamSubscriptions = [];

  Future<void> initializeWebRtc() async {
    await TwilioProgrammableVideo.debug(dart: true, native: true);
    await TwilioProgrammableVideo.requestPermissionForCameraAndMicrophone();

    final sources = await CameraSource.getSources();
    _cameraCapturer = CameraCapturer(
      sources.firstWhere((source) => source.isFrontFacing),
    );
    var trackId = const Uuid().v4();

    var connectOptions = ConnectOptions(
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsImN0eSI6InR3aWxpby1mcGE7dj0xIn0.eyJqdGkiOiJTSzJjMjZlYjA3Y2U4ZmI4NmU4NzFkOWU5YTQwNmUyODZlLTE3MjYwODkyMTAiLCJpc3MiOiJTSzJjMjZlYjA3Y2U4ZmI4NmU4NzFkOWU5YTQwNmUyODZlIiwic3ViIjoiQUNhMTgyNjAyYjMwN2M0ZDY5NDk1OWMyMzIzMjY0ZTcwOCIsImV4cCI6MTcyNjA5MjgxMCwiZ3JhbnRzIjp7ImlkZW50aXR5IjoiNjZlMjA3ZmE1MDIxYyIsInZpZGVvIjp7InJvb20iOiJURVNURVIifX19.Nl0WXfcO_fSRqZFaWDiFtgUykWRBwCcl7YUYAZiZtaI',
      roomName: 'TESTER',
      preferredAudioCodecs: [OpusCodec()],
      audioTracks: [LocalAudioTrack(true, 'audio_track-$trackId')],
      dataTracks: [
        LocalDataTrack(
          DataTrackOptions(name: 'data_track-$trackId'),
        )
      ],
      videoTracks: [LocalVideoTrack(true, _cameraCapturer)],
      enableNetworkQuality: true,
      networkQualityConfiguration: NetworkQualityConfiguration(
        remote: NetworkQualityVerbosity.NETWORK_QUALITY_VERBOSITY_MINIMAL,
      ),
      enableDominantSpeaker: true,
    );

    _room = await TwilioProgrammableVideo.connect(connectOptions);

    _room.onConnected.listen(_onConnected);
    _room.onConnectFailure.listen(_onConnectFailure);
  }

  Future<void> disconnect() async {
    print('[ APPDEBUG ] ConferenceRoom.disconnect()');
    await _room.disconnect();
  }

  void _onDisconnected(RoomDisconnectedEvent event) {
    print('[ APPDEBUG ] ConferenceRoom._onDisconnected');
  }

  void _onReconnecting(RoomReconnectingEvent room) {
    print('[ APPDEBUG ] ConferenceRoom._onReconnecting');
  }

  void _onConnected(Room room) {
    final localTrack =
        room.localParticipant?.localVideoTracks[0].localVideoTrack;
    final localWidget = localTrack?.widget();
    state = VideoCall.copyWith(
        localVideoInfo: CallState(
            isCalling: true,
            id: _room.localParticipant!.identity,
            widget: localWidget),
        remoteVideoInfo: initRemote);
    final localParticipant = room.localParticipant;
    if (localParticipant == null) {
      print(
          '[ APPDEBUG ] ConferenceRoom._onConnected => localParticipant is null');
      return;
    }
  }

  void _onConnectFailure(RoomConnectFailureEvent event) {
    print('[ APPDEBUG ] ConferenceRoom._onConnectFailure: ${event.exception}');
  }
}

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_videocall/models/entities/videocall.dart';
import 'package:flutter_videocall/models/entities/webrtc.dart';
import 'package:flutter_videocall/models/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twilio_programmable_video/twilio_programmable_video.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_videocall/utils/math_utils.dart';

final initLocal = CallState(
    isCalling: false,
    id: '',
    widget: const Scaffold(
        appBar: null, body: Center(child: Text('Conectando...'))));
final initRemote = CallState(
    isCalling: false,
    id: '',
    widget: Scaffold(
        appBar: null,
        body: Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: size.height * 0.1,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                image: AssetImage('assets/images/logo_planimedic.png'),
                fit: BoxFit.scaleDown,
              )),
            ),
            const SizedBox(height: 20),
            const Text('Espere un momento buscando doctor.'),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              color: Color(0xFF2087C9),
            ),
          ],
        ))));

class CallStateNotifier extends StateNotifier<VideoCall> {
  CallStateNotifier()
      : super(VideoCall(
            localVideoInfo: initLocal,
            remoteVideoInfo: initRemote,
            finishCall: false,
            audioSetting: true)) {
    debugPrint('$tag: initialized');
    initDoctor();
    //initializeWebRtc();
  }

  static const tag = 'WebRtcController';
  bool speakerphoneEnabled = true;
  bool bluetoothPreferred = false;
  late CameraCapturer _cameraCapturer;
  late Room _room;
  final _remoteParticipantSubscriptions = <StreamSubscription>[];
  late String newProfecionalCard;

  Future<void> initDoctor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var doctorId = prefs.getInt('idDoctor') ?? 0;
    newProfecionalCard = prefs.getString('professionalCard') ?? '';
    if (doctorId != 0) {
      updateDoctorId(doctorId);
      initializeWebRtc();
    } else {
      startChecking();
    }
  }

  Future<void> initializeWebRtc() async {
    //await TwilioProgrammableVideo.debug(dart: true, native: true);
    await TwilioProgrammableVideo.requestPermissionForCameraAndMicrophone();

    final sources = await CameraSource.getSources();
    _cameraCapturer = CameraCapturer(
      sources.firstWhere((source) => source.isFrontFacing),
    );
    await TwilioProgrammableVideo.setAudioSettings(
        speakerphoneEnabled: speakerphoneEnabled,
        bluetoothPreferred: bluetoothPreferred);

    var trackId = const Uuid().v4();
    //final dataAppoiment = await _apiService.getRoom(state.getIdPatient);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var dataRoom = prefs.getString('room') ?? '';
    var dataToken = prefs.getString('token') ?? '';
    if (dataRoom != '' && dataToken != '') {
      var connectOptions = ConnectOptions(
        dataToken,
        roomName: dataRoom,
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

      if (_room != null) {
        _room.onConnected.listen(_onConnected);
        _room.onConnectFailure.listen(_onConnectFailure);
        _room.onDisconnected.listen(_onDisconnected);
      }
    }
    // _room.onConnected.listen(_onConnected);
    // _room.onConnectFailure.listen(_onConnectFailure);
  }

  Future<void> disconnect() async {
    log('[ APPDEBUG ] ConferenceRoom.disconnect()');
    await TwilioProgrammableVideo.disableAudioSettings();
    await _room.disconnect();
  }

  void _onDisconnected(RoomDisconnectedEvent event) {
    log('[ APPDEBUG ] ConferenceRoom._onDisconnected  ${event.room.name}');
    state = state.copyWith(
        idDoctor: state.idDoctor,
        localVideoInfo: initLocal,
        remoteVideoInfo: initRemote,
        audioSetting: false,
        finishCall: true);
  }

  void _onReconnecting(RoomReconnectingEvent room) {
    log('[ APPDEBUG ] ConferenceRoom._onReconnecting');
  }

  void _onConnected(Room room) {
    log('ConferenceRoom._onConnected => state: ${room.state}');

    final localTrack =
        room.localParticipant?.localVideoTracks[0].localVideoTrack;

    final localWidget = localTrack?.widget();
    final tracks = room.localParticipant?.localAudioTracks ?? [];

    final localAudioTrack = tracks.isEmpty ? null : tracks[0].localAudioTrack;

    state = state.copyWith(
        idDoctor: state.idDoctor,
        localVideoInfo: CallState(
            isCalling: true,
            id: room.localParticipant!.identity,
            widget: localWidget,
            networkLevel: room.localParticipant!.networkQualityLevel.index),
        remoteVideoInfo: initRemote,
        audioSetting: localAudioTrack!.isEnabled,
        finishCall: false);

    final localParticipant = room.localParticipant;
    //final remoteParticipant = room.remoteParticipants[0];
    room.onParticipantConnected.listen(_onParticipantConnected);
    room.onParticipantDisconnected.listen(_onParticipantDisconnected);

    if (localParticipant == null) {
      log('[ APPDEBUG ] ConferenceRoom._onConnected => localParticipant is null');
      return;
    }
    for (final remoteParticipant in room.remoteParticipants) {
      if (state.remoteVideoInfo.id != remoteParticipant.identity) {
        final subscription = remoteParticipant.onVideoTrackSubscribed.listen(
          (event) {
            if (state.remoteVideoInfo.id == remoteParticipant.identity) {
              return;
            }

            final widget = event.remoteVideoTrack.widget();
            final id = event.remoteParticipant.identity;
            state = state.copyWith(
              idDoctor: state.idDoctor,
              localVideoInfo: state.localVideoInfo,
              audioSetting: state.audioSetting,
              professionalCard: newProfecionalCard,
              finishCall: false,
              remoteVideoInfo: CallState(
                  isCalling: true,
                  id: id,
                  widget: widget,
                  networkLevel: remoteParticipant.networkQualityLevel.index),
            );
          },
        );
        _remoteParticipantSubscriptions.add(subscription);
      }
    }
  }

  void _onConnectFailure(RoomConnectFailureEvent event) {
    log('Failed to connect to room ${event.room.name} with exception: ${event.exception}');
  }

  void _onParticipantConnected(RoomParticipantConnectedEvent event) {
    final subscription = event.remoteParticipant.onVideoTrackSubscribed.listen(
      (event) {
        if (state.remoteVideoInfo.id == event.remoteParticipant.identity) {
          return;
        }

        final widget = event.remoteVideoTrack.widget();
        final id = event.remoteParticipant.identity;
        state = state.copyWith(
          idDoctor: state.idDoctor,
          localVideoInfo: state.localVideoInfo,
          audioSetting: state.audioSetting,
          professionalCard: newProfecionalCard,
          finishCall: false,
          remoteVideoInfo: CallState(
              isCalling: true,
              id: id,
              widget: widget,
              networkLevel: event.remoteParticipant.networkQualityLevel.index),
        );
      },
    );
    _remoteParticipantSubscriptions.add(subscription);
  }

  void _onParticipantDisconnected(RoomParticipantDisconnectedEvent event) {
    log('Participant ${event.remoteParticipant.identity} has left the room');
    state = state.copyWith(
        idDoctor: state.idDoctor,
        localVideoInfo: initLocal,
        remoteVideoInfo: initRemote,
        finishCall: true,
        audioSetting: false);
  }

  void toggleAudioEnabled() async {
    final tracks = _room.localParticipant?.localAudioTracks ?? [];
    final localAudioTrack = tracks.isEmpty ? null : tracks[0].localAudioTrack;
    if (localAudioTrack == null) {
      log('ConferenceRoom.toggleAudioEnabled() => Track is not available yet!');
      return;
    }
    await localAudioTrack.enable(!localAudioTrack.isEnabled);
    state = state.copyWith(
        idDoctor: state.idDoctor,
        localVideoInfo: state.localVideoInfo,
        remoteVideoInfo: state.remoteVideoInfo,
        finishCall: false,
        audioSetting: localAudioTrack.isEnabled);
  }

  Timer? timer;

  void startChecking() {
    const duration = Duration(seconds: 45);
    timer = Timer.periodic(duration, (timer) async {
      await checkDoctorValue();
    });
  }

  checkDoctorValue() async {
    final ApiService _apiService = ApiService();
    Map data = await _apiService.getCheckDoctor();
    if (data['success']) {
      state = state.copyWith(
          localVideoInfo: state.localVideoInfo,
          idDoctor: data['doctor_id'],
          professionalCard: data['tuition_number'],
          remoteVideoInfo: state.remoteVideoInfo,
          finishCall: false,
          audioSetting: state.audioSetting);
      initializeWebRtc();
      timer?.cancel();
    }
  }

  void updateDoctorId(int newId) {
    state = state.copyWith(
        localVideoInfo: state.localVideoInfo,
        idDoctor: newId,
        remoteVideoInfo: state.remoteVideoInfo,
        finishCall: false,
        audioSetting: state.audioSetting);
  }
}

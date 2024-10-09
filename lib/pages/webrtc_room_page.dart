import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_videocall/models/providers/patient_provider.dart';
import 'package:flutter_videocall/states/state_providers.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart' as providers;

class CallScreen extends ConsumerWidget {
  const CallScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final callState = ref.watch(callStateProvider);
    final patientForm = providers.Provider.of<PatientProvider>(context);
    ref.read(callStateProvider).idPatient = patientForm.patient!.id as String?;
    if (callState.finishCall) {
      WidgetsBinding.instance.addPostFrameCallback((_) => context.go('/'));
    }
    return Scaffold(
      appBar: null,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _videoWidget(context, callState.localVideoInfo.widget as Widget,
              callState.localVideoInfo.id),
          _videoWidget(context, callState.remoteVideoInfo.widget as Widget,
              callState.remoteVideoInfo.id),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          ref.read(callStateProvider.notifier).toggleAudioEnabled();
        },
        backgroundColor: Colors.red,
        child: Icon(
          callState.audioSetting ? Icons.mic : Icons.mic_off,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _videoWidget(BuildContext context, Widget widget, String name) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return SizedBox(
      width: width,
      height: height / 2.0,
      child: Stack(
        children: [
          widget,
          Positioned(
            top: 60,
            left: 20,
            child: Text(name,
                style: const TextStyle(
                    color: Colors.indigo,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold)),
          ),
          const Positioned(
            top: 60,
            right: 20,
            child: Icon(Icons.signal_cellular_alt_rounded,
                size: 40, color: Colors.indigo),
          ),
        ],
      ),
    );
  }
}

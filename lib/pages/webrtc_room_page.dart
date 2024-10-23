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

    ref.read(callStateProvider).idPatient = patientForm.patient!.id.toString();
    if (callState.finishCall) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => context.go('/survey'));
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Center(
          child: Image.asset(
            'assets/images/logo_planimedic.png',
            height: 50,
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: callState.remoteVideoInfo.widget,
            ),
          ),
          Positioned(
            top: 30,
            left: 10,
            child: Text(
              callState.remoteVideoInfo.id,
              style: const TextStyle(
                  color: Color.fromARGB(255, 15, 15, 15),
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: Container(
              width: 200,
              height: 200,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: callState.localVideoInfo.widget,
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: Text(
              callState.localVideoInfo.id,
              style: const TextStyle(
                  color: Color.fromARGB(255, 15, 15, 15),
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
          ),
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
                    color: Color(0xFF2087C9),
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold)),
          ),
          const Positioned(
            top: 60,
            right: 20,
            child: Icon(Icons.signal_cellular_alt_rounded,
                size: 40, color: Color(0xFF2087C9)),
          ),
        ],
      ),
    );
  }
}

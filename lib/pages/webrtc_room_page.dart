import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_videocall/models/controllers/controllers.dart';
import 'package:flutter_videocall/providers/patient_provider.dart';
import 'package:flutter_videocall/states/state_providers.dart';
import 'package:provider/provider.dart' as providers;

class CallScreen extends ConsumerWidget {
  const CallScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final callState = ref.watch(callStateProvider);
    final patientForm = providers.Provider.of<PatientProvider>(context);
    ref.read(callStateProvider).idPatient = patientForm.patient!.id as String?;
    return Scaffold(
      appBar: null,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _videoWidget(context, callState.localVideoInfo.widget as Widget),
          _videoWidget(context, callState.remoteVideoInfo.widget as Widget),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          
        },
        backgroundColor: Colors.red,
        child: const Icon(
          Icons.mic_none_outlined,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _videoWidget(BuildContext context, Widget widget) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return SizedBox(
      width: width,
      height: height / 2.0,
      child: widget,
    );
  }
}

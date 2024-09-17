import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_videocall/states/state_providers.dart';

class CallScreen extends ConsumerWidget {
  const CallScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final callState = ref.watch(callStateProvider);
    // ignore: avoid_print
    print('[ APPDEBUG ] callState');
    return Scaffold(
      appBar: null,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _videoWidget(context,
              ref.read(callStateProvider).localVideoInfo.widget as Widget),
          _videoWidget(context,
              ref.read(callStateProvider).remoteVideoInfo.widget as Widget),
        ],
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

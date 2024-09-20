import 'package:flutter/material.dart';
import 'package:flutter_videocall/pages/webrtc_room_page.dart';
import 'package:go_router/go_router.dart';

class EntryPage extends StatelessWidget {
  const EntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Twilio Sample'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Twilio VideoRoom',
              ),

              TextButton(
                style: ButtonStyle(
                  foregroundColor: WidgetStateProperty.all<Color>(Colors.blue),
                ),
                onPressed: () => context.go('/call-screen'),
                // onPressed: () { 
                //   Navigator.of(context).push<MaterialPageRoute>(
                //     MaterialPageRoute(
                //       builder: (context) {
                //         return const CallScreen();
                //       },
                //     ),
                //   );
                // },
                child: const Text('Enter'),
              ),
            ],
          ),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}

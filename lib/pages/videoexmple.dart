import 'package:flutter/material.dart';

class VideoCallScreen extends StatefulWidget {
  @override
  _VideoCallScreenState createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  // ... inicialización de Agora RTC Engine

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Scaffold(
                  appBar: null, body: Center(child: Text('Doctor en Espera'))),
            ),
          ),
          const Positioned(
            top: 10,
            left: 10,
            child: Text(
              'Nombre del participante remoto',
              style: TextStyle(color: Color.fromARGB(255, 23, 22, 22)),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white),
              ),
              child: const AspectRatio(
                aspectRatio: 16 / 9,
                child: Scaffold(
                    appBar: null,
                    body: Center(child: Text('Paciente en Espera'))),
              ),
            ),
          ),
          const Positioned(
            bottom: 10,
            right: 10,
            child: Text(
              'Nombre del participante local',
              style: TextStyle(color: Color.fromARGB(255, 15, 15, 15)),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_videocall/config/router/app_router.dart';
import 'package:flutter_videocall/models/models.dart';
import 'package:flutter_videocall/models/providers/patient_provider.dart';
import 'package:flutter_videocall/models/providers/register_patient_providers.dart';
import 'package:provider/provider.dart' as providers;
import 'package:flutter_videocall/models/services/services.dart';

import 'package:provider/provider.dart';

void main() {
  runApp(
    Phoenix(
      child: 
    ProviderScope(
      child: MultiProvider(
        providers: [
          providers.ChangeNotifierProvider(create: (_) => LoginService()),
          providers.ChangeNotifierProvider(
              create: (_) => RegisterPatientProvider()),
          providers.ChangeNotifierProvider(create: (_) => PatientProvider()),
          providers.ChangeNotifierProvider(create: (_) => MeasurementModel()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const MainApp(),
          theme: ThemeData(
            fontFamily: "Canapa",
            colorScheme: ColorScheme.fromSeed(
              seedColor: Color(0xFF2087C9),
            ),
          ),
        ),
      ),
    ),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: ThemeData(
        fontFamily: "Canapa",
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF2087C9),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_videocall/config/router/app_router.dart';
import 'package:flutter_videocall/models/facial_scan/measurement_model.dart';
import 'package:flutter_videocall/providers/patient_provider.dart';
import 'package:flutter_videocall/providers/register_patient_providers.dart';
import 'package:provider/provider.dart' as providers;
import 'package:flutter_videocall/models/services/services.dart';

import 'package:provider/provider.dart';

void main() {
  runApp(
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
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.indigo,
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
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_videocall/config/router/app_router.dart';
import 'package:flutter_videocall/providers/register_patient_providers.dart';
import 'package:provider/provider.dart' as Providers;
import 'package:flutter_videocall/models/services/services.dart';

import 'package:provider/provider.dart';

void main() {
  runApp(
    ProviderScope(
      child: MultiProvider(
        providers: [
          Providers.ChangeNotifierProvider(create: (_) => LoginService()),
          Providers.ChangeNotifierProvider(
              create: (_) => RegisterPatientProvider())
        ],
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: MainApp(),
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
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}

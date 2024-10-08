import 'package:flutter_videocall/pages/pages.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  routes: [

    GoRoute(
      path: '/',
      builder: (context, state) => const Home(),
    ),

    GoRoute(
      path: '/sign-in',
      builder: (context, state) => const SignIn(),
    ),

    GoRoute(
      path: '/sign-up',
      builder: (context, state) => const SignUp(),
    ),

    GoRoute(
      path: '/entry-page',
      builder: (context, state) => const EntryPage(),
    ),
    
    GoRoute(
      path: '/call-screen',
      builder: (context, state) => const CallScreen(),
    ),
    GoRoute(
      path: '/facial-scan',
      builder: (context, state) => const MeasurementScreen(),
    ),

  ]
);
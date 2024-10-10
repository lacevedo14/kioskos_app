
import 'package:flutter_videocall/pages/pages.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  routes: [

    GoRoute(
      path: '/survey',
      builder: (context, state) =>  SurveyScreen(),
    ),

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
    GoRoute(
      path: '/use',
      builder: (context, state) => const ConsentUseScreen(),
    ),
    GoRoute(
      path: '/step1',
      builder: (context, state) => const Step1Screen(),
    ),
    GoRoute(
      path: '/step2',
      builder: (context, state) => const Step2Screen(),
    ),
    GoRoute(
      path: '/step3',
      builder: (context, state) => const Step3Screen(),
    ),
    GoRoute(
      path: '/generate-code',
      builder: (context, state) => const GeneratePaymentCode(),
    ),
    GoRoute(
      path: '/view-code/:code',
      name: 'view-code',
      builder: (context, state) =>  ViewCodePayment(
        code:state.pathParameters['code']
      ),
    ),
  ]
);
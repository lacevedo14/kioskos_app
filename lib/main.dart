import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_videocall/pages/sign_up.dart';
import 'package:flutter_videocall/pages/sing_in.dart';
import 'pages/entry_page.dart';

void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SignUp(),
      ),
    ),
  );
}

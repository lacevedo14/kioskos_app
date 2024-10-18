import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: size.height * 0.2,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                image: AssetImage('assets/logo_egd.png'),
                fit: BoxFit.scaleDown,
              )),
            ),
            const SizedBox(height: 20),
            const Text('Espere un momento buscando doctor.'),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              color: Colors.indigo,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_videocall/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AuthBackground(
            child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Column(
          children: [
            const SizedBox(height: 400),
            SizedBox(
                width: double.infinity,
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  disabledColor: Colors.grey,
                  elevation: 0,
                  color: Colors.indigo,
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      child: const Text(
                        'Ingresar',
                        style: TextStyle(color: Colors.white),
                      )),
                  onPressed: () => context.go('/sign-in'),
                )),
            const SizedBox(height: 50),
            SizedBox(
                width: double.infinity,
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  disabledColor: Colors.grey,
                  elevation: 0,
                  color: Colors.indigo,
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      child: const Text(
                        'Registrarse',
                        style: TextStyle(color: Colors.white),
                      )),
                  onPressed: () => context.go('/sign-up'),
                )),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                disabledColor: Colors.grey,
                elevation: 0,
                color: Colors.indigo,
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    child: const Text(
                      'Scan Facial',
                      style: TextStyle(color: Colors.white),
                    )),
                onPressed: () => context.go('/facial-scan'),
              ),
            ),
          ],
        ),
      ),
    )));
  }
}

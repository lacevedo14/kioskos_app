import 'package:flutter/material.dart';
import 'package:flutter_videocall/models/providers/patient_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class EntryPage extends StatelessWidget {
  const EntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final patientForm = Provider.of<PatientProvider>(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: size.height * 0.2,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage('assets/images/logo_planimedic.png'),
                  fit: BoxFit.scaleDown,
                )),
              ),
              const SizedBox(height: 20),
              Text(
                'Bienvenido ${patientForm.patient?.patientName}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              // const SizedBox(height: 20),
              // SizedBox(
              //   width: size.width * 0.4,
              //   child: ElevatedButton(
              //     onPressed: () => context.go('/call-screen'),
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: Color(0xFF2087C9),
              //       padding: const EdgeInsets.symmetric(
              //           horizontal: 32, vertical: 16),
              //       shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(10)),
              //     ),
              //     child: const Text(
              //       'Ingresar',
              //       style: TextStyle(
              //           color: Colors.white,
              //           fontSize: 16,
              //           fontWeight: FontWeight.bold),
              //     ),
              //   ),
              // ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => context.go('/use'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2087C9),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text(
                  'Scan Facial',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

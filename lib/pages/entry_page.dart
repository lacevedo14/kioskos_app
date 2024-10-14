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
      appBar: AppBar(
        title: const Text('Sala de espera'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: size.height * 0.2,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage('assets/logo_egd.png'),
                  fit: BoxFit.scaleDown,
                )),
              ),
              const SizedBox(height: 20),
              Text(
                'Bienvendio ${patientForm.patient?.patientName}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 20),
              SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      MaterialButton(
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
                        onPressed: () => context.go('/call-screen'),
                      ),
                      const SizedBox(height: 20),
                      MaterialButton(
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
                        onPressed: () => context.go('/use'),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

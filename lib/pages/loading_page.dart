import 'package:flutter/material.dart';
import 'package:flutter_videocall/models/providers/doctor_provider.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //  final doctorCheck = providers.Provider.of<DoctorCheckerProvider>(context,listen: false);
    // if( doctorCheck.idDoctor == 0 ) return LoadingPage();
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
                image: AssetImage('assets/images/logo_planimedic.png'),
                fit: BoxFit.scaleDown,
              )),
            ),
            const SizedBox(height: 20),
            const Text('Espere un momento buscando doctor.'),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              color: Color(0xFF2087C9),
            ),
          ],
        ),
      ),
    );
  }
}

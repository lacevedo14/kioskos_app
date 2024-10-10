import 'package:flutter/material.dart';
import 'package:flutter_videocall/pages/translations.dart';
import 'package:go_router/go_router.dart';

class ViewCodePayment extends StatefulWidget {
   String? code;
   ViewCodePayment({super.key, this.code});

  @override
  State<ViewCodePayment> createState() => _ViewCodePaymentState();
}

class _ViewCodePaymentState extends State<ViewCodePayment> {
 
  final String _selectedLanguage = 'ESP';
  String? paymentCode;

  @override
  Widget build(BuildContext context) {
     final code = widget.code; 
     final size = MediaQuery.of(context).size;
        return Scaffold(
      appBar: AppBar(
        title: const Text(''),
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
                        fit: BoxFit.scaleDown)),
              ),
              const SizedBox(height: 20),
              Text(
                translations[_selectedLanguage]!['code_view']!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 20),
              Text(
                code ?? 'no se ve mi codigo de pago ',
                textAlign: TextAlign.center,
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
                              child: Text(
                                translations[_selectedLanguage]!['next']!,
                                style: TextStyle(color: Colors.white),
                              )),
                          onPressed: ()  => context.go('/')),
                      const SizedBox(height: 20),
                    ],
                  )),
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
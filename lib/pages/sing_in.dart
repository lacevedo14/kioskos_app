import 'package:flutter/material.dart';
import 'package:flutter_videocall/models/entities/entities.dart';
import 'package:flutter_videocall/pages/pages.dart';
import 'package:flutter_videocall/providers/login_form_provider.dart';
import 'package:flutter_videocall/ui/input_decorations.dart';
import 'package:flutter_videocall/widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

//final Future<TypeDocuments> list = typedocumentdata.getTypePRovider();

const List<String> list1 = <String>['DNI', 'CE', 'PA'];

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Inicio de Sesion';

    return Scaffold(
        body: AuthBackground(
            child: SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 250),
          CardContainer(
              child: Column(
            children: [
              const SizedBox(height: 10),
              Text('Login', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 30),
              ChangeNotifierProvider(
                  create: (_) => LoginFormProvider(), child: MyLoginForm())
            ],
          )),
          const SizedBox(height: 50),
                        TextButton(
                style: ButtonStyle(
                  foregroundColor: WidgetStateProperty.all<Color>(Colors.blue),
                ),
                onPressed: () => context.go('/sign-up'),
                child: const Text('Crear una nueva cuenta'),
              ),
          const SizedBox(height: 50),
        ],
      ),
    )));
  }
}

class MyLoginForm extends StatefulWidget {
  const MyLoginForm({super.key});

  @override
  MyLoginFormState createState() {
    return MyLoginFormState();
  }
}

class MyLoginFormState extends State<MyCustomForm> {
  String dropdownValue = '';
  
  late Future<List<TypeDocuments>> list;
  @override
  void initState() {
    super.initState();
    list = typedocumentdata.getTypePRovider();
  }

  @override
  Widget build(BuildContext context) {
    //final loginService = Provider.of<LoginService>(context);
    final loginForm = Provider.of<LoginFormProvider>(context);
    // Build a Form widget using the _formKey created above.
    return Form(
        key: loginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder(
                future: list,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return DropdownButtonFormField<String>(
                      decoration: InputDecorations.authInputDecoration(
                        hintText: 'Seleccione su tipo Documento',
                        labelText: 'Tipo de Documento',
                      ),
                      value: null,
                      items: snapshot.data!.map((value) {
                        return DropdownMenuItem<String>(
                            value: value.id.toString(),
                            child: Text(value.description));
                      }).toList(),
                      onChanged: (String? value) =>
                          loginForm.documentTypeId = value!,
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return const CircularProgressIndicator();
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                onChanged: (value) => loginForm.documentNumber = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                decoration: InputDecorations.authInputDecoration(
                  hintText: 'Ingrese su Documento',
                  labelText: 'Documento',
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                onChanged: (value) => loginForm.paymentCode = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                decoration: InputDecorations.authInputDecoration(
                  hintText: 'Ingrese el Codigo de Pago',
                  labelText: 'Codigo de Pago',
                ),
              ),
              SizedBox(height: 30),
              SizedBox(
                  width: double.infinity,
                  child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      disabledColor: Colors.grey,
                      elevation: 0,
                      color: Colors.deepPurple,
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          child: Text(
                            loginForm.isLoading ? 'Espere' : 'Ingresar',
                            style: const TextStyle(color: Colors.white),
                          )),
                      onPressed: loginForm.isLoading
                          ? null
                          : () async {
                              FocusScope.of(context).unfocus();

                              if (!loginForm.isValidForm()) return;
                              loginForm.isLoading = true;
                              //final Future<String> response = loginForm.loginUser();
                              //final String response = await loginService.loginUser(loginForm);
                              //print(response);
                              loginForm.isLoading = false;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('bien')),
                              );
                              //Navigator.pushReplacementNamed(context, 'home');
                            }))
            ],
          ),
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_videocall/models/entities/entities.dart';
import 'package:flutter_videocall/models/services/login_service.dart';
import 'package:flutter_videocall/models/providers/login_form_provider.dart';
import 'package:flutter_videocall/models/providers/patient_provider.dart';
import 'package:flutter_videocall/models/services/services.dart';
import 'package:flutter_videocall/ui/input_decorations.dart';
import 'package:flutter_videocall/widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

//final Future<TypeDocuments> list = typedocumentdata.getTypePRovider();

const List<String> list1 = <String>['DNI', 'CE', 'PA'];

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Inicio de Sesion';

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
              onPressed: () => context.go('/'),
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
        ),
        body: AuthBackground(
            child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 150),
              CardContainer(
                  child: Column(
                children: [
                  const SizedBox(height: 10),
                  Text('Login',
                      style: Theme.of(context).textTheme.headlineMedium),
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

class MyLoginFormState extends State<MyLoginForm> {
  String dropdownValue = '';
  final ApiService _apiService = ApiService();
  late Future<List<TypeDocuments>> list;
   SharedPreferencesAsync  prefs = SharedPreferencesAsync();
  @override
  void initState() {
    super.initState();
    list = _apiService.getTypePRovider();
  }

  @override
  Widget build(BuildContext context) {
    final loginService = Provider.of<LoginService>(context);
    final loginForm = Provider.of<LoginFormProvider>(context);
    final patient = Provider.of<PatientProvider>(context);
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
                      isExpanded: true,
                      decoration: InputDecorations.authInputDecoration(
                        hintText: 'Seleccione su tipo Documento',
                        labelText: 'Tipo de Documento',
                      ),
                      value: null,
                      items: snapshot.data!.map((value) {
                        return DropdownMenuItem<String>(
                            value: value.id.toString(),
                            child: Text(value.description,
                                overflow: TextOverflow.ellipsis));
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
                keyboardType: TextInputType.number,
                onChanged: (value) => loginForm.documentNumber = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo requerido';
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
                    return 'Campo requerido';
                  }
                  return null;
                },
                decoration: InputDecorations.authInputDecoration(
                  hintText: 'Ingrese el Codigo de Pago',
                  labelText: 'Codigo de Pago',
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                  width: double.infinity,
                  child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      disabledColor: Colors.grey,
                      elevation: 0,
                      color: Colors.indigo,
                      onPressed: loginForm.isLoading
                          ? null
                          : () async {
                              FocusScope.of(context).unfocus();

                              if (!loginForm.isValidForm()) return;
                              loginForm.isLoading = true;
                              //final Future<String> response = loginForm.loginUser();
                              Map response =
                                  await loginService.loginUser(loginForm);
                              loginForm.isLoading = false;
                              if (response['success']) {
                                patient.patient = response['patient'];
                                await prefs.setString('idPatient', response['patient']['id']);
                                context.go('/entry-page');
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(response['message'])),
                                );
                              }
                              //print(response);
                              loginForm.isLoading = false;
                              //Navigator.pushReplacementNamed(context, 'home');
                            },
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          child: Text(
                            loginForm.isLoading ? 'Espere' : 'Ingresar',
                            style: const TextStyle(color: Colors.white),
                          ))))
            ],
          ),
        ));
  }
}

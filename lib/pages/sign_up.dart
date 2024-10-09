import 'package:flutter/material.dart';
import 'package:flutter_videocall/models/entities/entities.dart';
import 'package:flutter_videocall/models/services/services.dart';
import 'package:flutter_videocall/models/providers/patient_provider.dart';
import 'package:flutter_videocall/models/providers/register_patient_providers.dart';
import 'package:flutter_videocall/ui/input_decorations.dart';
import 'package:flutter_videocall/widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';



class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Registro';
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
              const SizedBox(height: 100),
              CardContainer(
                  child: Column(
                children: [
                  const SizedBox(height: 10),
                  Text('Registro',
                      style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 20),
                  ChangeNotifierProvider(
                      create: (_) => RegisterPatientProvider(),
                      child: MyCustomForm())
                ],
              )),
              const SizedBox(height: 50),
            ],
          ),
        )));
  }
}

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  String dropdownValue = '';
  late Future<List<TypeDocuments>> list;
  late Future<List<Opcion>> gender;
  late Future<List<CodePhone>> codes;
  final ApiService _apiService = ApiService();
  @override
  void initState() {
    super.initState();
    list = _apiService.getTypePRovider();
    gender = _apiService.getGender();
    codes = _apiService.getCodePhone();
  }

  _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime lastYear = DateTime(now.year - 1);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: lastYear,
      lastDate: now,
    );
    if (picked != null) {
      return picked;
    }
  }

  @override
  Widget build(BuildContext context) {
    final registerForm = Provider.of<RegisterPatientProvider>(context);
    final patientFinal = Provider.of<PatientProvider>(context);
    final patient = registerForm.patient;
    return Form(
        key: registerForm.registerKey,
        child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo requerido';
                      }
                      return null;
                    },
                    decoration: InputDecorations.authInputDecoration(
                      labelText: 'Nombre',
                      hintText: 'Ingrese su Nombre',
                    ),
                    onChanged: (value) => patient.firstName = value,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    onChanged: (value) => patient.lastName = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo requerido';
                      }
                      return null;
                    },
                    decoration: InputDecorations.authInputDecoration(
                      labelText: 'Apellido',
                      hintText: 'Ingrese su Apellido',
                    ),
                  ),
                  const SizedBox(height: 20),
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
                                child: Text(
                                  value.description,
                                  overflow: TextOverflow.ellipsis,
                                ));
                          }).toList(),
                          onChanged: (String? value) =>
                              patient.documentTypeId = value!,
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
                    onChanged: (value) => patient.documentNumber = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingrese un documento válido';
                      }
                      return null;
                    },
                    decoration: InputDecorations.authInputDecoration(
                      hintText: 'V-000000000',
                      labelText: 'Documento',
                    ),
                  ),
                  const SizedBox(height: 20),
                  // TextButton(
                  //     onPressed: () => _selectDate(context),
                  //     child: Text('Fecha de Nacimiento')),
                  // InputDatePickerFormField(
                  //   keyboardType: TextInputType.datetime,
                  //   fieldHintText: 'Fecha de Nacimiento',
                  //   fieldLabelText: 'Fecha de Nacimiento',
                  //   firstDate: DateTime(1910),
                  //   lastDate: DateTime(2025),
                  //   initialDate: DateTime.now(),
                  //   autofocus: false,
                  // ),
                  GestureDetector(
                    onTap: () {
                      DateTime date = _selectDate(context);
                      patient.birthDate = date;
                    },
                    child: AbsorbPointer(
                        child: TextFormField(
                      keyboardType: TextInputType.datetime,
                      onChanged: (value) =>
                          patient.birthDate = value as DateTime?,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese un Fecha válida';
                        }
                        return null;
                      },
                      decoration: InputDecorations.authInputDecoration(
                        hintText: 'Fecha de Nacimiento',
                        labelText: 'Fecha de Nacimiento',
                      ),
                    )),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) => patient.email = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value!)) {
                          return 'Ingrese un correo válido';
                        }
                      }
                      return null;
                    },
                    decoration: InputDecorations.authInputDecoration(
                      hintText: 'Ingrese su Correo Electronico',
                      labelText: 'Correo Electronico',
                    ),
                  ),
                  const SizedBox(height: 20),
                  FutureBuilder(
                    future: gender,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return DropdownButtonFormField<String>(
                          isExpanded: true,
                          decoration: InputDecorations.authInputDecoration(
                            hintText: 'Seleccione su Genero',
                            labelText: 'Genero',
                          ),
                          value: null,
                          items: snapshot.data!.map((value) {
                            return DropdownMenuItem<String>(
                                value: value.id,
                                child: Text(
                                  value.description,
                                  overflow: TextOverflow.ellipsis,
                                ));
                          }).toList(),
                          onChanged: (String? value) => patient.gender = value!,
                        );
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      return const CircularProgressIndicator();
                    },
                  ),
                  const SizedBox(height: 20),
                  FutureBuilder(
                    future: codes,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return DropdownButtonFormField<String>(
                          isExpanded: true,
                          decoration: InputDecorations.authInputDecoration(
                            hintText: 'Seleccione su Codigo de Telefono',
                            labelText: 'Codigo de Telefono',
                          ),
                          value: null,
                          items: snapshot.data!.map((value) {
                            return DropdownMenuItem<String>(
                                value: value.codPhone,
                                child: Text(
                                  '${value.codPhone} ${value.description}',
                                  overflow: TextOverflow.ellipsis,
                                ));
                          }).toList(),
                          onChanged: (String? value) =>
                              patient.codPhone = value!,
                        );
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      return const CircularProgressIndicator();
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    onChanged: (value) => patient.phone = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo requerido';
                      }
                      return null;
                    },
                    decoration: InputDecorations.authInputDecoration(
                      hintText: 'Ingrese su Numero de Teléfono',
                      labelText: 'Numero de Teléfono',
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    onChanged: (value) => patient.paymentCode = value,
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
                      onPressed: registerForm.isLoading
                          ? null
                          : () async {
                              FocusScope.of(context).unfocus();

                              if (!registerForm.isValidForm()) return;
                                registerForm.isLoading = true;
                                final loginService = LoginService();
                                //final Future<String> response = registerForm.loginUser();
                                Map response =
                                    await loginService.registerPatient(registerForm);
                                    registerForm.isLoading = false;
                                if (response['success']) {
                                  patientFinal.patient = response['patient'];
                                  context.go('/entry-page');
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(response['message'])),
                                  );
                              }
                              //print(response);
                              registerForm.isLoading = false;
                              //Navigator.pushReplacementNamed(context, 'home');
                            },
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          child: Text(
                            registerForm.isLoading ? 'Espere' : 'Enviar',
                            style: const TextStyle(color: Colors.white),
                          ))))
                ],
              ),
            )));
  }
}

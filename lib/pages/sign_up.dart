import 'package:flutter/material.dart';
import 'package:flutter_videocall/models/entities/type_documents.dart';
import 'package:flutter_videocall/models/services/typedocuments_service.dart';
import 'package:flutter_videocall/ui/input_decorations.dart';
import 'package:flutter_videocall/widgets/widgets.dart';

const List<String> gender = <String>['Femenino', 'Masculino'];
const List<String> codes = <String>['+1 EEUU', '+58 Venezuela', '+57 Colombia'];
final typedocumentdata = TypeDocumentsService();

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Formulario de Registro';
    return Scaffold(
        body: AuthBackground(
            child: SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 100),
          CardContainer(
              child: Column(
            children: [
              const SizedBox(height: 10),
              Text('Formulario de Registro',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 20),
              MyCustomForm()
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
  final _formKey = GlobalKey<FormState>();
  String dropdownValue = '';
  late Future<List<TypeDocuments>> list;
  @override
  void initState() {
    super.initState();
    list = typedocumentdata.getTypePRovider();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
        key: _formKey,
        child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    decoration: InputDecorations.authInputDecoration(
                      labelText: 'Nombre',
                      hintText: 'Ingrese su Nombre',
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
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
                          onChanged: (String? value) {},
                        );
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      return const CircularProgressIndicator();
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    decoration: InputDecorations.authInputDecoration(
                      hintText: 'V-000000000',
                      labelText: 'Documento',
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    decoration: InputDecorations.authInputDecoration(
                      hintText: 'Fecha de Nacimiento',
                      labelText: 'Fecha de Nacimiento',
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    decoration: InputDecorations.authInputDecoration(
                      hintText: 'Ingrese su Correo Electronico',
                      labelText: 'Correo Electronico',
                    ),
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    decoration: InputDecorations.authInputDecoration(
                      hintText: 'Seleccione su Genero',
                      labelText: 'Genero',
                    ),
                    value: null,
                    items: gender.map((value) {
                      return DropdownMenuItem<String>(
                          value: value, child: Text(value));
                    }).toList(),
                    onChanged: (String? value) {},
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    decoration: InputDecorations.authInputDecoration(
                      hintText: 'Seleccione su Codigo de Telefono',
                      labelText: 'Codigo de Telefono',
                    ),
                    value: null,
                    items: codes.map((value) {
                      return DropdownMenuItem<String>(
                          value: value, child: Text(value));
                    }).toList(),
                    onChanged: (String? value) {},
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    decoration: InputDecorations.authInputDecoration(
                      hintText: 'Ingrese su Numero de Teléfono',
                      labelText: 'Numero de Teléfono',
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            child: Text(
                              'Enviar',
                              style: TextStyle(color: Colors.white),
                            )),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Processing Data')),
                            );
                          }
                        },
                      ))
                ],
              ),
            )));
  }
}

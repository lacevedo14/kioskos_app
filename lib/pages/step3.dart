import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'translations.dart';

class Step3Screen extends StatefulWidget {
  const Step3Screen({Key? key}) : super(key: key);

  @override
  _Step3ScreenState createState() => _Step3ScreenState();
}

class _Step3ScreenState extends State<Step3Screen> {
  List<bool> _isChecked = [false, false];
  String _selectedLanguage = 'ESP';

  @override
  void initState() {
    super.initState();
    _loadLanguagePreference();
  }

  Future<void> _loadLanguagePreference() async {
    setState(() {
      _selectedLanguage = 'ESP';
    });
  }

  void _toggleCheckbox(int index, bool? value) {
    setState(() {
      _isChecked[index] = value!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65.0),
        child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.indigo,
            elevation: 0,
            title: Text('')),
      ),
      body: Center(
        // Centramos el contenido en la pantalla
        child: ConstrainedBox(
          constraints: const BoxConstraints(
              maxWidth: 600), // Limitar el ancho máximo en tablets
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CheckboxListTile(
                      title: Text(
                          translations[_selectedLanguage]!['quiet_place']!),
                      value: _isChecked[0],
                      controlAffinity: ListTileControlAffinity.trailing,
                      checkColor: Colors.white,
                      activeColor: Color(0xFF3A598F),
                      onChanged: (value) => _toggleCheckbox(0, value),
                    ),
                    CheckboxListTile(
                      title: Text(
                          translations[_selectedLanguage]!['avoid_movement']!),
                      value: _isChecked[1],
                      controlAffinity: ListTileControlAffinity.trailing,
                      checkColor: Colors.white,
                      activeColor: Color(0xFF3A598F),
                      onChanged: (value) => _toggleCheckbox(1, value),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 35.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () => context.go('/step1'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFF3A2C),
                        padding:
                            EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(
                        translations[_selectedLanguage]!['cancel']!,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _isChecked.contains(false)
                          ? null
                          : () {
                              context.go('/facial-scan');
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        padding:
                            EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(
                        translations[_selectedLanguage]!['start_exam']!,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

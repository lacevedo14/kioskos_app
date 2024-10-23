import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'translations.dart';

class Step2Screen extends StatefulWidget {
  const Step2Screen({Key? key}) : super(key: key);

  @override
  _Step2ScreenState createState() => _Step2ScreenState();
}

class _Step2ScreenState extends State<Step2Screen> {
  List<bool> _isChecked = [false, false, false, false];
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
        preferredSize: const Size.fromHeight(65.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Center(
            child: Image.asset(
              'assets/images/logo_planimedic.png',
              height: 50,
            ),
          ),
        ),
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
                      title: Text(translations[_selectedLanguage]!['consent']!),
                      value: _isChecked[0],
                      controlAffinity: ListTileControlAffinity.trailing,
                      checkColor: Colors.white,
                      activeColor: const Color(0xFF3A598F),
                      onChanged: (value) => _toggleCheckbox(0, value),
                    ),
                    CheckboxListTile(
                      title: Text(
                          translations[_selectedLanguage]!['quiet_place']!),
                      value: _isChecked[1],
                      controlAffinity: ListTileControlAffinity.trailing,
                      checkColor: Colors.white,
                      activeColor: Color(0xFF3A598F),
                      onChanged: (value) => _toggleCheckbox(1, value),
                    ),
                    CheckboxListTile(
                      title: Text(
                          translations[_selectedLanguage]!['avoid_movement']!),
                      value: _isChecked[2],
                      controlAffinity: ListTileControlAffinity.trailing,
                      checkColor: Colors.white,
                      activeColor: Color(0xFF3A598F),
                      onChanged: (value) => _toggleCheckbox(2, value),
                    ),
                    CheckboxListTile(
                      title: Text(
                          translations[_selectedLanguage]!['results_page']!),
                      value: _isChecked[3],
                      controlAffinity: ListTileControlAffinity.trailing,
                      checkColor: Colors.white,
                      activeColor: const Color(0xFF3A598F),
                      onChanged: (value) => _toggleCheckbox(3, value),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        context.go('/step1');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF3A2C),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(
                        translations[_selectedLanguage]!['cancel']!,
                        style: const TextStyle(
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
                        backgroundColor: Color(0xFF2087C9),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(
                        translations[_selectedLanguage]!['next']!,
                        style: const TextStyle(
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

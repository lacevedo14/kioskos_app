import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_videocall/models/services/api_service.dart';
import 'package:go_router/go_router.dart';
import 'translations.dart';

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({super.key});

  @override
  SurveyScreenState createState() {
    return SurveyScreenState();
  }
}

class SurveyScreenState extends State<SurveyScreen> {
  String _selectedLanguage = 'ESP';
  String coment = '';
  bool light = true;
  bool recomenntDoctor = false;
  double connectionSurvey = 0;
  double consultSurvey = 0;
  double assitantSurvey = 0;
  bool enabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 246, 247, 248),
        elevation: 0,
        title: Center(
          child: Image.asset(
            'assets/logo_egd.png',
            height: 50,
          ),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Text(translations[_selectedLanguage]!['survey']!,
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 20),
              Text(translations[_selectedLanguage]!['connection_survey']!),
              const SizedBox(height: 20),
              RatingBar.builder(
                initialRating: 3,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 50.0,
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    connectionSurvey = rating;
                  });
                  print(rating);
                },
              ),
              const SizedBox(height: 20),
              Text(translations[_selectedLanguage]!['consult_survey']!),
              const SizedBox(height: 20),
              RatingBar.builder(
                initialRating: 3,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 50.0,
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    consultSurvey = rating;
                  });
                },
              ),
              const SizedBox(height: 20),
              Text(translations[_selectedLanguage]!['assitant_survey']!),
              const SizedBox(height: 20),
              RatingBar.builder(
                initialRating: 3,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 50.0,
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    assitantSurvey = rating;
                  });
                  print(rating);
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Text(
                        translations[_selectedLanguage]!['doctor_survey']!),
                  ),
                  CheckboxListTile(
                    title: Text('Si'),
                    value: recomenntDoctor,
                    controlAffinity: ListTileControlAffinity.trailing,
                    checkColor: Colors.white,
                    activeColor: const Color(0xFF3A598F),
                    onChanged: (value) {
                      setState(() {
                        recomenntDoctor = value!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(translations[_selectedLanguage]!['coment']!),
               TextField(
                onChanged: (value) {
                  setState(() {
                    coment = value;
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Ingrese su cometario',
                ),
              ),
              ElevatedButton(
                onPressed: enabled
                    ? () async {
                        setState(() {
                          enabled = true;
                        });
                           final ApiService _apiService = ApiService();
                            final data = await _apiService.sendDataSurvey({
                              "connection_quality": connectionSurvey,
                              "consultation_quality": consultSurvey,
                              "assistance_quality": assitantSurvey,
                              "comment": coment,
                              "recommended_doctor": recomenntDoctor
                            });
                        context.go('/step2');
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
                  translations[_selectedLanguage]!['start'] ?? 'Start',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          )),
    );
  }
}

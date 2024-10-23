import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_videocall/models/services/api_service.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  String recommendationAttention = 'Y';
  String medicalInformation = 'Y';
  String qualityConsultation = 'Y';
  String comfortable = 'Y';
  double satisfaction = 0;
  double consultSurvey = 0;
  double assitantSurvey = 0;
  bool enabled = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 246, 247, 248),
        elevation: 0,
        title: Center(
          child: Image.asset(
            'assets/images/logo_planimedic.png',
            height: 50,
          ),
        ),
      ),
      body: Center(
          child: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Text(translations[_selectedLanguage]!['survey']!,
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 20),
                Text(
                  translations[_selectedLanguage]!['satisfaction']!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Text(translations[_selectedLanguage]![
                    'satisfaction_attention']!),
                const SizedBox(height: 20),
                RatingBar.builder(
                  initialRating: 3,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 50.0,
                  itemBuilder: (context, index) {
                    switch (index) {
                      case 0:
                        return const Icon(
                          Icons.sentiment_very_dissatisfied,
                          color: Colors.red,
                        );
                      case 1:
                        return const Icon(
                          Icons.sentiment_dissatisfied,
                          color: Color.fromARGB(255, 253, 111, 111),
                        );
                      case 2:
                        return const Icon(
                          Icons.sentiment_neutral,
                          color: Colors.amber,
                        );
                      case 3:
                        return const Icon(
                          Icons.sentiment_satisfied,
                          color: Colors.lightGreen,
                        );
                      case 4:
                        return const Icon(
                          Icons.sentiment_very_satisfied,
                          color: Colors.green,
                        );
                      default:
                        return const Icon(
                          Icons.sentiment_very_satisfied,
                          color: Colors.green,
                        );
                    }
                  },
                  onRatingUpdate: (rating) {
                    setState(() {
                      satisfaction = rating;
                    });
                    print(rating);
                  },
                ),
                const SizedBox(height: 20),
                Text(translations[_selectedLanguage]![
                    'recommendation_attention']!),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 150,
                      child: RadioListTile(
                        title: const Text('Si'),
                        value: 'Y',
                        groupValue: recommendationAttention,
                        onChanged: (String? value) {
                          setState(() {
                            recommendationAttention = value!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10), //
                    SizedBox(
                      width: 150,
                      child: RadioListTile(
                        title: const Text('No'),
                        value: 'N',
                        groupValue: recommendationAttention,
                        onChanged: (String? value) {
                          setState(() {
                            recommendationAttention = value!;
                          });
                          print(value);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(translations[_selectedLanguage]!['medical_information']!),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 150,
                      child: RadioListTile(
                        title: const Text('Si'),
                        value: 'Y',
                        groupValue: medicalInformation,
                        onChanged: (String? value) {
                          setState(() {
                            medicalInformation = value!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: 150,
                      child: RadioListTile(
                        title: const Text('No'),
                        value: 'N',
                        groupValue: medicalInformation,
                        onChanged: (String? value) {
                          setState(() {
                            medicalInformation = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(translations[_selectedLanguage]!['quality_consultation']!),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 150,
                      child: RadioListTile(
                        title: const Text('Si'),
                        value: 'Y',
                        groupValue: qualityConsultation,
                        onChanged: (String? value) {
                          setState(() {
                            qualityConsultation = value!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: 150,
                      child: RadioListTile(
                        title: const Text('No'),
                        value: 'N',
                        groupValue: qualityConsultation,
                        onChanged: (String? value) {
                          setState(() {
                            qualityConsultation = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(translations[_selectedLanguage]!['comfortable']!),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 150,
                      child: RadioListTile(
                        title: const Text('Si'),
                        value: 'Y',
                        groupValue: comfortable,
                        onChanged: (String? value) {
                          setState(() {
                            comfortable = value!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: 150,
                      child: RadioListTile(
                        title: const Text('No'),
                        value: 'N',
                        groupValue: comfortable,
                        onChanged: (String? value) {
                          setState(() {
                            comfortable = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: enabled
                      ? null
                      : () async {
                          setState(() {
                            enabled = true;
                          });
                          final ApiService _apiService = ApiService();
                          final data = await _apiService.sendDataSurvey({
                            "recommendationAttention": recommendationAttention,
                            "medicalInformation": medicalInformation,
                            "qualityConsultation": qualityConsultation,
                            "comfortable": comfortable,
                            "satisfaction": satisfaction
                          });
                         
                          context.go('/final');
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2087C9),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    translations[_selectedLanguage]!['finish'] ?? 'Finalizar',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )),
      )),
    );
  }
}

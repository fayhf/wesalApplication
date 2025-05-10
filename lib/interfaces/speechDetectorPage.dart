import 'package:flutter/material.dart';
import 'package:wesal_app_final/design/background.dart';
import 'package:wesal_app_final/design/BarWidget.dart';
import 'package:wesal_app_final/widgets/speechRecognition/SpeechRecognition.dart';

class speechDetectorPage extends StatelessWidget {
  const speechDetectorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: GradientAndContent(
          widget1: barWidget(), // Top navigation bar
          widget2:
              SpeechRecognitionPage(), // Main content for speech recognition
        ),
      ),
    );
  }
}
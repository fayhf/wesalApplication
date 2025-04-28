import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:wesal_app_final/widgets/speechRecognition/SpeechWidget.dart';

// Stateful widget for the speech recognition page
class SpeechRecognitionPage extends StatefulWidget {
  @override
  SpeechRecognitionPageState createState() => SpeechRecognitionPageState(); // Create state for this widget
}

// State class for managing speech recognition state
class SpeechRecognitionPageState extends State<SpeechRecognitionPage> {
  late stt.SpeechToText speech; // Instance of speech-to-text
  bool isListening = false; // Listening state
  String _text = ''; // Recognized text
  bool understood = false; // State for understood input
  bool notUnderstood = false; // State for not understood input

  final TextEditingController _textController =
      TextEditingController(); // Controller for text input

  @override
  void initState() {
    super.initState();
    speech = stt.SpeechToText(); // Initialize speech-to-text
  }

  // Method to start listening for speech
  void startListening() async {
    await speech.initialize(); // Initialize speech recognition
    speech.listen(
      onResult: (result) {
        setState(() {
          _text = result.recognizedWords; // Update recognized text
          _textController.text = _text; // Edit feature
        });
      },
      localeId: 'ar', // Set locale to Arabic
    );

    setState(() {
      isListening = true; // Update listening state
    });
  }

  // Method to stop listening for speech
  void stopListening() {
    speech.stop(); // Stop the speech recognition
    setState(() {
      isListening = false; // Update listening state
    });
  }

  // Method to handle understood input
  void handleUnderstood() {
    setState(() {
      understood = true; // Update understood state
      notUnderstood = false; // Reset not understood state
      print('!حسنا فهمت pressed'); // Log understood action
    });
  }

  // Method to handle not understood input
  void handleNotUnderstood() {
    setState(() {
      notUnderstood = true; // Update not understood state
      understood = false; // Reset understood state
      print('!لم افهم pressed'); // Log not understood action
    });
  }

  @override
  void dispose() {
    _textController.dispose(); // Dispose of the text controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return speechWidget(
      isListening: isListening, // Pass listening state
      text: _text, // Pass recognized text
      textController: _textController, // Pass text controller
      onStartListening: startListening, // Start listening callback
      onStopListening: stopListening, // Stop listening callback
      onUnderstood: handleUnderstood, // Understood callback
      onNotUnderstood: handleNotUnderstood, // Not understood callback
      understood: understood, // Pass understood state
      notUnderstood: notUnderstood, // Pass not understood state
    );
  }
}

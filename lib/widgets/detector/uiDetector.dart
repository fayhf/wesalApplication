import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:wesal_app_final/interfaces/homePage.dart';

class ButtonColumn extends StatefulWidget {
  const ButtonColumn({super.key});

  @override
  _ButtonColumnState createState() => _ButtonColumnState();
}

class _ButtonColumnState extends State<ButtonColumn> {
  final TextEditingController _controller = TextEditingController();
  final FlutterTts flutterTts = FlutterTts(); // Text-to-Speech instance
  Timer? _timer;
  String lastFetchedPrediction = "";

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (_) => fetchPrediction());
  }

  Future<void> fetchPrediction() async {
    try {
      final response =
          await http.get(Uri.parse('http://127.0.0.1:5000/get_prediction'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final prediction = data['prediction'];

        if (prediction.isNotEmpty && prediction != lastFetchedPrediction) {
          setState(() {
            if (_controller.text.isEmpty) {
              _controller.text = prediction;
            } else {
              _controller.text += " $prediction";
            }
          });
          lastFetchedPrediction = prediction;
        }
      }
    } catch (e) {
      print("Error fetching prediction: $e");
    }
  }

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage("ar-SA"); // Arabic (Saudi)
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    flutterTts.stop(); // Stop any ongoing TTS
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'ترجمة لغة الإشارة',
          textDirection: TextDirection.rtl,
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'النص المترجم (يمكنك تعديل النص المترجم)',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _controller,
                  textAlign: TextAlign.right,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final url = Uri.parse('http://127.0.0.1:5000/receive');
                      await http.post(
                        url,
                        headers: {'Content-Type': 'application/json'},
                        body: jsonEncode({'message': 'start_model'}),
                      );
                    },
                    child: const Text('ابدأ'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final url = Uri.parse('http://127.0.0.1:5000/stop');
                      await http.post(
                        url,
                        headers: {'Content-Type': 'application/json'},
                        body: jsonEncode({'message': 'stop_model'}),
                      );
                    },
                    child: const Text('توقف'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          IconButton(
            icon: const Icon(Icons.volume_up),
            iconSize: 32,
            color: Colors.blue,
            onPressed: () {
              _speak(_controller.text); // Speak the text
            },
          ),
          const Spacer(),
          BottomAppBar(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
                icon: const Icon(Icons.home),
                iconSize: 32,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

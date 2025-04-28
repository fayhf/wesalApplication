import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wesal_app_final/interfaces/homePage.dart';

class ButtonColumn extends StatelessWidget {
  const ButtonColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Button Column Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
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
            const SizedBox(height: 16), // Space between buttons
            ElevatedButton(
              onPressed: () async {
                final url = Uri.parse('http://127.0.0.1:5000/stop');
                await http.post(
                  url,
                  headers: {'Content-Type': 'applicaqtion/json'},
                  body: jsonEncode({'message': 'stop_model'}),
                );
              },
              child: const Text('توقف'),
            ),
            const SizedBox(height: 16),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
                // Action for home button
              },
              icon: const Icon(Icons.home),
              iconSize: 32,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:wesal_app_final/widgets/dailyExpressionWidgets/dailyExpressionObject.dart';

class GridItem extends StatelessWidget {
  final int index;
  final DailyExpression expression;
  final VoidCallback onTap;
  final bool isSelected;

  const GridItem({
    required this.index,
    required this.expression,
    required this.onTap,
    this.isSelected = false,
  });

  void _speakDescription() async {
    FlutterTts tts = FlutterTts();
    await tts.setLanguage(expression.sound); // 'ar' or 'en'
    await tts.setPitch(1.0);
    await tts.speak(expression.description);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        color: isSelected
            ? Color.fromARGB(82, 226, 224, 249)
            : const Color.fromARGB(255, 249, 246, 255),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              expression.name,
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 20),
            Icon(
            Icons.sign_language_rounded,     // Built-in Flutter icon
            color: const Color.fromARGB(255, 92, 92, 92),  // Icon color
            size: 30.0,        // Icon size
            ),
            
            const SizedBox(height: 5),
            IconButton(
              icon: const Icon(Icons.volume_up),
              onPressed: _speakDescription,
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}

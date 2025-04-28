import 'package:flutter/material.dart';
import 'package:wesal_app_final/interfaces/dailyExpressionPage.dart';
import 'package:wesal_app_final/interfaces/signDetectorPage.dart';
import 'package:wesal_app_final/interfaces/speechDetectorPage.dart';

// Stateless widget for the homepage body
class homepageBodyWidget extends StatelessWidget {
  const homepageBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 15), // Space above the title
        const Text(
          "ما الذي تريد استخدامه اليوم؟", // Title text
          style: TextStyle(
            color: Color.fromARGB(255, 33, 3, 69), // Title color
            fontSize: 24,
            fontWeight: FontWeight.bold, // Bold title
          ),
        ),
        const SizedBox(height: 20), // Space below the title
        customOutlinedButton("ترجمة لغة الاشارة", 'assets/handtosound.png', () {
          // Button for sign language translation
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const signDetectorPage()),
          );
        }),
        const SizedBox(height: 20), // Space between buttons
        customOutlinedButton("التعابير اليومية", 'assets/DE.png', () {
          // Button for daily expressions
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const dailyExpressionPage(),
            ),
          );
        }),
        const SizedBox(height: 20), // Space between buttons
        customOutlinedButton("ترجمة صوتية", 'assets/soundtohand.png', () {
          // Button for audio translation
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const speechDetectorPage()),
          );
        }),
        const SizedBox(height: 20), // Space below the last button
      ],
    );
  }
}

// Custom button widget for outlined buttons
Widget customOutlinedButton(
  String text,
  String imagePath,
  VoidCallback onPressed,
) {
  return OutlinedButton(
    style: OutlinedButton.styleFrom(
      padding: const EdgeInsets.only(
        bottom: 35,
        top: 35,
        right: 5,
        left: 5,
      ), // Padding for button
      backgroundColor: const Color.fromARGB(
        255,
        255,
        255,
        255,
      ), // Button background color
      side: const BorderSide(
        color: Color.fromARGB(71, 81, 81, 81),
      ), // Border color
      shadowColor: Colors.black.withOpacity(0.5), // Shadow color
      elevation: 5, // Elevation for shadow effect
    ),
    onPressed: onPressed, // Button action
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      textDirection: TextDirection.rtl, // Right-to-left text direction
      children: [
        Image(
          image: AssetImage(imagePath),
          width: 50,
          height: 50,
        ), // Button icon
        const SizedBox(height: 20), // Space between icon and text
        Text(
          text, // Button text
          style: const TextStyle(
            fontSize: 23, // Text size
            color: Color.fromARGB(255, 66, 19, 96), // Text color
          ),
        ),
      ],
    ),
  );
}

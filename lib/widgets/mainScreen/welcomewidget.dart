import 'package:flutter/material.dart';
import 'package:wesal_app_final/interfaces/homePage.dart';
import 'package:wesal_app_final/interfaces/loginPage.dart';
import 'package:wesal_app_final/interfaces/signUpPage.dart';

// Stateless widget for the welcome content
class Welcomewidget extends StatelessWidget {
  const Welcomewidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      // Center the content vertically and horizontally
      child: Column(
        children: [
          const SizedBox(height: 200), // Space above the logo
          Image.asset('assets/logo.png', width: 200, height: 100), // Logo image
          // Welcome Text
          const Text(
            '!مرحبا بك في تطبيق وصال لترجمة لغة الاشارة العربية',
            style: TextStyle(
              color: Colors.white, // White text color
              fontSize: 15,
              fontWeight: FontWeight.bold, // Bold text
            ),
            textAlign: TextAlign.center, // Center the text
          ),
          const SizedBox(height: 20), // Space below the welcome text
          SizedBox(
            width: 200, // Width of the button
            child: ElevatedButton(
              onPressed: () {
                // Navigate to the signup page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const signup()),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color.fromARGB(
                  255,
                  245,
                  244,
                  244,
                ), // Text color
                backgroundColor: const Color.fromARGB(
                  121,
                  204,
                  201,
                  240,
                ), // Background color
              ),
              child: const Text('انشاء حساب'), // Button text
            ),
          ),
          const SizedBox(height: 10), // Space between buttons
          SizedBox(
            width: 200, // Width of the button
            child: ElevatedButton(
              onPressed: () {
                // Navigate to the login page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const login()),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 245, 244, 244),
                backgroundColor: const Color.fromARGB(121, 204, 201, 240),
              ),
              child: const Text('تسجيل الدخول'), // Button text
            ),
          ),
          const SizedBox(height: 10), // Space between buttons
          SizedBox(
            width: 200, // Width of the button
            child: ElevatedButton(
              onPressed: () {
                // Navigate to the home page as a guest
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 245, 244, 244),
                backgroundColor: const Color.fromARGB(121, 204, 201, 240),
              ),
              child: const Text('الإستمرار كزائر'), // Button text
            ),
          ),
        ],
      ),
    );
  }
}

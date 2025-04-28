import 'package:flutter/material.dart';
import 'package:wesal_app_final/interfaces/homePage.dart';
import 'package:wesal_app_final/interfaces/signUpPage.dart';
import 'package:wesal_app_final/design/inputfield.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Instance of FirebaseAuth for managing user authentication
final _firebase = FirebaseAuth.instance;

// Stateful widget for the login form
class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key}); // Constructor with optional key

  @override
  State<LoginWidget> createState() => _LoginWidgetState(); // Create state for this widget
}

// State class for managing the login form state
class _LoginWidgetState extends State<LoginWidget> {
  final _formKey =
      GlobalKey<FormState>(); // Key for the form to manage its state
  final TextEditingController _emailController =
      TextEditingController(); // Controller for email input
  final TextEditingController _passwordController =
      TextEditingController(); // Controller for password input

  // Variables to hold entered email and password
  String _enteredEmail = '';
  String _enteredPassword = '';

  // Method to handle form submission
  void _submit() async {
    final isValid =
        _formKey.currentState!.validate(); // Validate the form input

    if (!isValid) {
      return; // Exit if the form is invalid
    }

    _formKey.currentState!.save(); // Save the form state

    // Retrieve trimmed values from the controllers
    _enteredEmail = _emailController.text.trim(); // Get email
    _enteredPassword = _passwordController.text.trim(); // Get password

    try {
  // Sign in the user with email and password
  final userCredentials = await _firebase.signInWithEmailAndPassword(
    email: _enteredEmail,
    password: _enteredPassword,
  );
  print(userCredentials); // Log user credentials

  // Navigate to the home page on successful login
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const HomePage()),
  );
// ignore: unused_catch_clause
} on FirebaseAuthException catch (error) {
  String errorMessage = 'تأكد من ادخال بياناتك بشكل صحيح!';

  // Show the error message in a red SnackBar
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        errorMessage,
        style: const TextStyle(color: Colors.white), // White text
      ),
      backgroundColor: Colors.red, // Red background
      behavior: SnackBarBehavior.floating, // (optional) makes it float
      margin: const EdgeInsets.all(16), // (optional) adds margin around it
    ),
  );
}
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          TextDirection.rtl, // Right-to-left text direction for Arabic language
      child: Form(
        key: _formKey, // Assign form key
        child: Column(
          children: [
            const SizedBox(height: 150), // Space above the logo
            Image.asset(
              'assets/logo.png',
              width: 200,
              height: 100,
            ), // Logo image
            const Text(
              '!مرحبا بك', // Welcome message
              style: TextStyle(
                color: Color.fromARGB(255, 0, 72, 195), // Text color
                fontSize: 15,
                fontWeight: FontWeight.bold, // Bold text
              ),
            ),
            const SizedBox(height: 5), // Space below the welcome message
            const Text(
              'سجل الدخول الى حسابك', // Login prompt
              style: TextStyle(
                color: Color.fromARGB(250, 252, 250, 250),
                fontSize: 15,
                fontWeight: FontWeight.bold, // Bold text
              ),
            ),
            const SizedBox(height: 20), // Space between prompt and input fields
            inputField(
              placeholder: 'البريد الإلكتروني', // Placeholder for email input
              controller: _emailController, // Assign controller
              validator: (value) {
                // Validate email input
                if (value == null ||
                    value.trim().isEmpty ||
                    !value.contains('@')) {
                  return 'قم بإدخال بريد إلكتروني صحيح.'; // Error message
                }
                return null; // Return null if valid
              },
            ),
            const SizedBox(
              height: 10,
            ), // Space between email and password fields
            inputField(
              placeholder: 'كلمة السر', // Placeholder for password input
              controller: _passwordController, // Assign controller
              obscureText: true, // Mask password input
              validator: (value) {
                // Validate password input
                if (value == null || value.trim().length < 6) {
                  return 'يجب أن تكون كلمة السر 6 أحرف على الأقل.'; // Error message
                }
                return null; // Return null if valid
              },
            ),
            const SizedBox(height: 30), // Space below password field
            ElevatedButton(
              onPressed: _submit, // Handle button press
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
              child: const Text('دخول'), // Button text
            ),
            const SizedBox(height: 5), // Space below the button
            TextButton(
              onPressed: () {
                // Navigate to the sign-up page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const signup()),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
              ), // Button text color
              child: const Text(
                ' ليس لديك حساب؟انضم الينا الان!',
              ), // Sign-up prompt
            ),
            TextButton(
              onPressed: () {
                // Navigate to the home page as a guest
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
              ), // Button text color
              child: const Text('الإستمرار كزائر'), // Continue as guest prompt
            ),
          ],
        ),
      ),
    );
  }
}

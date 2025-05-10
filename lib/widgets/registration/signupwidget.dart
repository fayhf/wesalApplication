import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wesal_app_final/interfaces/homePage.dart';
import 'package:wesal_app_final/interfaces/loginPage.dart';
import 'package:wesal_app_final/design/inputfield.dart';

// Instance of FirebaseAuth for authentication
final _firebase = FirebaseAuth.instance;

// Stateful widget for the signup form
class signupwidget extends StatefulWidget {
  const signupwidget({super.key});

  @override
  State<signupwidget> createState() => _SignupWidgetState();
}

// State class for managing signup state
class _SignupWidgetState extends State<signupwidget> {
  final _formKey = GlobalKey<FormState>(); // Key for the form
  final TextEditingController _firstNameController =
      TextEditingController(); // Controller for first name
  final TextEditingController _lastNameController =
      TextEditingController(); // Controller for last name
  final TextEditingController _usernameController =
      TextEditingController(); // Controller for username
  final TextEditingController _emailController =
      TextEditingController(); // Controller for email
  final TextEditingController _passwordController =
      TextEditingController(); // Controller for password

  // Variables to hold user input
  String _enteredEmail = '';
  String _enteredPassword = '';
  String _enteredFirstName = '';
  String _enteredLastName = '';
  String _enteredUsername = '';

  // Method to handle form submission
  void _submit() async {
    final isValid = _formKey.currentState!.validate(); // Validate the form

    if (!isValid) {
      print("غير صالح"); // Print if the form is invalid
      return; // Exit if validation fails
    }

    _formKey.currentState!.save(); // Save the form state

    // Retrieve trimmed values from the controllers
    _enteredEmail = _emailController.text.trim();
    _enteredPassword = _passwordController.text.trim();
    _enteredFirstName = _firstNameController.text.trim();
    _enteredLastName = _lastNameController.text.trim();
    _enteredUsername = _usernameController.text.trim();

    try {
      // Create a new user with email and password
      final userCredentials = await _firebase.createUserWithEmailAndPassword(
        email: _enteredEmail,
        password: _enteredPassword,
      );

      // Check if the user was created successfully
      if (userCredentials.user != null) {
        String userId = userCredentials.user!.uid; // Get user ID

        // Create a new user document in Firestore
        await FirebaseFirestore.instance.collection('users').doc(userId).set({
          'firstName': _enteredFirstName,
          'lastName': _enteredLastName,
          'username': _enteredUsername,
          'email': _enteredEmail,
          'password': _enteredPassword,
        });

        print("User created and data added to Firestore"); // Log success

        // Navigate to the home page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        print("User creation failed, no user returned."); // Log failure
      }
    } on FirebaseAuthException catch (error) {
      String errorMessage = 'Signup failed.';

      if (error.code == 'email-already-in-use') {
        errorMessage = 'This email is already registered.';
      } else if (error.code == 'invalid-email') {
        errorMessage = 'Invalid email address.';
      } else if (error.code == 'operation-not-allowed') {
        errorMessage = 'Email/password accounts are not enabled.';
      } else if (error.code == 'weak-password') {
        errorMessage = 'The password is too weak. Please use a stronger one.';
      } else {
        errorMessage = error.message ?? 'An unexpected error occurred.';
      }

      // Show the error message in a red SnackBar
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage,
            style: const TextStyle(color: Colors.white), // White text
          ),
          backgroundColor: Colors.red, // Red background
          behavior: SnackBarBehavior.floating, // (optional) float style
          margin: const EdgeInsets.all(16), // (optional) margin
        ),
      );
    } catch (e) {
      print("An unknown error occurred: $e"); // Log unknown errors
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'An unknown error occurred. Please try again.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Directionality(
          textDirection: TextDirection.rtl, // Right-to-left text direction
          child: Form(
            key: _formKey, // Assign form key
            child: Column(
              children: [
                const SizedBox(height: 100), // Space above the logo
                Image.asset(
                  'assets/logo.png',
                  width: 200,
                  height: 100,
                ), // Logo image
                const Text(
                  '!مرحبا بك',
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 72, 195),
                    fontSize: 15,
                    fontWeight: FontWeight.bold, // Bold text
                  ),
                ),
                const Text(
                  'ابدأ رحلتك معنا وسجل الآن!🚀 ', // Welcome text
                  style: TextStyle(
                    color: Color.fromARGB(250, 245, 243, 243),
                    fontSize: 15,
                    fontWeight: FontWeight.bold, // Bold text
                  ),
                ),
                const SizedBox(height: 15), // Space below the welcome text
                // Row for first name and last name input fields
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: inputField(
                        placeholder:
                            'الاسم الأول', // Placeholder for first name
                        controller: _firstNameController,
                        validator: (value) {
                          // Validate first name
                          if (value == null || value.trim().isEmpty) {
                            return 'يرجى إدخال الاسم الأول.'; // Error message
                          }
                          return null; // Return null if valid
                        },
                      ),
                    ),
                    Expanded(
                      child: inputField(
                        placeholder: 'اسم العائلة', // Placeholder for last name
                        controller: _lastNameController,
                        validator: (value) {
                          // Validate last name
                          if (value == null || value.trim().isEmpty) {
                            return 'يرجى إدخال اسم العائلة.'; // Error message
                          }
                          return null; // Return null if valid
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5), // Space between input fields
                // Username Field
                inputField(
                  placeholder: 'اسم المستخدم', // Placeholder for username
                  controller: _usernameController,
                  validator: (value) {
                    // Validate username
                    if (value == null || value.trim().isEmpty) {
                      return 'يرجى إدخال اسم المستخدم.'; // Error message
                    }
                    return null; // Return null if valid
                  },
                ),
                const SizedBox(height: 5), // Space between fields
                // Email Field
                inputField(
                  placeholder: 'البريد الإلكتروني', // Placeholder for email
                  controller: _emailController,
                  validator: (value) {
                    // Validate email
                    if (value == null ||
                        value.trim().isEmpty ||
                        !value.contains('@')) {
                      return 'قم بإدخال بريد إلكتروني صحيح.'; // Error message
                    }
                    return null; // Return null if valid
                  },
                ),
                const SizedBox(height: 5), // Space between fields
                // Password Field
                inputField(
                  placeholder: 'كلمة السر', // Placeholder for password
                  controller: _passwordController,
                  obscureText: true, // Mask password input
                  validator: (value) {
                    // Validate password
                    if (value == null || value.trim().length < 6) {
                      return 'يجب أن تكون كلمة السر 6 أحرف على الأقل.'; // Error message
                    }
                    return null; // Return null if valid
                  },
                ),
                const SizedBox(height: 10), // Space below password field
                // Submit Button
                ElevatedButton(
                  onPressed: _submit, // Submit the form
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 245, 244, 244),
                    backgroundColor: const Color.fromARGB(121, 204, 201, 240),
                  ),
                  child: const Text('انشاء'), // Button text
                ),
                const SizedBox(height: 5), // Space below button
                // Navigation to Login
                TextButton(
                  onPressed: () {
                    // Navigate to the login page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const login()),
                    );
                  },
                  style: TextButton.styleFrom(foregroundColor: Colors.white),
                  child: const Text('لديك حساب؟ تسجيل دخول'), // Button text
                ),
                const SizedBox(height: 1), // Space below button
                TextButton(
                  onPressed: () {
                    // Navigate to the home page as a guest
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  },
                  style: TextButton.styleFrom(foregroundColor: Colors.white),
                  child: const Text('الإستمرار كزائر'), // Button text
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wesal_app_final/interfaces/loginPage.dart';
import 'package:wesal_app_final/interfaces/signUpPage.dart';
import 'package:wesal_app_final/interfaces/userAccountPage.dart';
import 'package:wesal_app_final/dialog/infoDialog.dart';

// Stateful widget for the homepage bar
class homepageBarWidget extends StatefulWidget {
  const homepageBarWidget({super.key});

  @override
  State<homepageBarWidget> createState() => _homepageBarWidgetState(); // Create state for this widget
}

// State class for managing the homepage bar
class _homepageBarWidgetState extends State<homepageBarWidget> {
  String? username; // Variable to hold the username

  @override
  void initState() {
    super.initState();
    _loadUsername(); // Load username when the widget initializes
  }

  // Method to load the username from Firestore
  Future<void> _loadUsername() async {
    final user = FirebaseAuth.instance.currentUser; // Get current user
    if (user != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid) // Get user document by UID
              .get();

      if (doc.exists) {
        setState(() {
          username =
              doc.data()?['username'] ?? ''; // Set username from Firestore
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        textDirection: TextDirection.rtl, // Right-to-left text direction
        children: [
          TextButton(
            child: Row(
              children: [
                Text(
                  username != null && username!.isNotEmpty
                      ? '!مرحبا $username ' // Greeting with username
                      : '!مرحبا بك', // Default greeting
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                  ), // Text styling
                ),
                const SizedBox(width: 10), // Space between text and icon
                const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 50,
                ), // User icon
              ],
            ),
            onPressed: () {
              if (FirebaseAuth.instance.currentUser != null) {
                // Navigate to user account page if logged in
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const userAccount()),
                );
              } else {
                // Show dialog if user is a guest
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.close), // Close button
                            onPressed: () {
                              Navigator.pop(context); // Close dialog
                            },
                          ),
                          const Spacer(),
                          const Text(
                            ' !يبدو انك هنا كزائر فقط', // Guest message
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      content: const Text(
                        'سجل الآن واستمتع بتجربتك الفريدة✨ في صنع تعابير يومية مخصصة لك ', // Sign-up prompt
                        textAlign: TextAlign.right,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Close dialog
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        const login(), // Navigate to login
                              ),
                            );
                          },
                          child: const Text('تسجيل الدخول'), // Login button
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Close dialog
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        const signup(), // Navigate to signup
                              ),
                            );
                          },
                          child: const Text('إنشاء حساب'), // Sign-up button
                        ),
                      ],
                    );
                  },
                );
              }
            },
          ),
          const Spacer(), // Space between elements
          IconButton(
            icon: const Icon(
              Icons.info_outlined,
              color: Colors.white,
              size: 25, // Info icon
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const infoDialog(); // Show info dialog
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

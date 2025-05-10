import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wesal_app_final/interfaces/welcomePage.dart';
import 'package:wesal_app_final/design/inputfield.dart';

// Stateful widget for the account details form
class Accountdetails extends StatefulWidget {
  const Accountdetails({super.key});

  @override
  State<Accountdetails> createState() =>
      _AccountdetailsState(); // Create state for this widget
}

// State class for managing account details
class _AccountdetailsState extends State<Accountdetails> {
  final _formKey = GlobalKey<FormState>(); // Key for the form
  final TextEditingController _firstNameController =
      TextEditingController(); // Controller for first name
  final TextEditingController _lastNameController =
      TextEditingController(); // Controller for last name
  final TextEditingController _usernameController =
      TextEditingController(); // Controller for username
  final TextEditingController _passwordController =
      TextEditingController(); // Controller for current password
  final TextEditingController _newPasswordController =
      TextEditingController(); // Controller for new password
  final TextEditingController _emailController =
      TextEditingController(); // Controller for current email
  final TextEditingController _newEmailController =
      TextEditingController(); // Controller for new email

  bool _isLoading = true; // Loading state for user data
  bool _showNewPasswordField = false; // State for showing new password field
  bool _showNewEmailField = false; // State for showing new email field

  @override
  void initState() {
    super.initState();
    getUserData(); // Fetch user data when the widget is initialized
  }

  // Method to retrieve user data from Firestore
  Future<void> getUserData() async {
    final user = FirebaseAuth.instance.currentUser; // Get the current user
    if (user == null) return; // Exit if no user is logged in

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid) // Get user document by UID
        .get();

    if (doc.exists) {
      final data = doc.data(); // Fetch data from the document
      if (data != null) {
        // Populate text controllers with existing user data
        _firstNameController.text = data['firstName'] ?? '';
        _lastNameController.text = data['lastName'] ?? '';
        _usernameController.text = data['username'] ?? '';
        _emailController.text = data['email'] ?? '';
        _passwordController.text = data['password'] ?? '';
      }
    }

    setState(() {
      _isLoading = false; // Update loading state
    });
  }

  // Method to save changes to user details
  void _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      // Validate the form
      final user = FirebaseAuth.instance.currentUser; // Get the current user
      if (user == null) return; // Exit if no user is logged in

      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid); // Reference to the user document

      final currentPassword =
          _passwordController.text.trim(); // Current password
      final newPassword = _newPasswordController.text.trim(); // New password
      final newEmail = _newEmailController.text.trim(); // New email
      final currentEmail = user.email!; // Current email

      try {
        // Reauthenticate if the user wants to update email or password
        if (_showNewEmailField || _showNewPasswordField) {
          final credential = EmailAuthProvider.credential(
            email: currentEmail,
            password: currentPassword,
          );
          await user.reauthenticateWithCredential(credential);
        }

        // Update Firebase Auth Email
        if (_showNewEmailField &&
            newEmail.isNotEmpty &&
            newEmail != currentEmail) {
          await user.verifyBeforeUpdateEmail(newEmail); // Verify new email
        }

        // Update Firebase Auth Password
        if (_showNewPasswordField &&
            newPassword.isNotEmpty &&
            newPassword != currentPassword) {
          await user.updatePassword(newPassword); // Update password
        }

        // Update Firestore with new details
        await docRef.update({
          'firstName': _firstNameController.text,
          'lastName': _lastNameController.text,
          'username': _usernameController.text,
          'email': _showNewEmailField && newEmail.isNotEmpty
              ? newEmail
              : currentEmail,
          'password': _showNewPasswordField && newPassword.isNotEmpty
              ? newPassword
              : currentPassword,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم تحديث المعلومات بنجاح!'),
          ), // Success message
        );
      } on FirebaseAuthException catch (e) {
        print('FirebaseAuthException: ${e.code} - ${e.message}'); // Log error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل التحديث: ${e.message}')), // Error message
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      ); // Show loading indicator while fetching data
    }

    return SafeArea(
      child: SingleChildScrollView(
        // Wrap the whole content in a scroll view
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              Directionality(
                textDirection: TextDirection
                    .rtl, // Right-to-left text direction for Arabic
                child: Form(
                  key: _formKey, // Assign form key
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 10), // Space above the icon
                      Container(
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(
                            59,
                            162,
                            154,
                            221,
                          ), // Icon background color
                          shape: BoxShape.circle, // Circular shape
                        ),
                        margin: const EdgeInsets.symmetric(
                          vertical: 20,
                        ), // Vertical margin
                        child: const Icon(
                          Icons.person, // User icon
                          size: 90,
                          color: Colors.white, // Icon color
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: inputField(
                              placeholder:
                                  'الإسم الأول', // Placeholder for first name
                              controller: _firstNameController,
                              validator: (value) => value!.isEmpty
                                  ? 'يرجى إدخال الاسم الأول'
                                  : null, // Validation
                            ),
                          ),
                          const SizedBox(width: 10), // Space between fields
                          Expanded(
                            child: inputField(
                              placeholder:
                                  'اسم العائلة', // Placeholder for last name
                              controller: _lastNameController,
                              validator: (value) => value!.isEmpty
                                  ? 'يرجى إدخال اسم العائلة'
                                  : null, // Validation
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10), // Space below name fields
                      inputField(
                        placeholder: 'اسم المستخدم', // Placeholder for username
                        controller: _usernameController,
                        validator: (value) => value!.isEmpty
                            ? 'يرجى إدخال اسم المستخدم'
                            : null, // Validation
                      ),
                      const SizedBox(height: 10), // Space below username field
                      inputField(
                        placeholder:
                            'البريد الإلكتروني', // Placeholder for email
                        controller: _emailController,
                        validator: (value) => value == null ||
                                value.isEmpty ||
                                !value.contains('@')
                            ? 'قم بإدخال بريد إلكتروني صحيح'
                            : null, // Validation
                      ),
                      const SizedBox(height: 10), // Space below email field

                      inputField(
                        placeholder:
                            'كلمة السر الحالية', // Placeholder for current password
                        controller: _passwordController,
                        obscureText: true, // Mask password input
                        validator: (value) {
                          if (value == null || value.length < 6) {
                            return 'كلمة السر ضعيفة'; // Validation message
                          }
                          return null; // Return null if valid
                        },
                      ),
                      TextButton.icon(
                        icon: const Icon(
                          Icons.logout,
                          color: Color.fromARGB(
                              255, 231, 5, 5), // Logout icon color
                        ),
                        label: const Text(
                          'تسجيل الخروج', // Logout button label
                          style: TextStyle(
                            color: Color.fromARGB(255, 240, 239, 239),
                          ), // Text color
                        ),
                        onPressed: () {
                          FirebaseAuth.instance.signOut(); // Sign out the user
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const welcome(),
                            ), // Navigate to welcome screen
                          );
                        },
                      ),
                      const SizedBox(height: 10), // Space below logout button
                      Row(
                        children: [
                          Checkbox(
                            value:
                                _showNewEmailField, // Checkbox for new email field
                            onChanged: (val) {
                              setState(
                                () => _showNewEmailField = val ?? false,
                              ); // Update state
                            },
                          ),
                          const Text(
                            'أرغب بتغيير البريد الإلكتروني',
                          ), // Checkbox label
                        ],
                      ),
                      if (_showNewEmailField)
                        inputField(
                          placeholder:
                              'البريد الإلكتروني الجديد', // Placeholder for new email
                          controller: _newEmailController,
                          validator: (value) {
                            if (value != null &&
                                value.isEmpty &&
                                !value.contains('@')) {
                              return ' البريد الالكتروني الجديد غير صالح '; // Validation message
                            }
                            return null; // Return null if valid
                          },
                        ),
                      const SizedBox(height: 10), // Space below new email field
                      Row(
                        children: [
                          Checkbox(
                            value:
                                _showNewPasswordField, // Checkbox for new password field
                            onChanged: (val) {
                              setState(
                                () => _showNewPasswordField = val ?? false,
                              ); // Update state
                            },
                          ),
                          const Text('أرغب بتغيير كلمة السر'), // Checkbox label
                        ],
                      ),
                      if (_showNewPasswordField)
                        inputField(
                          placeholder:
                              'كلمة السر الجديدة', // Placeholder for new password
                          controller: _newPasswordController,
                          obscureText: true, // Mask password input
                          validator: (value) {
                            if (value != null &&
                                value.isEmpty &&
                                value.length < 6) {
                              return 'كلمة السر الجديدة ضعيفة'; // Validation message
                            }
                            return null; // Return null if valid
                          },
                        ),

                      const SizedBox(height: 20), // Space before save button
                      ElevatedButton(
                        onPressed: _saveChanges, // Save changes on button press
                        child: const Text('حفظ التغييرات'), // Button label
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 10, // Position for back button
                left: 5,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ), // Back button icon
                  onPressed: () => Navigator.of(context).pop(), // Navigate back
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

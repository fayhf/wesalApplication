import 'package:flutter/material.dart';

// Custom input field widget
class inputField extends StatefulWidget {
  final String placeholder; // Placeholder text for the input field
  final TextEditingController controller; // Controller for managing input
  final String? Function(String?)?
  validator; // Validator function for input validation
  final bool obscureText; // Whether to obscure text (for passwords)

  const inputField({
    Key? key,
    required this.placeholder,
    required this.controller,
    this.validator,
    this.obscureText = false, // Default to false
  }) : super(key: key);

  @override
  State<inputField> createState() => _inputFieldState(); // Create state for this widget
}

class _inputFieldState extends State<inputField> {
  late bool _obscure; // State for obscuring text

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText; // Initialize obscuring state
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ), // Padding for input field
      child: TextFormField(
        controller: widget.controller, // Assign controller
        obscureText: _obscure, // Set obscuring state
        textAlign: TextAlign.right, // Right-aligned text for Arabic
        validator: widget.validator, // Assign validator
        decoration: InputDecoration(
          labelText: widget.placeholder, // Placeholder text
          labelStyle: const TextStyle(
            color: Color.fromARGB(255, 242, 241, 243), // Label color
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30), // Rounded corners
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 243, 238, 238), // Border color
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30), // Rounded corners
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 243, 238, 238), // Border color
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30), // Rounded corners
            borderSide: const BorderSide(
              color: Color.fromARGB(
                255,
                119,
                63,
                251,
              ), // Border color when focused
            ),
          ),
          suffixIcon:
              widget
                      .obscureText // Suffix icon for password visibility toggle
                  ? IconButton(
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_off
                          : Icons.visibility, // Show/hide icon
                      color: const Color.fromARGB(255, 200, 200, 200),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscure = !_obscure; // Toggle obscuring state
                      });
                    },
                  )
                  : null, // No suffix icon if not obscured
        ),
      ),
    );
  }
}

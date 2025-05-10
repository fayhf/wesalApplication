import 'package:flutter/material.dart';

// Custom input field widget
class inputField extends StatefulWidget {
  final String placeholder;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool obscureText;

  const inputField({
    Key? key,
    required this.placeholder,
    required this.controller,
    this.validator,
    this.obscureText = false,
  }) : super(key: key);

  @override
  State<inputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<inputField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextFormField(
        key: Key(widget.placeholder), // 🔑 makes widget testable
        controller: widget.controller,
        obscureText: _obscure,
        textAlign: TextAlign.right,
        validator: widget.validator,
        decoration: InputDecoration(
          labelText: widget.placeholder,
          labelStyle: const TextStyle(
            color: Color.fromARGB(255, 242, 241, 243),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 243, 238, 238),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 119, 63, 251),
            ),
          ),
          suffixIcon: widget.obscureText
              ? IconButton(
                  icon: Icon(
                    _obscure ? Icons.visibility_off : Icons.visibility,
                    color: const Color.fromARGB(255, 200, 200, 200),
                  ),
                  onPressed: () {
                    setState(() {
                      _obscure = !_obscure;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}

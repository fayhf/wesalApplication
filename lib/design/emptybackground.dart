import 'package:flutter/material.dart';

// Stateless widget to create a background with a gradient and a child widget
class emptybackground extends StatelessWidget {
  const emptybackground({
    super.key,
    required this.widget,
  }); // Constructor with a required widget

  final Widget widget; // The widget to be displayed on top of the background

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Full-screen container with a gradient background
        Container(
          width: double.infinity, // Full width
          height: double.infinity, // Full height
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(
                  255,
                  114,
                  54,
                  255,
                ), // First color of the gradient
                const Color.fromARGB(255, 211, 99, 205), // Second color
                const Color.fromARGB(255, 255, 174, 168), // Third color
              ],
              begin: Alignment.topCenter, // Gradient starts from the top
              end: Alignment.bottomCenter, // Gradient ends at the bottom
            ),
          ),
          child: Center(
            child: Column(
              children: [widget], // Place the child widget in the center
            ),
          ),
        ),
      ],
    );
  }
}

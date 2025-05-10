import 'package:flutter/material.dart';

// This widget creates a gradient background and contains two child widgets
class GradientAndContent extends StatelessWidget {
  const GradientAndContent({
    super.key,
    required this.widget1, // First child widget (bar)
    required this.widget2, // Second child widget (body)
  });

  final Widget widget1;
  final Widget widget2;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Container for the gradient background
        Container(
          width: double.infinity, // Full width of the container
          height: 150, // Fixed height for the gradient section
          margin: EdgeInsets.only(bottom: 530), // Positioning the gradient
          padding: EdgeInsets.only(
            bottom: 10,
            right: 30,
            left: 30,
          ), // Padding within the gradient
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(
                  255,
                  114,
                  54,
                  255,
                ), // Start color of the gradient
                const Color.fromARGB(255, 211, 99, 205), // Middle color
                const Color.fromARGB(255, 255, 174, 168), // End color
              ],
              begin: Alignment.topCenter, // Gradient starts from the top
              end: Alignment(0, 2), // Gradient ends towards the bottom
            ),
          ),
          child: widget1, // Display the first widget
        ),

        // Container for the main content area
        Container(
          width: double.infinity, // Full width of the container
          height: double.infinity, // Full height to cover the remaining space
          margin: EdgeInsets.only(top: 105), // Positioning below the gradient
          padding: EdgeInsets.only(
            left: 30,
            right: 30,
            top: 20,
          ), // Padding within the content
          decoration: BoxDecoration(
            color: Colors.white, // Background color of the content area
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(35), // Rounded corners at the top
            ),
          ),
          child: widget2, // Display the second widget
        ),
      ],
    );
  }
}

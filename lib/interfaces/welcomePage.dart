import 'package:flutter/material.dart';
import 'package:wesal_app_final/design/emptybackground.dart';
import 'package:wesal_app_final/widgets/mainScreen/welcomewidget.dart';

// Stateless widget for the welcome screen
class welcome extends StatelessWidget {
  const welcome({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold to provide a basic material design layout
    return const Scaffold(
      // Uses empty background with a welcome widget
      body: emptybackground(widget: Welcomewidget()),
    );
  }
}

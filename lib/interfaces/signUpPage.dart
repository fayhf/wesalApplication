import 'package:flutter/material.dart';
import 'package:wesal_app_final/design/emptybackground.dart';
import 'package:wesal_app_final/widgets/registration/signupwidget.dart';

class signup extends StatelessWidget {
  const signup({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold to provide a basic material design layout
    return const Scaffold(
      body: emptybackground(
        widget: signupwidget(),
      ), // Uses empty background with signup widget
    );
  }
}
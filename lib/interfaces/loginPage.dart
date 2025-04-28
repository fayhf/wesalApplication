import 'package:flutter/material.dart';
import 'package:wesal_app_final/design/emptybackground.dart';
import 'package:wesal_app_final/widgets/registration/loginwidget.dart';

class login extends StatelessWidget {
  const login({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold to provide a basic material design layout
    return Scaffold(
      body: const emptybackground(
        widget: LoginWidget(),
      ), // Uses empty background with login widget
    );
  }
}

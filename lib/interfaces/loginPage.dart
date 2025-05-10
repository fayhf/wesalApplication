import 'package:flutter/material.dart';
import 'package:wesal_app_final/design/emptybackground.dart';
import 'package:wesal_app_final/widgets/registration/loginwidget.dart';
import 'package:firebase_auth/firebase_auth.dart';

class login extends StatelessWidget {
  const login({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold to provide a basic material design layout
    return Scaffold(
      body: emptybackground(
        widget: LoginWidget(auth: FirebaseAuth.instance),
      ), // Uses empty background with login widget
    );
  }
}

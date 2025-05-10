import 'package:flutter/material.dart';
import 'package:wesal_app_final/design/emptybackground.dart';
import 'package:wesal_app_final/widgets/registration/ForgotPasswordWidget.dart';

// Stateless widget for the Forgot Password screen
class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: emptybackground(widget: ForgotPasswordWidget()),
    );
  }
}

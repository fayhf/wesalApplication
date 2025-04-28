import 'package:flutter/material.dart';
import 'package:wesal_app_final/widgets/mainScreen/accountdetails.dart';
import 'package:wesal_app_final/design/emptybackground.dart';

// Stateless widget for the user account screen
class userAccount extends StatelessWidget {
  const userAccount({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold to provide a basic material design layout
    return Scaffold(
      body: emptybackground(
        widget: Accountdetails(),
      ), // Uses empty background with account details
    );
  }
}

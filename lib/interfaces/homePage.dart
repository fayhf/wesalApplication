import 'package:flutter/material.dart';
import 'package:wesal_app_final/design/background.dart';
import 'package:wesal_app_final/widgets/mainScreen/homepage_bar.dart';
import 'package:wesal_app_final/widgets/mainScreen/homepage_body.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Scaffold to provide a basic material design layout
      home: Scaffold(
        body: GradientAndContent(
          widget1: homepageBarWidget(), // Bar at the top of the page
          widget2: homepageBodyWidget(), // Main content of the page
        ),
      ),
    );
  }
}
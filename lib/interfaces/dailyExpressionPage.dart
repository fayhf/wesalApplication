import 'package:flutter/material.dart';
import 'package:wesal_app_final/design/background.dart';
import 'package:wesal_app_final/widgets/dailyExpressionWidgets/dailyWidget.dart';
import 'package:wesal_app_final/design/BarWidget.dart';

// A Stateless widget that represents the daily expression page
class dailyExpressionPage extends StatelessWidget {
  const dailyExpressionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        // Uses the GradientAndContent widget to display gradient background consist of 2 widgets
        body: GradientAndContent(
          widget1: barWidget(), // Bar widget displayed in the gradient section
          widget2: DailyWidget2(), // DailyWidget to display the main content
        ),
      ),
    );
  }
}

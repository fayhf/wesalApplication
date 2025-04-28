import 'package:flutter/material.dart';
import 'package:wesal_app_final/design/background.dart';
import 'package:wesal_app_final/widgets/dailyExpressionWidgets/dailyExpressionObject.dart';
import 'package:wesal_app_final/design/BarWidget.dart';
import 'package:wesal_app_final/widgets/dailyExpressionWidgets/expressionDetailes.dart';

// A Stateless widget that represents the daily expression page
class expressionDetailsPage extends StatelessWidget {
  final DailyExpression expression;
  
  const expressionDetailsPage({super.key, required this.expression});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // Uses the GradientAndContent widget to display gradient background consist of 2 widgets
        body: GradientAndContent(
          widget1: const barWidget(), // Bar widget displayed in the gradient section
          widget2: ExpressionDetails(expression: expression), // DailyWidget to display the main content
        ),
      ),
    );
  }
}

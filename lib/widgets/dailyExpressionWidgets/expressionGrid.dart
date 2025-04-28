import 'package:flutter/material.dart';
import 'package:wesal_app_final/widgets/dailyExpressionWidgets/GridItem.dart';
import 'package:wesal_app_final/widgets/dailyExpressionWidgets/dailyExpressionObject.dart';

class ExpressionsGrid extends StatelessWidget {
  final List<DailyExpression> filteredExpressions;
  final Set<String> selectedItems;
  final bool isDeleteMode;
  final Function(String) onItemTap;

  const ExpressionsGrid({
    Key? key,
    required this.filteredExpressions,
    required this.selectedItems,
    required this.isDeleteMode,
    required this.onItemTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.all(6),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
          mainAxisSpacing: 6,
          crossAxisSpacing: 6,
        ),
        itemCount: filteredExpressions.length,
        itemBuilder: (context, index) {
          final expression = filteredExpressions[index];
          final isSelected = selectedItems.contains(expression.name);

          return GridItem(
            index: index,
            expression: expression,
            isSelected: isSelected,
            onTap: () => onItemTap(expression.name),
          );
        },
      ),
    );
  }
}

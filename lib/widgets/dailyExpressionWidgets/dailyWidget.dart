import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wesal_app_final/interfaces/expressionDetailsPage.dart';
import 'package:wesal_app_final/widgets/dailyExpressionWidgets/dailyExpressionObject.dart';
import 'package:wesal_app_final/widgets/dailyExpressionWidgets/BottomActions.dart';
import 'package:wesal_app_final/widgets/dailyExpressionWidgets/expressionGrid.dart';
import 'package:wesal_app_final/widgets/dailyExpressionWidgets/searchAndDeleteBar.dart';
import 'package:wesal_app_final/widgets/dailyExpressionWidgets/dailyExpressionService.dart';
import 'package:wesal_app_final/dialog/showGuestDialog.dart';
import 'package:wesal_app_final/widgets/dailyExpressionWidgets/addingExpressionForm.dart';
import 'package:wesal_app_final/interfaces/homePage.dart';

class DailyWidget2 extends StatefulWidget {
  const DailyWidget2({super.key});

  @override
  State<DailyWidget2> createState() => _DailyWidgetState();
}

class _DailyWidgetState extends State<DailyWidget2> {
  // List to store daily expressions
  List<DailyExpression> expressions = [];
  
  // Boolean flag for delete mode
  bool isDeleteMode = false;
  
  // Set to store selected items for deletion
  Set<String> selectedItems = {};
  
  // Search query to filter expressions
  String searchQuery = '';
  
  // Instance of the service for fetching and managing expressions
  final _service = DailyExpressionService();

  @override
  void initState() {
    super.initState();
    fetchExpressions(); // Fetch expressions when the widget is initialized
  }

  // Fetches expressions from Firestore based on the user ID
  Future<void> fetchExpressions() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    // Fetch the expressions for the current user
    final fetchedExpressions = await _service.fetchExpressions(uid); 

    // Update the UI with fetched expressions
    setState(() {
      expressions = fetchedExpressions;
    });
  }

  // Filters the expressions based on the search query
  List<DailyExpression> get filteredExpression {
    if (searchQuery.isEmpty) return expressions;
    return expressions
        .where((de) => de.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  // Toggle selection of an expression for deletion
  void toggleSelection(String item) {
    // Check if the expression is a default one
    final isDefault = expressions.any((de) => de.name == item && de.uid == 'default');

    if (isDefault) {
      // Show a dialog to inform the user that default expressions can't be deleted
      showDialog(
        context: context,
        builder: (context) => Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Text('غير مسموح'),
            content: const Text('لا يمكنك حذف التعابير الأساسية.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('حسنًا'),
              ),
            ],
          ),
        ),
      );
      return; // Stop here and don't allow selection of default items
    }

    // Add or remove the expression from selected items for deletion
    setState(() {
      if (selectedItems.contains(item)) {
        selectedItems.remove(item);
      } else {
        selectedItems.add(item);
      }
    });
  }

  // Delete the selected expressions from Firestore
  Future<void> deleteSelectedItems() async {
    for (final name in selectedItems) {
      try {
        await _service.deleteExpressionById(name); // Delete the expression by ID
      } catch (e) {
        print("Error deleting $name: $e"); // Log any errors during deletion
      }
    }

    // Refresh the list of expressions after deletion
    await fetchExpressions(); 
    setState(() {
      selectedItems.clear(); // Clear the selected items
      isDeleteMode = false; // Exit delete mode
    });
  }

  // Add a new expression to Firestore and update the UI
  Future<void> addToFirestore(DailyExpression de) async {
    await _service.addExpression(de); // Add the new expression to Firestore
    setState(() => expressions.add(de)); // Update the list of expressions in the UI
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search and delete bar widget
        SearchAndDeleteBar(
          searchQuery: searchQuery,
          isDeleteMode: isDeleteMode,
          onSearchChanged: (value) {
            setState(() {
              searchQuery = value; // Update the search query when it changes
            });
          },
          onDeleteToggle: () {
            if (FirebaseAuth.instance.currentUser != null) {
              if (isDeleteMode) {
                deleteSelectedItems(); // If in delete mode, delete the selected items
              } else {
                setState(() {
                  isDeleteMode = true; // Enter delete mode
                });
              }
            } else {
              // Show guest dialog if the user is not logged in
              DialogHelper.showGuestDialog(context);
            }
          },
        ),

        // Grid of daily expressions
        ExpressionsGrid(
          filteredExpressions: filteredExpression,
          selectedItems: selectedItems,
          isDeleteMode: isDeleteMode,
          onItemTap: (name) {
            if (isDeleteMode) {
              toggleSelection(name); // Toggle selection if in delete mode
            } else {
              // Navigate to the detailed view of the selected expression
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => expressionDetailsPage(expression: expressions.firstWhere((e) => e.name == name)),
                ),
              );
            }
          },
        ),
        // Bottom actions (Add and Home buttons)
        BottomActions(
          isDeleteMode: isDeleteMode,
          onAddButtonPressed: () async {
            if (FirebaseAuth.instance.currentUser != null) {
              // Show the form to create a new daily expression
              final newDE = await showDialog<DailyExpression>(
                context: context,
                builder: (context) => CreateDailyExpressionForm(),
              );

              if (newDE != null) {
                await addToFirestore(newDE); // Add the new expression if valid
              }
            } else {
              // Show guest dialog if the user is not logged in
              DialogHelper.showGuestDialog(context);
            }
          },
          onHomeButtonPressed: () {
            // Navigate to the home page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
      ],
    );
  }
}

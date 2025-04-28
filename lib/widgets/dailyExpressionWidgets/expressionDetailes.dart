import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:wesal_app_final/dialog/editExpressionDialog.dart';
import 'package:wesal_app_final/interfaces/dailyExpressionPage.dart';
import 'package:wesal_app_final/widgets/dailyExpressionWidgets/dailyExpressionObject.dart';
import 'package:wesal_app_final/widgets/dailyExpressionWidgets/dailyExpressionService.dart';


class ExpressionDetails extends StatefulWidget {
  final DailyExpression expression;

  const ExpressionDetails({required this.expression});

  @override
  _ExpressionDetailsState createState() => _ExpressionDetailsState();
}

class _ExpressionDetailsState extends State<ExpressionDetails> {
  final _collection = FirebaseFirestore.instance.collection('daily_expressions');
  final _service = DailyExpressionService();
  late DailyExpression expression;
  late String d= expression.description;

  @override
  void initState() {
    super.initState();
    expression = widget.expression;
  
  }

   TextEditingController nameController =
      TextEditingController(); // Controller for name input
  TextEditingController descController =
      TextEditingController(); // Controller for description input

  // Method to show the edit dialog
  void showEditDialog() {
  nameController.text = expression.name;
  descController.text = expression.description;

  showDialog(
    context: context,
    builder: (context) {
      return EditExpressionDialog(
  descController: descController,
  onSave: () {
    setState(() {
      editExpression(descController.text);
      d = descController.text;
       // Update only description
    });
    // Call the editExpression method with updated description
    
    Navigator.of(context).pop();
  }, name: expression.name,
);

    },
  );
}

 Future<void> deleteSelectedItems() async {
      try {
        await _service.deleteExpressionById(expression.name); // Delete the expression by ID
      } catch (e) {
         // Log any errors during deletion
      }
    }

Future<void> editExpression(String d0) async {
  await _collection.doc(expression.name).update({
    'description': d0,
  });
}

void _speakDescription() async {
    FlutterTts tts = FlutterTts();
    await tts.setLanguage(expression.sound); // 'ar' or 'en'
    await tts.setPitch(1.0);
    await tts.speak(d);
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Color.fromARGB(0, 255, 255, 255),
      title: Text(expression.name),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => dailyExpressionPage()),
          );
        },
      ),
    ),

    body: Center(
      child: Column(
        children: [
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              d,
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 20),
          IconButton(
            onPressed: _speakDescription,
            icon: Icon(Icons.volume_up, color: Colors.blue, size: 40),
          ),
        ],
      ),
    ),

    bottomNavigationBar: widget.expression.uid != "default" // Check if not default
        ? Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      // Show confirm dialog
                      bool confirmDelete = await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(
                            "تأكيد الحذف",
                            textAlign: TextAlign.center,
                          ),
                          content: Text(
                            "هل انت متأكد من حذف التعبير؟",
                            textAlign: TextAlign.center,
                          ),
                          actionsAlignment: MainAxisAlignment.center,
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(false); // No
                              },
                              child: Text("لا"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop(true); // Yes
                              },
                              child: Text("نعم"),
                            ),
                          ],
                        ),
                      );

                      if (confirmDelete == true) {
                        await deleteSelectedItems(); // Delete
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => dailyExpressionPage()),
                        ); // Navigate back
                      }
                    },
                    child: Text("حذف التعبير"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 222, 220),
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: showEditDialog,
                    child: Text("تعديل التعبير"),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
                ),
              ],
            ),
          )
        : SizedBox(), //If it's default, return empty SizedBox
  );
}


}

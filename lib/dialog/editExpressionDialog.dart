import 'package:flutter/material.dart';

class EditExpressionDialog extends StatelessWidget {
  final TextEditingController descController;
  final VoidCallback onSave;
  final String name;

  const EditExpressionDialog({
    required this.descController,
    required this.onSave,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("تعديل وصف: $name", textAlign: TextAlign.right),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "الوصف",
                style: TextStyle(fontSize: 14),
              ),
            ),
            TextField(
              controller: descController,
              minLines: 3,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              textDirection: TextDirection.rtl,
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: onSave, // Call the save function
                child: Text("تم"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

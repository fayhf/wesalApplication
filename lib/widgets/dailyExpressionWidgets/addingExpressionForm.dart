// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:wesal_app_final/deObject/dailyExpressionObject.dart';

// class CreateDailyExpressionForm extends StatefulWidget {
//   @override
//   _CreateDailyExpressionFormState createState() => _CreateDailyExpressionFormState();
// }

// class _CreateDailyExpressionFormState extends State<CreateDailyExpressionForm> {
//   final FlutterTts flutterTts = FlutterTts();
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();

//   String selectedLanguage = 'ar';
//   File? _selectedImageFile;
//   String? uploadedImageUrl;

//   @override
//   void initState() {
//     super.initState();
//     initTts();
//   }

//   Future<void> initTts() async {
//     await flutterTts.setLanguage(selectedLanguage);
//     await flutterTts.setPitch(1.0);
//   }

//   Future<void> _pickImage() async {
//     final result = await FilePicker.platform.pickFiles(type: FileType.image);
//     if (result != null && result.files.single.path != null) {
//       setState(() {
//         _selectedImageFile = File(result.files.single.path!);
//       });
//     }
//   }

//   Future<String?> _uploadImageToFirebase(File imageFile) async {
//     try {
//       final fileName = DateTime.now().millisecondsSinceEpoch.toString();
//       final ref = FirebaseStorage.instance.ref().child('de_images/$fileName');
//       await ref.putFile(imageFile);
//       return await ref.getDownloadURL();
//     } catch (e) {
//       print("Image upload failed: $e");
//       return null;
//     }
//   }

//   Future<void> _submit() async {
//     final name = nameController.text.trim();
//     final description = descriptionController.text.trim();

//     if (name.isEmpty || description.isEmpty) {
//       _showAlert('خطأ', 'يرجى ملء الاسم والوصف قبل الإضافة.');
//       return;
//     }

//     final doc = await FirebaseFirestore.instance.collection('daily_expressions').doc(name).get();
//     if (doc.exists) {
//       _showAlert('اسم مكرر', 'هذا الاسم مستخدم بالفعل، يرجى اختيار اسم مختلف.');
//       return;
//     }

//     if (_selectedImageFile != null) {
//       uploadedImageUrl = await _uploadImageToFirebase(_selectedImageFile!);
//     }

//     final newDE = DailyExpression(
//       uid: FirebaseAuth.instance.currentUser!.uid,
//       name: name,
//       description: description,
//       photo: uploadedImageUrl,
//       sound: selectedLanguage,
//     );

//     Navigator.of(context).pop(newDE);
//   }

//   void _showAlert(String title, String message) {
//     showDialog(
//       context: context,
//       builder: (context) => Directionality(
//         textDirection: TextDirection.rtl,
//         child: AlertDialog(
//           title: Text(title),
//           content: Text(message),
//           actions: [
//             TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('حسنًا')),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: selectedLanguage == 'ar' ? TextDirection.rtl : TextDirection.ltr,
//       child: Scaffold(
//         appBar: AppBar(
//           automaticallyImplyLeading: false,
//           title: Text('إضافة تعبير يومي'),
//           actions: [
//             IconButton(icon: Icon(Icons.close), onPressed: () => Navigator.pop(context)),
//           ],
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 DropdownButtonFormField<String>(
//                   value: selectedLanguage,
//                   decoration: InputDecoration(labelText: 'اختر اللغة', border: OutlineInputBorder()),
//                   items: [
//                     DropdownMenuItem(value: 'ar', child: Text('العربية')),
//                     DropdownMenuItem(value: 'en', child: Text('English')),
//                   ],
//                   onChanged: (value) async {
//                     setState(() {
//                       selectedLanguage = value!;
//                     });
//                     await flutterTts.setLanguage(selectedLanguage);
//                   },
//                 ),
//                 SizedBox(height: 16),
//                 TextField(
//                   controller: nameController,
//                   textAlign: selectedLanguage == 'ar' ? TextAlign.right : TextAlign.left,
//                   decoration: InputDecoration(
//                     labelText: selectedLanguage == 'ar' ? 'ادخل اسم التعبير' : 'Enter expression name',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 ElevatedButton.icon(
//                   onPressed: _pickImage,
//                   icon: Icon(Icons.image),
//                   label: Text(selectedLanguage == 'ar' ? 'تحميل صورة' : 'Upload Image'),
//                 ),
//                 if (_selectedImageFile != null)
//                   Padding(
//                     padding: const EdgeInsets.only(top: 10.0),
//                     child: Image.file(_selectedImageFile!, height: 100),
//                   ),
//                 SizedBox(height: 16),
//                 TextField(
//                   controller: descriptionController,
//                   textAlign: selectedLanguage == 'ar' ? TextAlign.right : TextAlign.left,
//                   maxLines: 4,
//                   decoration: InputDecoration(
//                     labelText: selectedLanguage == 'ar' ? 'ادخل الوصف المسموع' : 'Enter description',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
                
//                 SizedBox(height: 12),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: ElevatedButton.icon(
//                         onPressed: () async {
//                           String text = descriptionController.text.trim();
//                           if (text.isNotEmpty) {
//                             await flutterTts.stop();
//                             await flutterTts.speak(text);
//                           }
//                         },
//                         icon: Icon(Icons.volume_up),
//                         label: Text(selectedLanguage == 'ar' ? 'تشغيل الصوت' : 'Play Audio'),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: _submit,
//                   style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
//                   child: Text(
//                     selectedLanguage == 'ar' ? 'انشاء التعبير اليومي' : 'Create Daily Expression',
//                     style: TextStyle(fontSize: 18, color: Colors.white),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wesal_app_final/widgets/dailyExpressionWidgets/dailyExpressionObject.dart'; // adjust this import if needed

class CreateDailyExpressionForm extends StatefulWidget {
  @override
  _CreateDailyExpressionFormState createState() =>
      _CreateDailyExpressionFormState();
}

class _CreateDailyExpressionFormState
    extends State<CreateDailyExpressionForm> {
  final FlutterTts flutterTts = FlutterTts();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController photoController = TextEditingController();

  String selectedLanguage = 'ar'; // Default is Arabic

  @override
  void initState() {
    super.initState();
    initTts();
  }

  Future<void> initTts() async {
    await flutterTts.setLanguage(selectedLanguage);
    await flutterTts.setPitch(1.0);
  }
  Future<void> _submit() async {
      final name = nameController.text.trim();
  final description = descriptionController.text.trim();

  if (name.isEmpty || description.isEmpty) {
    // Show an error dialog or snackbar
    showDialog(
  context: context,
  builder: (context) => Directionality(
    textDirection: TextDirection.rtl,
    child: AlertDialog(
      title: const Text('خطأ'),
      content: const Text('يرجى ملء الاسم والوصف قبل الإضافة.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('حسنًا'),
        ),
      ],
    ),
  ),
);
    return;
  }

    // 🔍 Check for uniqueness in Firestore
  final doc = await FirebaseFirestore.instance
      .collection('daily_expressions')
      .doc(name)
      .get();

  if (doc.exists) {
    // Name already exists
    showDialog(
  context: context,
  builder: (context) => Directionality(
    textDirection: TextDirection.rtl,
    child: AlertDialog(
      title: const Text('اسم مكرر'),
      content: const Text('هذا الاسم مستخدم بالفعل، يرجى اختيار اسم مختلف.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('حسنًا'),
        ),
      ],
    ),
  ),
);

    return;
  }


  final newDE = DailyExpression(
    uid: FirebaseAuth.instance.currentUser!.uid,
    name: name,
    description: description,
    photo: photoController.text.trim().isEmpty ? null : photoController.text.trim(),
    sound: selectedLanguage,
  );

  Navigator.of(context).pop(newDE);
    
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          selectedLanguage == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('إضافة تعبير يومي'),
          actions: [
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Language Selector
                DropdownButtonFormField<String>(
                  value: selectedLanguage,
                  decoration: InputDecoration(
                    labelText: 'اختر اللغة',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    DropdownMenuItem(value: 'ar', child: Text('العربية')),
                    DropdownMenuItem(value: 'en', child: Text('English')),
                  ],
                  onChanged: (value) async {
                    setState(() {
                      selectedLanguage = value!;
                    });
                    await flutterTts.setLanguage(selectedLanguage);
                  },
                ),
                SizedBox(height: 16),

                // Name Field
                TextField(
                  controller: nameController,
                  textAlign: selectedLanguage == 'ar'
                      ? TextAlign.right
                      : TextAlign.left,
                  decoration: InputDecoration(
                    labelText: selectedLanguage == 'ar'
                        ? 'ادخل اسم التعبير'
                        : 'Enter expression name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),

                // Description Field
                TextField(
                  controller: descriptionController,
                  textAlign: selectedLanguage == 'ar'
                      ? TextAlign.right
                      : TextAlign.left,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: selectedLanguage == 'ar'
                        ? 'ادخل الوصف المسموع'
                        : 'Enter description',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),

                // Photo URL Field
                // TextField(
                //   controller: photoController,
                //   textAlign: selectedLanguage == 'ar'
                //       ? TextAlign.right
                //       : TextAlign.left,
                //   decoration: InputDecoration(
                //     labelText: selectedLanguage == 'ar'
                //         ? 'رابط الصورة (اختياري)'
                //         : 'Image URL (optional)',
                //     border: OutlineInputBorder(),
                //   ),
                // ),
                // SizedBox(height: 12),

                // Play Audio Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          String text = descriptionController.text.trim();
                          if (text.isNotEmpty) {
                            await flutterTts.stop();
                            await flutterTts.speak(text);
                          }
                        },
                        icon: Icon(Icons.volume_up),
                        label: Text(selectedLanguage == 'ar'
                            ? 'تشغيل الصوت'
                            : 'Play Audio'),
                      ),
                    ),
                    SizedBox(width: 12),
                  ],
                ),
                SizedBox(height: 20),

                // Submit Button
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    selectedLanguage == 'ar'
                        ? 'انشاء التعبير اليومي'
                        : 'Create Daily Expression',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

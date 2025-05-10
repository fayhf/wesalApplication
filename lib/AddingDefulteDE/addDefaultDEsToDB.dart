import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addDefaultDEs() async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference deCollection = firestore.collection('daily_expressions');

  final List<Map<String, dynamic>> defaultDEs = [
    {
      
      "uid": "default",
      "name": "السؤال عن اتجاهات الحمام",
      "photo": "https://your-storage-link/hello.png",
      "sound": "https://your-storage-link/hello.mp3",
      "description": "من فضلك، هل يمكنك أن تدلني على مكان الحمام؟",
    },
    {
      "uid": "default",
      "name": "الوصول الى المستشفى",
      "photo": "https://your-storage-link/hello.png",
      "sound": "https://your-storage-link/hello.mp3",
      "description": "من فضلك، كيف يمكنني الوصول إلى المستشفى بسرعة؟",
    },
    {
      "uid": "default",
      "name": "طلب قائمة طعام مطعم",
      "photo": "https://your-storage-link/hello.png",
      "sound": "https://your-storage-link/hello.mp3",
      "description": "أحتاج قائمة الطعام من فضلك.",
    },
    {
      "uid": "default",
      "name": "طلب عملية الدفع",
      "photo": "https://your-storage-link/hello.png",
      "sound": "https://your-storage-link/hello.mp3",
      "description": "أريد أن أدفع الفاتورة، هل يمكنني الدفع الآن؟",
    },
  ];

  for (var de in defaultDEs) {
    final docId = de['name']; // unique name
    final docRef = deCollection.doc(docId);

    final docSnapshot = await docRef.get();
    if (!docSnapshot.exists) {
      await docRef.set(de);
      print('Added: ${de['name']}');
    } else {
      print('Skipped (already exists): ${de['name']}');
    }
  }
}

// Call addDefaultDEs() once in your main.dart or in a button action to run it once

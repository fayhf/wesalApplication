import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wesal_app_final/widgets/dailyExpressionWidgets/dailyExpressionObject.dart';

class DailyExpressionService {
  final _collection = FirebaseFirestore.instance.collection('daily_expressions');

  // Fetch expressions based on user UID
  Future<List<DailyExpression>> fetchExpressions(String? uid) async {
    Query query = _collection;

    if (uid == null) {
      query = query.where('uid', isEqualTo: 'default');
    } else {
      query = query.where('uid', whereIn: ['default', uid]);
    }

    final snapshot = await query.get();

    return snapshot.docs
        .map((doc) => DailyExpression.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  // Delete expression by document ID
  Future<void> deleteExpressionById(String docId) async {
    await _collection.doc(docId).delete();
  }


  // Add new expression to Firestore
  Future<void> addExpression(DailyExpression de) async {
    await _collection.doc(de.name).set(de.toMap());
  }
}


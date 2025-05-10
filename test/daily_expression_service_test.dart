import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:wesal_app_final/widgets/dailyExpressionWidgets/dailyExpressionObject.dart';
import 'package:wesal_app_final/widgets/dailyExpressionWidgets/dailyExpressionService.dart';

void main() {
  group('DailyExpressionService', () {
    test('fetchExpressions should return a list of DailyExpression objects',
        () async {
      final fakeFirestore = FakeFirebaseFirestore();
      final service = DailyExpressionService(firestore: fakeFirestore);

      final testExpression1 = DailyExpression(
        uid: '123',
        name: 'expression1',
        description: 'Test Description 1',
        sound: 'sound1.mp3',
        photo: null,
      );

      final testExpression2 = DailyExpression(
        uid: '123',
        name: 'expression2',
        description: 'Test Description 2',
        sound: 'sound2.mp3',
        photo: null,
      );

      // Add documents
      await fakeFirestore
          .collection('daily_expressions')
          .doc('expression1')
          .set(testExpression1.toMap());
      await fakeFirestore
          .collection('daily_expressions')
          .doc('expression2')
          .set(testExpression2.toMap());

      // Fetch expressions
      var expressions = await service.fetchExpressions('123');
      print('Documents fetched successfully');

      // Confirm the fetched expressions match
      expect(expressions.length, 2);
      expect(expressions[0].name, 'expression1');
      expect(expressions[1].name, 'expression2');
    });
////////////////////////////////////////////////////////////////
    test('should add a DailyExpression to Firestore', () async {
      // Arrange
      final fakeFirestore = FakeFirebaseFirestore();
      final service = DailyExpressionService(firestore: fakeFirestore);

      final expression = DailyExpression(
        uid: 'user_001',
        name: 'morning_smile',
        description: 'Woke up with a smile',
        sound: 'smile_sound.mp3',
      );

      // Act
      await service.addExpression(expression);
      print('Document added successfully');
      // Assert
      final snapshot = await fakeFirestore
          .collection('daily_expressions')
          .doc('morning_smile')
          .get();

      expect(snapshot.exists, true);

      final data = snapshot.data();
      expect(data?['uid'], 'user_001');
      expect(data?['name'], 'morning_smile');
      expect(data?['description'], 'Woke up with a smile');
      expect(data?['sound'], 'smile_sound.mp3');
    });

    /////////////////////////////////////////////////////////
    test('deleteExpressionById should remove the document from Firestore',
        () async {
      final fakeFirestore = FakeFirebaseFirestore();
      final service = DailyExpressionService(firestore: fakeFirestore);

      final testDoc = DailyExpression(
        uid: '123',
        name: 'test1',
        description: 'Test Description',
        sound: 'test_sound.mp3',
        photo: null,
      );

      // Add document
      await fakeFirestore
          .collection('daily_expressions')
          .doc('test1')
          .set(testDoc.toMap());

      // Ensure document exists
      var snapshotBefore =
          await fakeFirestore.collection('daily_expressions').get();
      expect(snapshotBefore.docs.length, 1);

      // Delete document
      await service.deleteExpressionById('test1');
      print('Document deleted successfully');

      // Confirm it's deleted
      var snapshotAfter =
          await fakeFirestore.collection('daily_expressions').get();
      expect(snapshotAfter.docs.length, 0);
    });
  });
}

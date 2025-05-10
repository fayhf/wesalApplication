import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wesal_app_final/widgets/registration/loginwidget.dart';
import 'mock_firebase_auth.mocks.dart'; // Generated file

void main() {
  testWidgets('shows SnackBar on wrong password', (WidgetTester tester) async {
    final mockAuth = MockFirebaseAuth();

    // Set up mock to throw FirebaseAuthException
    when(mockAuth.signInWithEmailAndPassword(
      email: anyNamed('email'),
      password: anyNamed('password'),
    )).thenThrow(FirebaseAuthException(
      code: 'wrong-password',
      message: 'The password is invalid.',
    ));

    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LoginWidget(auth: mockAuth),
        ),
      ),
    );

    // Enter email and password
    await tester.enterText(find.byType(TextFormField).at(0), 'test@gmail.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'wrongPassword');

    // Tap the login button
    await tester.tap(find.text('دخول'));
    await tester.pump(); // Triggers the async calls

    // Allow SnackBar animation
    await tester.pump(const Duration(seconds: 1));

    // Verify that the SnackBar is shown with expected message
    expect(find.text('تأكد من ادخال بياناتك بشكل صحيح!'), findsOneWidget);
    expect(find.byType(SnackBar), findsOneWidget);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:wesal_app_final/widgets/registration/loginwidget.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MockFirebaseAuthWrongPassword extends MockFirebaseAuth {
  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    throw FirebaseAuthException(
      code: 'wrong-password',
      message: 'Wrong password provided.',
    );
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Login shows error with wrong password',
      (WidgetTester tester) async {
    final mockAuth = MockFirebaseAuthWrongPassword();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LoginWidget(auth: mockAuth),
        ),
      ),
    );

    // Interact with UI
    await tester.enterText(
        find.byKey(const Key('email-field')), 'test@gmail.com');
    await tester.enterText(
        find.byKey(const Key('password-field')), 'wrongpassword');
    await tester.tap(find.text('دخول'));
    await tester.pumpAndSettle(); // Wait for SnackBar to appear

    // Verify error SnackBar is shown
    expect(find.text('تأكد من ادخال بياناتك بشكل صحيح!'), findsOneWidget);
  });
}

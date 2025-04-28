import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wesal_app_final/firebase_options.dart';
import 'package:wesal_app_final/interfaces/homePage.dart';
import 'package:wesal_app_final/interfaces/signDetectorPage.dart';
import 'package:wesal_app_final/interfaces/welcomePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            //if user looged in homepage
            return const HomePage();
          }
          //if not welcom
          return const welcome();
        },
      ),
    );
  }
}

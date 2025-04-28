import 'package:flutter/material.dart';
import 'package:wesal_app_final/interfaces/loginPage.dart';
import 'package:wesal_app_final/interfaces/signUpPage.dart';

class DialogHelper {
  static void showGuestDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              const Spacer(),
              const Text(
                ' !يبدو انك هنا كزائر فقط',
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          content: const Text(
            'سجل الآن واستمتع بتجربتك الفريدة✨   في صنع تعابير يومية مخصصة لك ',
            textAlign: TextAlign.right,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const login(),
                  ),
                );
              },
              child: const Text('تسجيل الدخول'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const signup(),
                  ),
                );
              },
              child: const Text('إنشاء حساب'),
            ),
          ],
        );
      },
    );
  }
}

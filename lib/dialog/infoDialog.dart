import 'package:flutter/material.dart';

// Stateless widget for displaying information about the app
class infoDialog extends StatelessWidget {
  const infoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'كل ما تحتاج لمعرفته عن التطبيق!', // Title of the dialog
        textDirection: TextDirection.rtl, // Right-to-left text direction
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            buildListTile(
              context,
              'ترجمة لغة الإشارة✋🤟', // Service title
              'تتيح هذه الخدمة لمستخدمي لغة الإشارة النقر على الكاميرا وبدء أداء إيماءاتهم، حيث يقوم التطبيق بترجمة هذه الإيماءات إلى نصوص مكتوبة. تهدف هذه الخاصيه الى تمكين غير مستخدمي لغة الإشارة من فهم ما يعبر عنه مستخدمو لغة الإشارة، مما يسهل التواصل والتفاعل بين الطرفين.', // Description
            ),
            buildListTile(
              context,
              'التعابير اليومية🗂 ', // Service title
              'تتيح هذه الخدمة لمستخدمي لغة الإشارة استخدام تعابير جاهزة يمكن تعديلها، حذفها، أو إضافة تعابير خاصة بهم، مما يجعلها مخصصة لكل مستخدم. عند النقر عليها يتم توليد صوت مسموع، مما يمكّن غير مستخدمي لغة الإشارة من سماع التعبير. تهدف الخدمة إلى تعزيز التواصل الشخصي بفعاليّة وسلاسة بين الطرفين.', // Description
            ),
            buildListTile(
              context,
              'ترجمة صوتية🗣 ', // Service title
              'تتيح هذه الخدمة لغير مستخدمي لغة الإشارة تسجيل صوتهم بالنقر على زر المايك في منتصف الصفحة، حيث يتم تحويل الصوت إلى نص مكتوب. يمكن لمستخدم لغة الإشارة قراءة ما كتبه الشخص الآخر وإبداء رائيه حول مدى فهمه للنص. تهدف الخدمة إلى تعزيز التواصل والتفاعل بين الطرفين، مما يسهل الفهم المتبادل.', // Description
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('إغلاق'),
          ), // Close button
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
        ),
      ],
    );
  }

  // Helper method to create list tiles
  ListTile buildListTile(BuildContext context, String title, String subtitle) {
    return ListTile(
      title: Text(title, textDirection: TextDirection.rtl), // Title of the tile
      subtitle: Text(
        'لمعرفة المزيد ,انقر هنا!', // Subtitle prompt
        textDirection: TextDirection.rtl,
      ),
      onTap: () {
        Navigator.of(context).pop(); // Close the dialog
        serviceDetails(context, title, subtitle); // Show service details
      },
    );
  }
}

// Method to show detailed information about a service
void serviceDetails(BuildContext context, String title, String details) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          title,
          textDirection: TextDirection.rtl,
        ), // Title of detail dialog
        content: Text(
          details,
          textDirection: TextDirection.rtl,
        ), // Content of detail dialog
        actions: [
          TextButton(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('إغلاق'),
            ), // Close button
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
        ],
      );
    },
  );
}

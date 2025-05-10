import 'package:flutter/material.dart';
import 'package:wesal_app_final/dialog/infoDialog.dart';

class barWidget extends StatelessWidget {
  const barWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        //textDirection: TextDirection.rtl,
        children: [
          IconButton(
            icon: Icon(Icons.info_outlined, color: Colors.white, size: 25),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return infoDialog(); // Use the InfoDialog class here
                },
              );
            },
          ),
          Spacer(),
          Image(
            image: AssetImage('assets/logo.png'),
            width: 100,
            height: 100,
            alignment: Alignment.center,
          ),
          Spacer(),
          Spacer(),
        ],
      ),
    );
  }
}

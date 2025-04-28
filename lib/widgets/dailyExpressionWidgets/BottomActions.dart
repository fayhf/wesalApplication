import 'package:flutter/material.dart';

class BottomActions extends StatelessWidget {
  final bool isDeleteMode;
  final Function() onAddButtonPressed;
  final Function() onHomeButtonPressed;

  const BottomActions({
    Key? key,
    required this.isDeleteMode,
    required this.onAddButtonPressed,
    required this.onHomeButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isDeleteMode
        ? Container() // Do not display the footer when in delete mode
        : Center(
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                FloatingActionButton(
                  onPressed: onAddButtonPressed,
                  shape: const CircleBorder(),
                  mini: true,
                  backgroundColor: const Color.fromARGB(255, 243, 164, 85),
                  child: const Icon(
                    Icons.add,
                    size: 30,
                    color: Color.fromARGB(255, 238, 236, 234),
                  ),
                ),
                const SizedBox(width: 100),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: IconButton(
                    icon: const Icon(
                      Icons.home_outlined,
                      color: Color.fromARGB(255, 225, 211, 211),
                      size: 25,
                    ),
                    onPressed: onHomeButtonPressed,
                  ),
                ),
              ],
            ),
          );
  }
}

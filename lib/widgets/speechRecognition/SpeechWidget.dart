import 'package:flutter/material.dart';
import 'package:wesal_app_final/interfaces/homePage.dart';

// Stateless widget for the speech recognition UI
class speechWidget extends StatelessWidget {
  final bool isListening; // Listening state
  final String text; // Recognized text
  final TextEditingController textController; // Text controller
  final VoidCallback onStartListening; // Callback for starting listening
  final VoidCallback onStopListening; // Callback for stopping listening
  final VoidCallback onUnderstood; // Callback for understood action
  final VoidCallback onNotUnderstood; // Callback for not understood action
  final bool understood; // Understood state
  final bool notUnderstood; // Not understood state

  const speechWidget({
    Key? key,
    required this.isListening,
    required this.text,
    required this.textController,
    required this.onStartListening,
    required this.onStopListening,
    required this.onUnderstood,
    required this.onNotUnderstood,
    required this.understood,
    required this.notUnderstood,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 100), // Space above
                GestureDetector(
                  onTap:
                      isListening
                          ? onStopListening
                          : onStartListening, // Start/stop listening on tap
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color:
                          isListening
                              ? Colors.red
                              : Colors
                                  .blue, // Change color based on listening state
                      shape: BoxShape.circle, // Circular shape
                    ),
                    child: Icon(
                      isListening ? Icons.stop : Icons.mic, // Mic or stop icon
                      size: 40,
                      color: Colors.white, // Icon color
                    ),
                  ),
                ),
                SizedBox(height: 40), // Space below the button
                TextField(
                  controller: textController, // Text input controller
                  onChanged: (value) {
                    // Handle text changes if needed
                  },
                  textAlign: TextAlign.right, // Right-aligned text
                  maxLines: null, // Allow multiple lines
                  minLines: 1, // Minimum lines
                  decoration: InputDecoration(
                    hintText: '...قل شيئا', // Hint text
                    border: OutlineInputBorder(), // Input border
                    filled: true, // Fill the background
                    fillColor: Colors.grey[200], // Background color
                    contentPadding: EdgeInsets.all(
                      16,
                    ), // Padding inside the input
                  ),
                ),
                SizedBox(height: 20), // Space below text field
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly, // Space buttons evenly
                  children: [
                    ElevatedButton(
                      onPressed: onUnderstood, // Understood button action
                      child: Text(
                        understood
                            ? '✅ !حسنا فهمت'
                            : '👍 !حسنا فهمت', // Button text
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            understood
                                ? Color.fromARGB(
                                  121,
                                  190,
                                  234,
                                  180,
                                ) // Color if understood
                                : Color.fromARGB(
                                  121,
                                  204,
                                  201,
                                  240,
                                ), // Default color
                      ),
                    ),
                    ElevatedButton(
                      onPressed:
                          onNotUnderstood, // Not understood button action
                      child: Text(
                        notUnderstood ? '❌ !لم افهم' : '😕 !لم افهم',
                      ), // Button text
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            notUnderstood
                                ? Color.fromARGB(
                                  255,
                                  245,
                                  96,
                                  85,
                                ) // Color if not understood
                                : Color.fromARGB(
                                  121,
                                  204,
                                  201,
                                  240,
                                ), // Default color
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 195), // Space below buttons
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5.0), // Padding for the home button
          child: SizedBox(
            width: double.infinity,
            child: IconButton(
              icon: Icon(
                Icons.home_outlined, // Home icon
                color: Color.fromARGB(255, 54, 51, 51),
                size: 25,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ), // Navigate to home page
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class SearchAndDeleteBar extends StatelessWidget {
  final String searchQuery;
  final bool isDeleteMode;
  final Function(String) onSearchChanged;
  final VoidCallback onDeleteToggle;

  const SearchAndDeleteBar({
    Key? key,
    required this.searchQuery,
    required this.isDeleteMode,
    required this.onSearchChanged,
    required this.onDeleteToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        SizedBox(
          width: 250,
          height: 25,
          child: TextField(
            onChanged: (value) => onSearchChanged(value),
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              hintText: '...بحث ',
              hintStyle: const TextStyle(fontSize: 17),
              suffixIcon: const Icon(
                Icons.search,
                color: Color.fromARGB(255, 54, 51, 51),
                size: 20,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
            ),
          ),
        ),
        const Spacer(),
        IconButton(
          icon: Icon(
            isDeleteMode ? Icons.check : Icons.delete_outline,
            color: const Color.fromARGB(255, 54, 51, 51),
            size: 25,
          ),
          onPressed: onDeleteToggle,
        ),
      ],
    );
  }
}

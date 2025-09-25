import 'package:flutter/material.dart';

class SearchInput extends StatelessWidget {
  const SearchInput({super.key, required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextField(
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.all(5),
          hintText: 'Filtrar',
        ),
        onChanged: onChanged,
      ),
    );
  }
}

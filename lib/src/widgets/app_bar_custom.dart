import 'package:flutter/material.dart';

class AppBarCustom extends StatelessWidget {
  const AppBarCustom({
    super.key,
    required this.fetchTasks,
    required this.onSearchChanged,
  });

  final Future<void> Function() fetchTasks;
  final Function(String)
      onSearchChanged; // Callback para manejar el texto de búsqueda

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 30,
      child: TextField(
        onChanged: onSearchChanged, // Cada cambio en el texto llama al callback
        decoration: InputDecoration(
          hintText: 'Buscar tarea...',
          filled: true,
          fillColor: Colors.white,
          prefixIcon: const Icon(Icons.search),
          contentPadding: const EdgeInsets.all(10.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

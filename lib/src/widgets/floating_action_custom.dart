import 'package:flutter/material.dart';
import 'package:flutter_tasks_app/components/add_tasks.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final Function(String, String) onAddTask;
  final Function fetchTasks; // Nueva función para fetch

  const CustomFloatingActionButton({
    super.key,
    required this.onAddTask,
    required this.fetchTasks, // Añade el parámetro aquí
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showAddTaskModal(context, onAddTask, fetchTasks); // Pasa fetchTasks
      },
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.lightBlue, // Color estático del botón
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: const Icon(
          Icons.add,
          size: 35.0,
          color: Colors.white,
        ),
      ),
    );
  }
}

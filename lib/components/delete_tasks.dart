// lib/src/widgets/delete_task_modal.dart
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_tasks_app/main.dart';

// Crea una instancia de Dio
final Dio dio = Dio();

Future<void> deleteTaskFromDatabase(int id) async {
  try {
    final response = await dio.delete(
      '$apiUrl/tareas/$id', // Cambia esto por la URL de tu API
    );

    if (response.statusCode == 200) {
      print('Task deleted successfully');
    } else {
      throw Exception('Failed to delete task');
    }
  } catch (e) {
    print('Error: $e');
  }
}

void showDeleteTaskModal(BuildContext context, Function(int) onDeleteTask, int taskId) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Delete Task',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Are you sure you want to delete this task?',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () async {
                      // Eliminar la tarea de la base de datos
                      await deleteTaskFromDatabase(taskId);

                      // Actualizar la lista de tareas en la interfaz
                      onDeleteTask(taskId); // Llama a la función para actualizar la lista

                   

                      // Muestra un mensaje de éxito
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          content: const Text('Task eliminated successfully.'),
                          duration: const Duration(seconds: 2),
                        ),
                      );

                      // Cierra el diálogo
                      Navigator.of(context).pop();
                    },
                    child: const Text('Delete'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_tasks_app/main.dart'; // Importa el paquete Dio

// Crea una instancia de Dio
final Dio dio = Dio();

// Función para capitalizar la primera letra de un string
String capitalize(String text) {
  if (text.isEmpty) {
    return text; // Retorna vacío si el texto está vacío
  }
  return text[0].toUpperCase() + text.substring(1);
}

Future<void> addTaskToDatabase(String title, String details) async {
  try {
    // Capitaliza el título y detalles
    title = capitalize(title);
    details = capitalize(details);

    final response = await dio.post(
      '$apiUrl/tareas',
      data: {
        'title': title,
        'detalles': details,
      },
    );

    if (response.statusCode == 200) {
      print('Task added successfully');
    } else {
      throw Exception('Failed to add task');
    }
  } catch (e) {
    print('Error: $e');
  }
}

void showAddTaskModal(BuildContext context, Function(String, String) addTask,
    Function fetchTasks) {
  // Añadir fetchTasks
  final TextEditingController titleController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add Tasks',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: titleController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: detailsController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Details',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 5),
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
                      final newTask = {
                        'title': capitalize(titleController.text),
                        'detalles': capitalize(detailsController.text),
                      };
                      await addTaskToDatabase(
                          newTask['title'] ?? "", newTask['detalles'] ?? "");
                      // Agregar tarea a la base de datos
                      await addTask(
                          newTask['title'] ?? "", newTask['detalles'] ?? "");

                      // Llama a fetchTasks para obtener la lista de tareas
                      await fetchTasks();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.blue,
                          content: const Text('Task created successfully.'),
                          duration: const Duration(seconds: 2),
                        ),
                      );

                      Navigator.of(context).pop(); // Cierra el modal
                    },
                    child: const Text('Add'),
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

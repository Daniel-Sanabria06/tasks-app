import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tasks_app/main.dart';

// Crea una instancia de Dio
final Dio dio = Dio();

// Función para actualizar una tarea en la base de datos
Future<void> editTaskInDatabase(
    int id, String newTitle, String newDetails) async {
  try {
    final response = await dio.put(
      '$apiUrl/tareas', // Cambia esto por la URL de tu API
      data: {
        'id': id,
        'title': newTitle,
        'detalles': newDetails,
      },
    );

    if (response.statusCode == 200) {
      print('Task updated successfully');
    } else {
      throw Exception('Failed to update task');
    }
  } catch (e) {
    print('Error: $e');
  }
}

// Función para marcar tarea como completada o desmarcada
Future<void> marcarCompletado(int id, bool completado) async {
  final String url = '$apiUrl/tareas/marcar-completado';

  try {
    final response = await dio.put(
      url,
      data: {
        'id': id,
        'completado': completado,
      },
    );

    if (response.statusCode == 200) {
      // La tarea se ha actualizado correctamente
      print('Tarea actualizada: ${response.data}');
    } else if (response.statusCode == 404) {
      // Tarea no encontrada
      print('Error: Tarea no encontrada');
    } else {
      // Manejo de otros errores
      print('Error: ${response.data}');
    }
  } catch (e) {
    // Manejo de excepciones
    print('Error de conexión: $e');
  }
}

// Función para mostrar el modal de confirmación
// Función para mostrar el modal de confirmación
Future<void> showConfirmarCompletadoModal(
    BuildContext context, dynamic task) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirm'),
        content: const Text('Are you sure you want to change the task status?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cierra el diálogo
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              bool completado = task['completado'] == 1
                  ? false
                  : true; // Asigna el valor de completado

              // Verifica que el contexto esté montado
              if (!context.mounted) return;

              // Llama a la función para marcar la tarea como completada
              await marcarCompletado(task['id'], completado);

              // Verifica que el contexto aún esté montado
              Navigator.of(context).pop(); // Cierra el diálogo
              Navigator.of(context).pop(); // Cierra el diálogo
              if (context.mounted) {
                // Muestra el SnackBar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.green,
                    content: const Text('Task Updated.'),
                  ),
                );
              }
            },
            child: const Text('Confirm'),
          ),
        ],
      );
    },
  );
}

// Modifica la función para que retorne un Future
Future<void> showEditTaskModal(
  BuildContext context,
  Function(int, String, String) onEdit,
  dynamic task,
) {
  final TextEditingController titleController =
      TextEditingController(text: task['title'] ?? '');
  final TextEditingController detailsController =
      TextEditingController(text: task['detalles'] ?? '');

  return showDialog<void>(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 10,
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Edit Task',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9 ]')),
                    LengthLimitingTextInputFormatter(100),
                    UpperCaseTextFormatter(),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: detailsController,
                  decoration: const InputDecoration(
                    labelText: 'Details',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9 ]')),
                    LengthLimitingTextInputFormatter(500),
                    UpperCaseTextFormatter(),
                  ],
                ),
                const SizedBox(height: 10),
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
                        String newTitle = titleController.text;
                        String newDetails = detailsController.text;

                        // Asegúrate de que el ID no sea null y sea un entero
                        if (task['id'] != null && task['id'] is int) {
                          int taskId = task['id'];

                          // Llamar a la función para actualizar en la base de datos
                          await editTaskInDatabase(
                              taskId, newTitle, newDetails);

                          if (!context.mounted)
                            return; // Asegúrate de que el contexto esté montado antes de proceder

                          // Llamar al callback para manejar la edición
                          await onEdit(taskId, newTitle, newDetails);

                          // Mostrar el snackbar de éxito
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.green,
                              content: const Text('Task successfully updated.'),
                              duration: const Duration(seconds: 2),
                            ),
                          );

                          // Cerrar el diálogo solo si el widget está montado
                          if (context.mounted) {
                            Navigator.of(context).pop();
                          }
                        } else {
                          // Manejo de error si el ID es nulo
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  const Text('Error: ID de tarea no válido.'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

// Formateador de texto para poner la primera letra en mayúscula
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;
    // Convertir la primera letra a mayúscula y el resto a minúsculas
    String formatted = newValue.text[0].toUpperCase() +
        newValue.text.substring(1).toLowerCase();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

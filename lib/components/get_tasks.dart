import 'package:dio/dio.dart';
import 'package:flutter_tasks_app/main.dart';

class TaskService {
  Dio dio = Dio();

  Future<List<dynamic>> getTasks() async {
    try {
      final response = await dio.get('$apiUrl/tareas');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Error al obtener las tareas');
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> getTasksCompleted() async {
    try {
      final response = await dio.get('$apiUrl/tareas/completadas');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Error al obtener las tareas');
      }
    } catch (e) {
      return [];
    }
  }

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
    } else if (response.statusCode == 404) {
      // Tarea no encontrada
    } else {
      // Manejo de otros errores
    }
  } catch (e) {
    // Manejo de excepciones
  }
}

}



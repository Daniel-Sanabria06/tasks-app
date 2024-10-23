import 'package:flutter/material.dart';
import 'package:flutter_tasks_app/components/edit_task.dart';
import 'package:flutter_tasks_app/components/get_tasks.dart';
import 'package:flutter_tasks_app/src/widgets/app_bar_custom.dart';
import 'package:flutter_tasks_app/src/widgets/bottom_bar_custom.dart';
import 'package:flutter_tasks_app/src/widgets/card_tasks.dart';
import 'package:flutter_tasks_app/src/widgets/card_tasks_completed.dart';
import 'package:flutter_tasks_app/src/widgets/floating_action_custom.dart';
import 'package:flutter_tasks_app/src/widgets/header.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> tasks = [];
  List<dynamic> tasksCompleted = [];
  int selectedIndex = 0;
  late PageController controller;
  List<dynamic> filteredTasks = [];
  List<dynamic> allTasks = [];

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: selectedIndex);
    _fetchTasks();
    _fetchTasksCompleted();
  }

  Future<void> _fetchTasks() async {
    TaskService taskService = TaskService();
    final fetchedTasks = await taskService.getTasks();
    setState(() {
      tasks = fetchedTasks;
    });
  }

  Future<void> _fetchTasksCompleted() async {
    TaskService taskService = TaskService();
    final fetchedTasksCompleted = await taskService.getTasksCompleted();
    setState(() {
      tasksCompleted = fetchedTasksCompleted;
    });
  }

  // Función para marcar una tarea como completada
  void _markTaskAsCompleted(int taskId, bool completado) async {
    TaskService taskService = TaskService();
    await taskService.marcarCompletado(taskId, completado);

    // Después de marcar como completada, actualiza ambas listas
    await _fetchTasks(); // Actualiza tareas pendientes
    await _fetchTasksCompleted(); // Actualiza tareas completadas
  }

  void _onItemSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
    controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutQuad,
    );
  }

  void _addTask(String title, String details) {
    setState(() {
      tasks.add(
          {'title': title, 'detalles': details}); // Agregar la tarea a la lista
    });
  }

  void _showConfirmarCompletadoModal(BuildContext context, dynamic task) {
    showConfirmarCompletadoModal(
      context,
      task,
    );
  }

 void _filterTasks(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredTasks = allTasks; // Si la búsqueda está vacía, muestra todas las tareas
      } else {
        filteredTasks = allTasks
            .where((task) =>
                task['title'].toLowerCase().contains(query.toLowerCase()) ||
                task['detalles'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

 @override
Widget build(BuildContext context) {
  final size = MediaQuery.of(context).size;
  return Scaffold(
    body: Stack(
      children: [
        Positioned(
          top: -20,
          left: 0,
          right: 0,
          child: HeaderWaveGradient(),
        ),
        PageView(
          controller: controller,
          onPageChanged: (index) {
            setState(() {
              selectedIndex = index;
              if (index == 1) {
                _fetchTasksCompleted();
              } else {
                _fetchTasks();
              }
            });
          },
          children: [
            // Primer Page (Tareas)
            Column(
              children: [
                SizedBox(height: size.height * 0.1),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'My Tasks',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.07),
                CardTasks(
                  tasks: tasks,
                  fetchTasks: _fetchTasksCompleted,
                ),
              ],
            ),
            // Segundo Page (Tareas Completadas)
            Column(
              children: [
                SizedBox(height: size.height * 0.1),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Completed',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.07),
                CardTaskCompleted(
                  tasksCompleted: tasksCompleted,
                  fetchTasks: _fetchTasksCompleted, // Actualiza la función aquí
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    floatingActionButton: CustomFloatingActionButton(
      onAddTask: _addTask,
      fetchTasks: _fetchTasks,
    ), 
    bottomNavigationBar: CustomBottomNavigationBar(
      selectedIndex: selectedIndex,
      controller: controller,
      onItemSelected: _onItemSelected, // Pasa la función de selección
    ),
  );
}
}
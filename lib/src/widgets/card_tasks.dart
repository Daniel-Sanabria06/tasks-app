import 'package:flutter/material.dart';
import 'package:flutter_tasks_app/components/delete_tasks.dart';
import 'package:flutter_tasks_app/components/edit_task.dart';
import 'package:flutter_tasks_app/components/get_tasks.dart';

class CardTasks extends StatefulWidget {
  const CardTasks({
    super.key,
    required this.tasks,
    required this.fetchTasks,
  });

  final List tasks;
  final Future<void> Function() fetchTasks;

  @override
  State<CardTasks> createState() => _CardTasksState();
}

class _CardTasksState extends State<CardTasks> {
  bool isLoading = true; // Estado de carga inicial
  List<dynamic> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() {
      isLoading = true; // Inicia la carga
    });

    // Aquí llamas a tu método fetchTasks
    await widget.fetchTasks();

    setState(() {
      isLoading = false; // Finaliza la carga
    });
  }

  Future<void> _fetchTasks() async {
    TaskService taskService = TaskService();
    final fetchedTasks = await taskService.getTasks();
    setState(() {
      tasks = fetchedTasks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: isLoading // Verifica si se está cargando
          ? Center(
              // Muestra el CircularProgressIndicator
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: widget.tasks.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _showTaskDetailsModal(context, widget.tasks[index]);
                  },
                  child: Card(
                    elevation: 8,
                    shadowColor: Colors.black.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListTile(
                        title: Text(
                          widget.tasks[index]['title'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.tasks[index]['detalles'],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 15),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Text(
                                  'More',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showTaskDetailsModal(BuildContext context, dynamic task) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      task['title'],
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      task['detalles'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () {
                            showDeleteTaskModal(context, (int taskId) async {
                              // Después de eliminar la tarea, actualiza la lista
                              await widget
                                  .fetchTasks(); // Actualiza la lista de tareas
                              Navigator.of(context).pop(); // Cierra el modal
                            }, task['id']);

                            setState(() {
                              widget.tasks
                                  .removeWhere((t) => t['id'] == task['id']);
                            });
                          },
                          icon: const Icon(
                            Icons.delete_rounded,
                            color: Colors.red,
                            size: 30,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            await showEditTaskModal(
                              context,
                              (int taskId, String newTitle, String newDetails) {
                                // Encuentra la tarea en la lista y actualiza sus detalles localmente
                                final taskIndex = widget.tasks
                                    .indexWhere((task) => task['id'] == taskId);

                                if (taskIndex != -1) {
                                  setState(() {
                                    widget.tasks[taskIndex]['title'] = newTitle;
                                    widget.tasks[taskIndex]['detalles'] =
                                        newDetails;
                                  });
                                }
                              },
                              task,
                            );

                            // Cierra el modal después de la edición
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.blue,
                            size: 30,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            // Llama al modal para confirmar si se quiere marcar como completado
                            await showConfirmarCompletadoModal(context, task);

                            // Después de que la tarea ha sido marcada como completada, la eliminamos de la lista local
                            setState(() {
                              widget.tasks
                                  .removeWhere((t) => t['id'] == task['id']);
                            });
                          },
                          icon: const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 30,
                          ),
                        ),
                      ],
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
}

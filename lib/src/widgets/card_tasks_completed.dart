import 'package:flutter/material.dart';
import 'package:flutter_tasks_app/components/delete_tasks.dart';
import 'package:flutter_tasks_app/components/edit_task.dart';

class CardTaskCompleted extends StatefulWidget {
  const CardTaskCompleted({
    super.key,
    required this.tasksCompleted,
    required this.fetchTasks,
  });

  final List tasksCompleted;
  final Future<void> Function() fetchTasks;

  @override
  State<CardTaskCompleted> createState() => _CardTasksState();
}

class _CardTasksState extends State<CardTaskCompleted> {
  bool _isLoading = false; // Estado de carga

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: widget.tasksCompleted.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _showTaskDetailsModal(
                        context, widget.tasksCompleted[index]);
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
                        leading: const Icon(Icons.check_circle, color: Colors.green,),
                        title: Text(
                          widget.tasksCompleted[index]['title'],
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
                                widget.tasksCompleted[index]['detalles'],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 15),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Text(
                                  'Ver más',
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
                              (int task, String newTitle, String newDetails) {
                                // Después de editar, actualiza la lista de tareas
                                widget
                                    .fetchTasks(); // Actualiza la lista de tareas
                              },
                              task,
                            );

                            Navigator.of(context)
                                .pop(); // Cierra el modal después de editar
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.blue,
                            size: 30,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            if (!context.mounted) return;
                            await showConfirmarCompletadoModal(context, task);
                            setState(() {
                              widget.tasksCompleted
                                  .removeWhere((t) => t['id'] == task['id']);
                            });
                          },
                          icon: const Icon(
                            Icons.check_circle,
                            color: Colors.grey,
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

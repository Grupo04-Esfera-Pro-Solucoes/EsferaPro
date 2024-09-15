import 'package:flutter/material.dart';

enum TaskStatus { todo, inProgress, done }

class Task {
  String title;
  String description;
  String time;
  TaskStatus status;

  Task({
    required this.title,
    required this.description,
    required this.time,
    required this.status,
  });
}

class TasksPage extends StatefulWidget {
  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  TaskStatus selectedStatus = TaskStatus.todo;

  final List<Task> tasks = [
    Task(title: "Tarefa 1", description: "Descrição da tarefa 1", time: "08/09/2024", status: TaskStatus.todo),
    Task(title: "Tarefa 2", description: "Descrição da tarefa 2", time: "09/09/2024", status: TaskStatus.inProgress),
    Task(title: "Tarefa 3", description: "Descrição da tarefa 3", time: "10/09/2024", status: TaskStatus.done),
    Task(title: "Tarefa 4", description: "Descrição da tarefa 4", time: "11/09/2024", status: TaskStatus.todo),
    Task(title: "Tarefa 5", description: "Descrição da tarefa 5", time: "12/09/2024", status: TaskStatus.inProgress),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            color: const Color(0xFF6502D4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildOption("A Fazer", TaskStatus.todo),
                _buildOption("Progresso", TaskStatus.inProgress),
                _buildOption("Concluído", TaskStatus.done),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: _filteredTasks.length,
              separatorBuilder: (context, index) => Divider(color: Colors.grey[300], height: 1),
              itemBuilder: (context, index) {
                final task = _filteredTasks[index];
                return Dismissible(
                  key: Key('${task.title}_${index}'), // Chave única e estável
                  background: Container(color: Colors.transparent),
                  secondaryBackground: Container(color: Colors.transparent),
                  onDismissed: (direction) {
                    setState(() {
                      if (direction == DismissDirection.endToStart) {
                        task.status = _getNextStatus(task.status);
                      } else if (direction == DismissDirection.startToEnd) {
                        task.status = _getPreviousStatus(task.status);
                      }
                    });
                  },
                  child: _buildTaskCard(task),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        height: 70,
        width: 70,
        child: FloatingActionButton(
          onPressed: () => _showAddTaskDialog(context),
          backgroundColor: const Color(0xFF6502D4),
          child: const Icon(Icons.add, size: 35, color: Colors.white),
        ),
      ),
    );
  }

  List<Task> get _filteredTasks {
    return tasks.where((task) => task.status == selectedStatus).toList();
  }

  Widget _buildOption(String title, TaskStatus status) {
    bool isSelected = selectedStatus == status;
    return TextButton(
      onPressed: () {
        setState(() {
          selectedStatus = status;
        });
      },
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white70,
          fontSize: 16,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  TaskStatus _getNextStatus(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo:
        return TaskStatus.inProgress;
      case TaskStatus.inProgress:
        return TaskStatus.done;
      case TaskStatus.done:
        return TaskStatus.done;
    }
  }

  TaskStatus _getPreviousStatus(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo:
        return TaskStatus.todo;
      case TaskStatus.inProgress:
        return TaskStatus.todo;
      case TaskStatus.done:
        return TaskStatus.inProgress;
    }
  }

  Widget _buildTaskCard(Task task) {
    IconData statusIcon;
    switch (task.status) {
      case TaskStatus.todo:
        statusIcon = Icons.check_box_outline_blank;
        break;
      case TaskStatus.inProgress:
        statusIcon = Icons.sync;
        break;
      case TaskStatus.done:
        statusIcon = Icons.check_circle;
        break;
    }

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  task.description.isNotEmpty ? task.description : 'Escreva uma descrição',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  task.time,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Icon(
            statusIcon,
            color: const Color(0xFF6502D4),
            size: 30,
          ),
        ],
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    final _titleController = TextEditingController();
    final _timeController = TextEditingController();
    final _descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Center(
            child: Text(
              "Adicionar Tarefa",
              style: TextStyle(
                color: Color(0xFF6502D4),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Vencimento:",
                            style: TextStyle(color: Color(0xFF6502D4), fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          TextField(
                            controller: _timeController,
                            decoration: InputDecoration(
                              hintText: "dd/mm/aaaa",
                              hintStyle: TextStyle(fontSize: 14, color: Colors.grey[600]),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFF6502D4)),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFF6502D4)),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFF6502D4)),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            ),
                            keyboardType: TextInputType.datetime,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Tarefa:",
                          style: TextStyle(color: Color(0xFF6502D4), fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        TextField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            hintText: "Título",
                            hintStyle: TextStyle(fontSize: 14, color: Colors.grey[600]),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF6502D4)),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF6502D4)),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF6502D4)),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                "Descrição:",
                style: TextStyle(color: Color(0xFF6502D4), fontSize: 14),
              ),
              const SizedBox(height: 4),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText: "Escreva uma descrição",
                  hintStyle: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF6502D4)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF6502D4)),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF6502D4)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancelar", style: TextStyle(color: Color(0xFF6502D4))),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      String title = _titleController.text;
                      String time = _timeController.text;
                      String description = _descriptionController.text;

                      setState(() {
                        tasks.add(Task(
                          title: title,
                          description: description,
                          time: time,
                          status: TaskStatus.todo,
                        ));
                      });

                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6502D4),
                    ),
                    child: const Text("Salvar", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );

  }
}

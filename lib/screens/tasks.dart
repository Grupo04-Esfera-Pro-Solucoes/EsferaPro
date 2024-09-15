import 'package:flutter/material.dart';
import '../service/task_service.dart';
import '../model/task_model.dart';
import '../widgets/task_dialog.dart';

enum TaskStatus { todo, inProgress, done }

class TasksPage extends StatefulWidget {
  final int userId;

  TasksPage({required this.userId});

  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final TaskService _taskService = TaskService();
  TaskStatus selectedStatus = TaskStatus.todo;
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    try {
      List<Task> fetchedTasks = await _taskService.fetchTasks(widget.userId);
      setState(() {
        tasks = fetchedTasks;
      });
    } catch (e) {
      print('Erro ao buscar tarefas: $e');
    }
  }

  Future<void> _createTask(Task task) async {
    try {
      Task createdTask = await _taskService.createTask(task);
      setState(() {
        tasks.add(createdTask);
      });
      _showCustomDialog(title: 'Sucesso!', content: 'Tarefa criada com sucesso.', isSuccess: true);
    } catch (e) {
      _showCustomDialog(title: 'Erro!', content: e.toString(), isSuccess: false);
    }
  }

  Future<void> _updateTask(Task task) async {
    try {
      await _taskService.updateTask(task);
      _fetchTasks();
      _showCustomDialog(title: 'Sucesso!', content: 'Tarefa atualizada com sucesso.', isSuccess: true);
    } catch (e) {
      print('Erro ao atualizar tarefa: $e');
      _showCustomDialog(title: 'Erro!', content: e.toString(), isSuccess: false);
    }
  }


  Future<void> _deleteTask(String id) async {
    try {
      await _taskService.deleteTask(id);
      _fetchTasks();
      _showCustomDialog(title: 'Sucesso!', content: 'Tarefa excluída com sucesso.', isSuccess: true);
    } catch (e) {
      _showCustomDialog(title: 'Erro!', content: e.toString(), isSuccess: false);
    }
  }

  void _showCustomDialog({required String title, required String content, required bool isSuccess}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: const EdgeInsets.all(16.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF6502D4),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                content,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              CustomElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                text: 'OK',
                backgroundColor: Colors.white,
              ),
            ],
          ),
        );
      },
    );
  }

  List<Task> get _filteredTasks {
    return tasks.where((task) {
      final taskStatus = TaskStatus.values.firstWhere(
        (status) => status.toString().split('.').last == task.status,
        orElse: () => TaskStatus.todo,
      );

      return taskStatus == selectedStatus;
    }).toList();
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
    case 'todo':
      statusIcon = Icons.check_box_outline_blank;
      break;
    case 'inProgress':
      statusIcon = Icons.sync;
      break;
    case 'done':
      statusIcon = Icons.check_circle;
      break;
    default:
      statusIcon = Icons.help;
  }

  Widget buildDismissBackground(Alignment alignment, IconData icon) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: alignment,
      child: Icon(
        icon,
        color: const Color(0xFF6502D4),
        size: 30,
      ),
    );
  }

  return Dismissible(
    key: Key(task.id.toString()),
    background: buildDismissBackground(Alignment.centerLeft, Icons.arrow_back_ios),
    secondaryBackground: buildDismissBackground(Alignment.centerRight, Icons.arrow_forward_ios),
    direction: DismissDirection.horizontal,
    onDismissed: (direction) async {
      // Atualiza o status da tarefa
      setState(() {
        if (direction == DismissDirection.startToEnd) {
          task.status = _getPreviousStatus(
            TaskStatus.values.firstWhere(
              (e) => e.toString().split('.').last == task.status,
            ),
          ).toString().split('.').last;
        } else if (direction == DismissDirection.endToStart) {
          task.status = _getNextStatus(
            TaskStatus.values.firstWhere(
              (e) => e.toString().split('.').last == task.status,
            ),
          ).toString().split('.').last;
        }
      });

      try {
        // Atualiza a tarefa na API
        await _updateTask(task);

        // Remove o item da lista local após a atualização bem-sucedida
        setState(() {
          tasks.removeWhere((t) => t.id == task.id);
        });
      } catch (e) {
        print('Erro ao atualizar tarefa após arrastar: $e');
        // Re-adiciona a tarefa à lista em caso de erro
        setState(() {
          tasks.add(task);
        });
      }
    },
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey, width: 1),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.name,
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
                  task.getFormattedDueDate(),
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
    ),
  );
}

  void _showAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddTaskDialog(
          onTaskCreated: (Task task) {
            _createTask(task);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            color: const Color(0xFF6502D4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildOption('A Fazer', TaskStatus.todo),
                _buildOption('Em Progresso', TaskStatus.inProgress),
                _buildOption('Concluídas', TaskStatus.done),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredTasks.length,
              itemBuilder: (context, index) {
                final task = _filteredTasks[index];
                return _buildTaskCard(task);
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
}

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color backgroundColor;

  const CustomElevatedButton({
    required this.onPressed,
    required this.text,
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
    );
  }
}
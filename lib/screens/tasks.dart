import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../service/task_service.dart';
import '../model/task_model.dart';
import '../widgets/task_dialog.dart';

enum TaskStatus { todo, inProgress, done }

class TasksPage extends StatefulWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final TaskService _taskService = TaskService();
  TaskStatus selectedStatus = TaskStatus.todo;
  List<Task> tasks = [];
  late int userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('userId')!;
      _fetchTasks();
    });
  }

  Future<void> _fetchTasks() async {
    List<Task> fetchedTasks = await _taskService.fetchTasks(userId);
    setState(() {
      tasks = fetchedTasks;
    });
  }

  Future<void> _createTask(Task task) async {
    Task taskWithUserId = Task(
      id: task.id,
      name: task.name,
      description: task.description,
      dueDate: task.dueDate,
      status: task.status,
      userId: userId,
    );
    Task createdTask = await _taskService.createTask(taskWithUserId);
    setState(() {
      tasks.add(createdTask);
    });
  }

  Future<void> _updateTaskStatus(int id, String status) async {
    Task updatedTask = await _taskService.updateTaskStatus(id, status);
    setState(() {
      tasks = tasks.map((t) => t.id == id ? updatedTask : t).toList();
    });
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
      key: ValueKey(task.id),
      background: buildDismissBackground(Alignment.centerLeft, Icons.arrow_back_ios),
      secondaryBackground: buildDismissBackground(Alignment.centerRight, Icons.arrow_forward_ios),
      direction: DismissDirection.horizontal,
      onDismissed: (direction) async {

        final currentStatus = TaskStatus.values.firstWhere(
          (e) => e.toString().split('.').last == task.status,
          orElse: () => TaskStatus.todo,
        );
        final newStatus = direction == DismissDirection.startToEnd
            ? _getNextStatus(currentStatus)
            : _getPreviousStatus(currentStatus);

        try {
          await _updateTaskStatus(task.id, newStatus.toString().split('.').last);
          setState(() {
            tasks.remove(task);
          });
        } catch (e) {
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
          userId: userId,
        );
      },
    );
  }

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
              itemBuilder: (BuildContext context, int index) {
                return _buildTaskCard(_filteredTasks[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context),
        backgroundColor: const Color(0xFF6502D4),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
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
    required this.backgroundColor,
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
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );
  }
}
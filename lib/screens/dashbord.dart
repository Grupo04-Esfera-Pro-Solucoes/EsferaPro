import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/task_model.dart';
import '../service/task_service.dart';

enum TaskStatus { todo, inProgress, done }

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final TaskService _taskService = TaskService();
  List<Task> tasks = [];
  TaskStatus selectedStatus = TaskStatus.todo;
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

  List<Task> get _filteredTasks {
    return tasks.where((task) {
      final taskStatus = TaskStatus.values.firstWhere(
        (status) => status.toString().split('.').last == task.status,
        orElse: () => TaskStatus.todo,
      );
      return taskStatus == selectedStatus;
    }).toList();
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

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
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
                  task.description.isNotEmpty ? task.description : 'Sem descrição',
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
    );
  }

  Widget _buildCategoryButton(String title, TaskStatus status) {
    return TextButton(
      onPressed: () {
        setState(() {
          selectedStatus = status;
        });
      },
      child: Text(
        title,
        style: TextStyle(
          color: selectedStatus == status ? Colors.white : Colors.white70,
          fontSize: 16,
          fontWeight: selectedStatus == status ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAECF0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 150,
                    margin: const EdgeInsets.only(right: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 150,
                    margin: const EdgeInsets.only(left: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            // Caixa 3
            Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 16.0),
            // Caixa 4 com borda
            Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 16.0),

            Container(
              width: double.infinity,
              height: 300, 
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: const BoxDecoration(
                      color: Color(0xFF6502D4),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildCategoryButton('A Fazer', TaskStatus.todo),
                        _buildCategoryButton('Em Progresso', TaskStatus.inProgress),
                        _buildCategoryButton('Concluídas', TaskStatus.done),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      itemCount: _filteredTasks.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: _buildTaskCard(_filteredTasks[index]),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
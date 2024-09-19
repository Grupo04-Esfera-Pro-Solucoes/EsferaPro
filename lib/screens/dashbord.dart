import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/task_model.dart';
import '../service/task_service.dart';
import 'package:fl_chart/fl_chart.dart';

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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Ligações',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF6502D4),
                            ),
                          ),
                          Text(
                            '150',
                            style: TextStyle(
                              fontSize: 60, 
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.arrow_upward,
                                color: Colors.green,
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              Text(
                                '10% Mês anterior',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Propostas',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF6502D4),
                            ),
                          ),
                          Text(
                            '200',
                            style: TextStyle(
                              fontSize: 60,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.arrow_downward,
                                color: Colors.red,
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              Text(
                                '5% Mês anterior',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Faturamento Mensal',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6502D4),
                      ),
                    ),
                    Text(
                      'R\$ 1.000,00',
                      style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.arrow_upward,
                          color: Colors.green,
                          size: 16,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '15% Mês anterior',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Propostas',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6502D4),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Stack(
                                children: [
                                  PieChart(
                                    PieChartData(
                                      sections: [
                                        PieChartSectionData(
                                          value: 50,
                                          color: Color(0xFF6A1B9A),
                                          radius: 15,
                                          title: '',
                                          titleStyle: const TextStyle(
                                            fontSize: 0,
                                          ),
                                        ),
                                        PieChartSectionData(
                                          value: 30,
                                          color: Color(0xFFAB47BC),
                                          radius: 15,
                                          title: '',
                                          titleStyle: const TextStyle(
                                            fontSize: 0,
                                          ),
                                        ),
                                        PieChartSectionData(
                                          value: 20,
                                          color: Color(0xFFCE93D8),
                                          radius: 15,
                                          title: '',
                                          titleStyle: const TextStyle(
                                            fontSize: 0,
                                          ),
                                        ),
                                      ],
                                      borderData: FlBorderData(show: false),
                                      sectionsSpace: 0,
                                      centerSpaceRadius: 40,
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      '30',
                                      style: const TextStyle(
                                        fontSize: 35,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF6502D4),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: const [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      color: Color(0xFF6A1B9A),
                                      size: 16,
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        '50% Fechado',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xFF6A1B9A),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      color: Color(0xFFAB47BC),
                                      size: 16,
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        '30% Em Negociado',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xFFAB47BC),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      color: Color(0xFFCE93D8),
                                      size: 16,
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        '20% Perdido',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xFFCE93D8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
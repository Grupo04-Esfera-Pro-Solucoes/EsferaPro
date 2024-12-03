import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../model/task_model.dart';
import '../service/task_service.dart';
import 'package:fl_chart/fl_chart.dart';
import '../service/dashbord_service.dart';

enum TaskStatus { todo, inProgress, done }

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final DashboardService _dashboardService = DashboardService();
  final TaskService _taskService = TaskService();
  TaskStatus selectedStatus = TaskStatus.todo;
  List<Task> tasks = [];
  late int userId;
  bool showType1 = true;
  Map<String, dynamic> leadWeekData = {};
  Map<String, dynamic> leadMonthData = {};
  Map<String, dynamic> proposalMonthData = {};
  bool isLoading = true;
  double totalFaturamento = 0.0;
  Map<String, double> proposalData = {
    'Fechado': 0.0,
    'Parado': 0.0,
    'Acompanhar': 0.0,
    'Negociação': 0.0,
  };

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('userId')!;
      _fetchDashboardData();
      _fetchProposalsData();
      _fetchFaturamentoData();
      _fetchTasks();
    });
  }

  Future<void> _fetchDashboardData() async {
    setState(() {
      isLoading = true;
    });
    final leadWeekDataResult =
        await _dashboardService.getLeadsByDayOfTheWeek(userId.toString());
    final leadMonthDataResult =
        await _dashboardService.getLeadsByDayOfTheMonth(userId.toString());
    setState(() {
      leadWeekData = leadWeekDataResult;
      leadMonthData = leadMonthDataResult;
      isLoading = false;
    });
  }

  Future<void> _fetchProposalsData() async {
    setState(() {
      isLoading = true;
    });
    final proposalMonthDataResult =
        await _dashboardService.getProposalsByDayOfTheMonth(userId.toString());
    final proposalDataResult = await _dashboardService.getProposalsByStatus(
        userId.toString(), 'month');
    setState(() {
      proposalData = {
        'Fechado': (proposalDataResult['Fechado'] ?? 0).toDouble(),
        'Parado': (proposalDataResult['Parado'] ?? 0).toDouble(),
        'Acompanhar': (proposalDataResult['Acompanhar'] ?? 0).toDouble(),
        'Negociação': (proposalDataResult['Negociação'] ?? 0).toDouble(),
      };
      proposalMonthData = proposalMonthDataResult;
      isLoading = false;
    });
  }

  Future<void> _fetchFaturamentoData() async {
    setState(() {
      isLoading = true;
    });
    final faturamentoDataResult =
        await _dashboardService.getFaturamento(userId.toString());
    setState(() {
      totalFaturamento = faturamentoDataResult['totalFaturamento'] ?? 0.0;
      isLoading = false;
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

  int getTotalCalls(bool isWeekly) {
    final data = isWeekly ? leadWeekData : leadMonthData;
    return data['leadCount']?.reduce((a, b) => a + b) ?? 0;
  }

  int getTotalProposals() {
    return proposalMonthData['proposalCount']?.reduce((a, b) => a + b) ?? 0;
  }

  double getPercentage(String status) {
    double total = proposalData.values.fold(0, (sum, element) => sum + element);
    double statusValue = proposalData[status] ?? 0.0;
    return total == 0 ? 0 : (statusValue / total) * 100;
  }

  String getPercentageText(String status) {
    double percentage = getPercentage(status);
    return '${percentage.toStringAsFixed(0)}% $status';
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
                    margin: const EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FittedBox(
                                fit: BoxFit
                                    .scaleDown, // Ajusta o texto para caber no espaço disponível
                                child: Text(
                                  showType1
                                      ? 'Ligações da Semana'
                                      : 'Ligações do Mês',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF6502D4),
                                  ),
                                ),
                              ),
                              isLoading
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        color: Color(0xFF6502D4),
                                      ),
                                    )
                                  : Center(
                                      child: Text(
                                        '${getTotalCalls(showType1)}',
                                        style: TextStyle(
                                          fontSize: 60,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  showType1 = !showType1;
                                });
                              },
                              child: Icon(
                                showType1
                                    ? Icons.bar_chart_outlined
                                    : Icons.calendar_today,
                                color: Color(0xFF6502D4),
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Propostas do Mês',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF6502D4),
                                ),
                              ),
                              isLoading
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        color: Color(0xFF6502D4),
                                      ),
                                    )
                                  : Center(
                                      child: Text(
                                        '${getTotalProposals()}',
                                        style: TextStyle(
                                          fontSize: 60,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
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
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Faturamento Mensal',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6502D4),
                      ),
                    ),
                    isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF6502D4),
                            ),
                          )
                        : Align(
                            alignment:
                                Alignment.center, // Alinha o texto no centro
                            child: FittedBox(
                              fit: BoxFit
                                  .scaleDown, // Ajusta o texto para caber no espaço disponível
                              child: Text(
                                'R\$ ${totalFaturamento.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 55,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          )
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
                                          value: getPercentage('Fechado'),
                                          color: Color(0xFF6A1B9A),
                                          radius: 15,
                                          title: '',
                                          titleStyle: const TextStyle(
                                            fontSize: 0,
                                          ),
                                        ),
                                        PieChartSectionData(
                                          value: getPercentage('Parado'),
                                          color: Color(0xFFAB47BC),
                                          radius: 15,
                                          title: '',
                                          titleStyle: const TextStyle(
                                            fontSize: 0,
                                          ),
                                        ),
                                        PieChartSectionData(
                                          value: getPercentage('Acompanhar'),
                                          color: Color(0xFFCE93D8),
                                          radius: 15,
                                          title: '',
                                          titleStyle: const TextStyle(
                                            fontSize: 0,
                                          ),
                                        ),
                                        PieChartSectionData(
                                          value: getPercentage('Negociação'),
                                          color: Color(0xFF7B1FA2),
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
                                      '${getTotalProposals()}',
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
                              children: [
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
                                        getPercentageText('Fechado'),
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
                                        getPercentageText('Parado'),
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
                                      child: FittedBox(
                                        fit: BoxFit
                                            .scaleDown, // Ajusta o texto para caber no espaço disponível
                                        child: Text(
                                          getPercentageText('Acompanhar'),
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xFFCE93D8),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      color: Color(0xFF7B1FA2),
                                      size: 16,
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        getPercentageText('Negociação'),
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xFF7B1FA2),
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
                        _buildCategoryButton(
                            'Em Progresso', TaskStatus.inProgress),
                        _buildCategoryButton('Concluídas', TaskStatus.done),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 16),
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
                  task.description.isNotEmpty
                      ? task.description
                      : 'Sem descrição',
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
          fontWeight:
              selectedStatus == status ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/task_model.dart';
import 'package:logging/logging.dart';

class TaskService {
  final String baseUrl = 'http://localhost:8080/task';
  final Logger logger = Logger('TaskService');

  Future<List<Task>> fetchTasks(int userId) async {
    final url = Uri.parse('$baseUrl/all/$userId');
    logger.info('Fetching tasks for userId: $userId from $url');
    
    final response = await http.get(url);
    logger.info('Response status: ${response.statusCode}');

    if (response.statusCode == 200) {
      final List<dynamic> body = json.decode(response.body);
      logger.info('Fetched ${body.length} tasks.');
      return body.map((dynamic item) {
        final taskJson = item as Map<String, dynamic>;
        return Task.fromJson(taskJson);
      }).toList();
    } else {
      logger.severe('Failed to load tasks. Status code: ${response.statusCode}');
      throw Exception('Failed to load tasks. Status code: ${response.statusCode}');
    }
  }

  Future<Task> createTask(Task task) async {
  final response = await http.post(
    Uri.parse('$baseUrl'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'idTask': task.id,
      'name': task.name,
      'description': task.description,
      'dueDate': task.dueDate.toIso8601String(),
      'status': task.status,
      'user': {
        'idUser':task.userId
      },
    }),
  );

  print('Status Code: ${response.statusCode}');

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);

    print('Dados decodificados: $data');

    return Task(
      id: data['idTask'],
      name: data['name'],
      description: data['description'],
      dueDate: DateTime.parse(data['dueDate']),
      status: data['status'],
      userId: task.userId, 
    );
  } else {
    throw Exception('Failed to create task');
  }
}

  Future<Task> updateTaskStatus(int id, String status) async {
    final url = Uri.parse('$baseUrl/$id/status?status=$status');
    logger.info('Updating task status for taskId: $id to status: $status');

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
    );
    logger.info('Response status: ${response.statusCode}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(response.body);
      logger.info('Task status updated for taskId: $id');
      return Task.fromJson(body);
    } else {
      logger.severe('Failed to update task status. Status code: ${response.statusCode}');
      throw Exception('Failed to update task status. Status code: ${response.statusCode}');
    }
  }

  Future<void> updateTask(Task task) async {
    final url = Uri.parse('$baseUrl/${task.id}');
    logger.info('Updating task with id: ${task.id}');

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(task.toJson()),
    );
    logger.info('Response status: ${response.statusCode}');

    if (response.statusCode != 200) {
      throw Exception('Failed to update task. Status code: ${response.statusCode}');
    }
  }

  Future<void> deleteTask(int id) async {
    final url = Uri.parse('$baseUrl/$id');
    logger.info('Deleting task with id: $id');

    final response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json'},
    );
    logger.info('Response status: ${response.statusCode}');

    if (response.statusCode != 200) {
      logger.severe('Failed to delete task. Status code: ${response.statusCode}');
      throw Exception('Failed to delete task. Status code: ${response.statusCode}');
    }
  }
}
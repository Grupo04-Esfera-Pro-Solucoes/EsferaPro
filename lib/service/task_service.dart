import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/task_model.dart';
import 'package:logging/logging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TaskService {
  final String baseUrl = '${dotenv.env['API_URL'] ?? 'http://localhost:8080'}/task';

  Future<List<Task>> fetchTasks(int userId) async {
    final url = Uri.parse('$baseUrl/all/$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) {
        final taskJson = item as Map<String, dynamic>;
        return Task.fromJson(taskJson);
      }).toList();
    } else {
      throw Exception('Erro ao carregar tarefas: ${response.statusCode}');
    }
  }

  Future<Task> createTask(Task task) async {
  final response = await http.post(
    Uri.parse(baseUrl),
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

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    return Task(
      id: data['idTask'],
      name: data['name'],
      description: data['description'],
      dueDate: DateTime.parse(data['dueDate']),
      status: data['status'],
      userId: task.userId, 
    );
  } else {
    throw Exception('Erro ao criar tarefa');
  }
}

  Future<Task> updateTaskStatus(int id, String status) async {
    final url = Uri.parse('$baseUrl/$id/status?status=$status');

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(response.body);
      return Task.fromJson(body);
    } else {
      throw Exception('Erro ao atualizar status da tarefa: ${response.statusCode}');
    }
  }

  Future<void> updateTask(Task task) async {
    final url = Uri.parse('$baseUrl/${task.id}');

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(task.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar tarefa: ${response.statusCode}');
    }
  }

  Future<void> deleteTask(int id) async {
    final url = Uri.parse('$baseUrl/$id');

    final response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao excluir tarefa: ${response.statusCode}');
    }
  }
}
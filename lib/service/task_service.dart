import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/task_model.dart';

class TaskService {
  final String baseUrl = 'http://localhost:8080/task';

  Future<List<Task>> fetchTasks(int userId) async {
    final url = Uri.parse('$baseUrl/all/$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Task.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar as tarefas.');
    }
  }

  Future<Task> createTask(Task task) async {
    final url = Uri.parse(baseUrl);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(task.toJson()),
    );

    if (response.statusCode == 200) {
      return Task.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erro ao criar a tarefa.');
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      final response = await http.put(
        Uri.parse('http://localhost:8080/task/${task.id}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': task.name,
          'description': task.description,
          'dueDate': task.dueDate.toIso8601String(),
          'status': task.status,
        }),
      );
      if (response.statusCode == 200) {
        print('Tarefa atualizada com sucesso.');
      } else {
        throw Exception('Falha ao atualizar tarefa: ${response.body}');
      }
    } catch (e) {
      print('Erro ao atualizar tarefa: $e');
      throw e;
    }
  }

  Future<void> updateTaskStatus(String id, String status) async {
    final url = Uri.parse('$baseUrl/$id/status?status=$status');
    final response = await http.put(url);

    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar o status da tarefa.');
    }
  }

  Future<void> deleteTask(String id) async {
    final url = Uri.parse('$baseUrl/$id');
    final response = await http.delete(url, headers: {'Content-Type': 'application/json'});

    if (response.statusCode != 200) {
      throw Exception('Erro ao excluir a tarefa.');
    }
  }
}
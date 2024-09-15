import 'dart:convert';
import 'package:http/http.dart' as http;
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
      throw Exception('Erro ao buscar tarefas: ${response.statusCode}');
    }
  }

  Future<Task> createTask(Task task) async {
    final url = Uri.parse(baseUrl);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(task.toJson()),
    );

    if (response.statusCode == 200) {
      return Task.fromJson(json.decode(response.body));
    } else {
      throw Exception('Erro ao criar tarefa: ${response.statusCode}');
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
    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception('Erro ao excluir tarefa: ${response.statusCode}');
    }
  }
}

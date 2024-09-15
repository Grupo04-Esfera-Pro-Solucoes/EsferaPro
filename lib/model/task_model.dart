import 'package:intl/intl.dart';

class Task {
  String id;
  String name;
  String description;
  DateTime dueDate;
  String status;

  Task({
    required this.id,
    required this.name,
    required this.description,
    required this.dueDate,
    required this.status,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] ?? '',
      name: json['name'],
      description: json['description'],
      dueDate: DateTime.parse(json['dueDate']),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'status': status,
    };
  }

  String getFormattedDueDate() {
    return DateFormat('dd/MM/yyyy').format(dueDate);
  }
}
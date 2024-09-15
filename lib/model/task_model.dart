import 'package:intl/intl.dart';

class Task {
  final int id;
  final String name;
  final String description;
  final DateTime dueDate;
  final String status;
  final int userId;

  Task({
    required this.id,
    required this.name,
    required this.description,
    required this.dueDate,
    required this.status,
    required this.userId,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] ?? 0,
      name: json['name'],
      description: json['description'],
      dueDate: DateTime.parse(json['dueDate']),
      status: json['status'],
      userId: json['user']['idUser'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'status': status,
      'user': {
        'idUser': userId,
      },
    };
  }

  String getFormattedDueDate() {
    return DateFormat('dd/MM/yyyy').format(dueDate);
  }

  Task copyWith({
    int? id,
    String? name,
    String? description,
    DateTime? dueDate,
    String? status,
    int? userId,
  }) {
    return Task(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      userId: userId ?? this.userId,
    );
  }
}
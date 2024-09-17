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
    final id = json['idTask'];
    if (id == null || id <= 0) {
      throw ArgumentError('Invalid id: $id');
    }

    final userId = json['user']['idUser'];
    if (userId == null || userId <= 0) {
      throw ArgumentError('Invalid userId: $userId');
    }

    return Task(
      id: id,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      dueDate: json['dueDate'] != null
          ? DateTime.tryParse(json['dueDate']) ?? DateTime.now()
          : DateTime.now(),
      status: json['status'] ?? 'todo',
      userId: userId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idTask': id,
      'name': name,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'status': status,
      'userId': userId,
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
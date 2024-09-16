import 'package:intl/intl.dart';

class Task {
  final int id;
  final String name;
  final String description;
  final DateTime dueDate;
  final String status;
  final User user;

  Task({
    required this.id,
    required this.name,
    required this.description,
    required this.dueDate,
    required this.status,
    required this.user,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    if (id == null || id <= 0) {
      throw ArgumentError('Invalid id: $id');
    }

    return Task(
      id: id,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      dueDate: json['dueDate'] != null
          ? DateTime.tryParse(json['dueDate']) ?? DateTime.now()
          : DateTime.now(),
      status: json['status'] ?? 'todo',
      user: User.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'status': status,
      'user': user.toJson(),
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
    User? user,
  }) {
    return Task(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }
}

class User {
  final int idUser;

  User({required this.idUser});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      idUser: json['idUser'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idUser': idUser,
    };
  }
}
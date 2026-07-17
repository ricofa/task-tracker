import 'package:cloud_firestore/cloud_firestore.dart';

enum TaskStatus {
  todo('todo'),
  doing('doing'),
  done('done');

  const TaskStatus(this.value);

  final String value;

  static TaskStatus fromValue(String value) {
    return TaskStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => TaskStatus.todo,
    );
  }
}

enum TaskPriority {
  low('low'),
  medium('medium'),
  high('high');

  const TaskPriority(this.value);

  final String value;

  static TaskPriority fromValue(String value) {
    return TaskPriority.values.firstWhere(
      (priority) => priority.value == value,
      orElse: () => TaskPriority.low,
    );
  }
}

class TaskModel {
  const TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.dueDate,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String title;
  final String description;
  final TaskStatus status;
  final TaskPriority priority;
  final DateTime? dueDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory TaskModel.fromFirestore({
    required String id,
    required Map<String, dynamic> data,
  }) {
    return TaskModel(
      id: id,
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      status: TaskStatus.fromValue(data['status'] as String? ?? 'todo'),
      priority: TaskPriority.fromValue(data['priority'] as String? ?? 'low'),
      dueDate: _readNullableDate(data['dueDate']),
      createdAt: _readDate(data['createdAt']),
      updatedAt: _readDate(data['updatedAt']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'status': status.value,
      'priority': priority.value,
      'dueDate': dueDate,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    TaskStatus? status,
    TaskPriority? priority,
    DateTime? dueDate,
    bool clearDueDate = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      dueDate: clearDueDate ? null : dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static DateTime _readDate(Object? value) {
    return _readNullableDate(value) ?? DateTime.fromMillisecondsSinceEpoch(0);
  }

  static DateTime? _readNullableDate(Object? value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }
}

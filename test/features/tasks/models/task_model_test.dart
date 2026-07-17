import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_task_tracker/features/tasks/models/task_model.dart';

void main() {
  group('TaskModel', () {
    test('converts Firestore map into TaskModel', () {
      final createdAt = DateTime(2026, 7, 16, 9);
      final updatedAt = DateTime(2026, 7, 16, 10);
      final dueDate = DateTime(2026, 7, 20);

      final task = TaskModel.fromFirestore(
        id: 'task-1',
        data: {
          'title': 'Learn Provider',
          'description': 'Build state with ChangeNotifier',
          'status': 'doing',
          'priority': 'high',
          'dueDate': Timestamp.fromDate(dueDate),
          'createdAt': Timestamp.fromDate(createdAt),
          'updatedAt': Timestamp.fromDate(updatedAt),
        },
      );

      expect(task.id, 'task-1');
      expect(task.title, 'Learn Provider');
      expect(task.description, 'Build state with ChangeNotifier');
      expect(task.status, TaskStatus.doing);
      expect(task.priority, TaskPriority.high);
      expect(task.dueDate, dueDate);
      expect(task.createdAt, createdAt);
      expect(task.updatedAt, updatedAt);
    });

    test('converts TaskModel into Firestore map without id', () {
      final createdAt = DateTime(2026, 7, 16, 9);
      final updatedAt = DateTime(2026, 7, 16, 10);
      final dueDate = DateTime(2026, 7, 20);

      final task = TaskModel(
        id: 'task-1',
        title: 'Learn Firebase',
        description: 'Store tasks in Firestore',
        status: TaskStatus.todo,
        priority: TaskPriority.medium,
        dueDate: dueDate,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      expect(task.toFirestore(), {
        'title': 'Learn Firebase',
        'description': 'Store tasks in Firestore',
        'status': 'todo',
        'priority': 'medium',
        'dueDate': dueDate,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      });
    });

    test('copyWith changes selected fields only', () {
      final createdAt = DateTime(2026, 7, 16, 9);
      final updatedAt = DateTime(2026, 7, 16, 10);

      final task = TaskModel(
        id: 'task-1',
        title: 'Original',
        description: 'Description',
        status: TaskStatus.todo,
        priority: TaskPriority.low,
        dueDate: null,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      final changed = task.copyWith(
        title: 'Changed',
        status: TaskStatus.done,
      );

      expect(changed.id, 'task-1');
      expect(changed.title, 'Changed');
      expect(changed.description, 'Description');
      expect(changed.status, TaskStatus.done);
      expect(changed.priority, TaskPriority.low);
      expect(changed.dueDate, isNull);
      expect(changed.createdAt, createdAt);
      expect(changed.updatedAt, updatedAt);
    });
  });
}

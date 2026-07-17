import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_task_tracker/app.dart';
import 'package:simple_task_tracker/features/tasks/models/task_model.dart';
import 'package:simple_task_tracker/features/tasks/repositories/task_repository.dart';

void main() {
  testWidgets('shows the task tracker shell', (WidgetTester tester) async {
    await tester.pumpWidget(
      SimpleTaskTrackerApp(repository: _FakeTaskRepository()),
    );

    expect(find.text('Simple Task Tracker'), findsOneWidget);
  });

  testWidgets('shows submit feedback while add task is pending', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      SimpleTaskTrackerApp(repository: _PendingAddTaskRepository()),
    );
    await tester.pump();

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Title'),
      'Pending task',
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Add Task'));
    await tester.pump();

    expect(find.text('Saving...'), findsOneWidget);
    final button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Saving...'),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('keeps add task form open and shows error when add fails', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      SimpleTaskTrackerApp(repository: _FailingAddTaskRepository()),
    );
    await tester.pump();

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Title'),
      'Failing task',
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Add Task'));
    await tester.pumpAndSettle();

    expect(find.text('Add Task'), findsWidgets);
    expect(find.textContaining('Failed to add task'), findsOneWidget);
    expect(find.textContaining('Repository failed'), findsOneWidget);
  });
}

class _FakeTaskRepository implements TaskRepositoryContract {
  @override
  Future<List<TaskModel>> getTasks() async {
    return [];
  }

  @override
  Future<void> addTask({
    required String title,
    required String description,
    required TaskStatus status,
    required TaskPriority priority,
    DateTime? dueDate,
  }) async {}

  @override
  Future<void> updateTask(TaskModel task) async {}

  @override
  Future<void> deleteTask(String id) async {}
}

class _PendingAddTaskRepository extends _FakeTaskRepository {
  final Completer<void> _addCompleter = Completer<void>();

  @override
  Future<void> addTask({
    required String title,
    required String description,
    required TaskStatus status,
    required TaskPriority priority,
    DateTime? dueDate,
  }) {
    return _addCompleter.future;
  }
}

class _FailingAddTaskRepository extends _FakeTaskRepository {
  @override
  Future<void> addTask({
    required String title,
    required String description,
    required TaskStatus status,
    required TaskPriority priority,
    DateTime? dueDate,
  }) {
    throw Exception('Repository failed');
  }
}

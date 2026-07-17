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

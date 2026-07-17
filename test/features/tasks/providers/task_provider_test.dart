import 'package:flutter_test/flutter_test.dart';
import 'package:simple_task_tracker/features/tasks/models/task_model.dart';
import 'package:simple_task_tracker/features/tasks/providers/task_provider.dart';
import 'package:simple_task_tracker/features/tasks/repositories/task_repository.dart';

void main() {
  group('TaskProvider', () {
    test('loads tasks from repository', () async {
      final repository = FakeTaskRepository(
        initialTasks: [
          makeTask(id: 'task-1', title: 'Learn Provider'),
          makeTask(id: 'task-2', title: 'Learn Firebase'),
        ],
      );
      final provider = TaskProvider(repository: repository);

      await provider.loadTasks();

      expect(provider.isLoading, isFalse);
      expect(provider.errorMessage, isNull);
      expect(provider.tasks.map((task) => task.title), [
        'Learn Provider',
        'Learn Firebase',
      ]);
    });

    test('filters tasks by selected status', () async {
      final repository = FakeTaskRepository(
        initialTasks: [
          makeTask(id: 'task-1', title: 'Todo', status: TaskStatus.todo),
          makeTask(id: 'task-2', title: 'Done', status: TaskStatus.done),
        ],
      );
      final provider = TaskProvider(repository: repository);

      await provider.loadTasks();
      provider.setFilterStatus(TaskStatus.done);

      expect(provider.filteredTasks.length, 1);
      expect(provider.filteredTasks.single.title, 'Done');
    });

    test('stores errorMessage with failure detail when repository fails',
        () async {
      final repository = FakeTaskRepository(shouldThrowOnLoad: true);
      final provider = TaskProvider(repository: repository);

      await provider.loadTasks();

      expect(provider.isLoading, isFalse);
      expect(provider.errorMessage, contains('Failed to load tasks'));
      expect(provider.errorMessage, contains('Exception: Repository failed'));
      expect(provider.tasks, isEmpty);
    });

    test('reloads tasks after adding a task', () async {
      final repository = FakeTaskRepository();
      final provider = TaskProvider(repository: repository);

      final succeeded = await provider.addTask(
        title: 'New task',
        description: 'Description',
        status: TaskStatus.todo,
        priority: TaskPriority.medium,
        dueDate: null,
      );

      expect(succeeded, isTrue);
      expect(provider.tasks.map((task) => task.title), ['New task']);
    });

    test('addTask returns false and stores detailed errorMessage when add fails',
        () async {
      final repository = FakeTaskRepository(shouldThrowOnMutation: true);
      final provider = TaskProvider(repository: repository);

      final succeeded = await provider.addTask(
        title: 'New task',
        description: 'Description',
        status: TaskStatus.todo,
        priority: TaskPriority.medium,
        dueDate: null,
      );

      expect(succeeded, isFalse);
      expect(provider.isLoading, isFalse);
      expect(provider.errorMessage, contains('Failed to add task'));
      expect(provider.errorMessage, contains('Exception: Repository failed'));
      expect(provider.tasks, isEmpty);
    });

    test(
      'updateTask returns false and stores detailed errorMessage when update fails',
      () async {
      final task = makeTask(id: 'task-1', title: 'Original');
      final repository = FakeTaskRepository(
        initialTasks: [task],
        shouldThrowOnMutation: true,
      );
      final provider = TaskProvider(repository: repository);

      final succeeded = await provider.updateTask(
        task.copyWith(title: 'Updated'),
      );

      expect(succeeded, isFalse);
      expect(provider.isLoading, isFalse);
      expect(provider.errorMessage, contains('Failed to update task'));
      expect(provider.errorMessage, contains('Exception: Repository failed'));
      expect(provider.tasks, isEmpty);
      },
    );
  });
}

TaskModel makeTask({
  required String id,
  required String title,
  TaskStatus status = TaskStatus.todo,
  TaskPriority priority = TaskPriority.low,
}) {
  final now = DateTime(2026, 7, 16);

  return TaskModel(
    id: id,
    title: title,
    description: 'Description',
    status: status,
    priority: priority,
    dueDate: null,
    createdAt: now,
    updatedAt: now,
  );
}

class FakeTaskRepository implements TaskRepositoryContract {
  FakeTaskRepository({
    List<TaskModel> initialTasks = const [],
    this.shouldThrowOnLoad = false,
    this.shouldThrowOnMutation = false,
  }) : _tasks = [...initialTasks];

  final bool shouldThrowOnLoad;
  final bool shouldThrowOnMutation;
  final List<TaskModel> _tasks;

  @override
  Future<List<TaskModel>> getTasks() async {
    if (shouldThrowOnLoad) {
      throw Exception('Repository failed');
    }
    return [..._tasks];
  }

  @override
  Future<void> addTask({
    required String title,
    required String description,
    required TaskStatus status,
    required TaskPriority priority,
    DateTime? dueDate,
  }) async {
    if (shouldThrowOnMutation) {
      throw Exception('Repository failed');
    }

    final now = DateTime(2026, 7, 16);
    _tasks.add(
      TaskModel(
        id: 'task-${_tasks.length + 1}',
        title: title,
        description: description,
        status: status,
        priority: priority,
        dueDate: dueDate,
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    if (shouldThrowOnMutation) {
      throw Exception('Repository failed');
    }

    final index = _tasks.indexWhere((item) => item.id == task.id);
    if (index >= 0) {
      _tasks[index] = task;
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    if (shouldThrowOnMutation) {
      throw Exception('Repository failed');
    }

    _tasks.removeWhere((task) => task.id == id);
  }
}

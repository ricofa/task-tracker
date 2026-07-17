import 'package:flutter/foundation.dart';

import '../models/task_model.dart';
import '../repositories/task_repository.dart';

class TaskProvider extends ChangeNotifier {
  TaskProvider({
    required TaskRepositoryContract repository,
  }) : _repository = repository;

  final TaskRepositoryContract _repository;

  List<TaskModel> _tasks = [];
  bool _isLoading = false;
  String? _errorMessage;
  TaskStatus? _selectedStatus;

  List<TaskModel> get tasks => List.unmodifiable(_tasks);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  TaskStatus? get selectedStatus => _selectedStatus;

  List<TaskModel> get filteredTasks {
    final status = _selectedStatus;
    if (status == null) {
      return tasks;
    }

    return _tasks.where((task) => task.status == status).toList();
  }

  Future<void> loadTasks() async {
    await _runWithLoading(
      failureMessage: 'Failed to load tasks',
      action: () async {
        _tasks = await _repository.getTasks();
      },
    );
  }

  Future<void> addTask({
    required String title,
    required String description,
    required TaskStatus status,
    required TaskPriority priority,
    DateTime? dueDate,
  }) async {
    await _runWithLoading(
      failureMessage: 'Failed to add task',
      action: () async {
        await _repository.addTask(
          title: title,
          description: description,
          status: status,
          priority: priority,
          dueDate: dueDate,
        );
        _tasks = await _repository.getTasks();
      },
    );
  }

  Future<void> updateTask(TaskModel task) async {
    await _runWithLoading(
      failureMessage: 'Failed to update task',
      action: () async {
        await _repository.updateTask(task);
        _tasks = await _repository.getTasks();
      },
    );
  }

  Future<void> deleteTask(String id) async {
    await _runWithLoading(
      failureMessage: 'Failed to delete task',
      action: () async {
        await _repository.deleteTask(id);
        _tasks = await _repository.getTasks();
      },
    );
  }

  Future<void> changeStatus(TaskModel task, TaskStatus status) async {
    await updateTask(task.copyWith(status: status));
  }

  void setFilterStatus(TaskStatus? status) {
    _selectedStatus = status;
    notifyListeners();
  }

  Future<void> _runWithLoading({
    required String failureMessage,
    required Future<void> Function() action,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await action();
    } catch (_) {
      _errorMessage = failureMessage;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

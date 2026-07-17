import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/task_model.dart';

abstract class TaskRepositoryContract {
  Future<List<TaskModel>> getTasks();

  Future<void> addTask({
    required String title,
    required String description,
    required TaskStatus status,
    required TaskPriority priority,
    DateTime? dueDate,
  });

  Future<void> updateTask(TaskModel task);

  Future<void> deleteTask(String id);
}

class TaskRepository implements TaskRepositoryContract {
  TaskRepository({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _tasksCollection {
    return _firestore.collection('tasks');
  }

  @override
  Future<List<TaskModel>> getTasks() async {
    final snapshot = await _tasksCollection
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      return TaskModel.fromFirestore(
        id: doc.id,
        data: doc.data(),
      );
    }).toList();
  }

  @override
  Future<void> addTask({
    required String title,
    required String description,
    required TaskStatus status,
    required TaskPriority priority,
    DateTime? dueDate,
  }) async {
    final now = DateTime.now();

    await _tasksCollection.add({
      'title': title,
      'description': description,
      'status': status.value,
      'priority': priority.value,
      'dueDate': dueDate,
      'createdAt': now,
      'updatedAt': now,
    });
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    await _tasksCollection.doc(task.id).update({
      ...task.toFirestore(),
      'updatedAt': DateTime.now(),
    });
  }

  @override
  Future<void> deleteTask(String id) async {
    await _tasksCollection.doc(id).delete();
  }
}

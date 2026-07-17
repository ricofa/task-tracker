import 'package:flutter/material.dart';

import '../models/task_model.dart';

class TaskFormPage extends StatelessWidget {
  const TaskFormPage({
    required this.task,
    super.key,
  });

  final TaskModel? task;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(task == null ? 'Add Task' : 'Edit Task'),
      ),
      body: const Center(
        child: Text('Task form'),
      ),
    );
  }
}

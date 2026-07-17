import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/tasks/providers/task_provider.dart';
import 'features/tasks/repositories/task_repository.dart';
import 'features/tasks/views/task_list_page.dart';

class SimpleTaskTrackerApp extends StatelessWidget {
  const SimpleTaskTrackerApp({
    this.repository,
    super.key,
  });

  final TaskRepositoryContract? repository;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskProvider(repository: repository ?? TaskRepository()),
      child: MaterialApp(
        title: 'Simple Task Tracker',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
        ),
        home: const TaskListPage(),
      ),
    );
  }
}

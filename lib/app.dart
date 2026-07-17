import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/tasks/providers/task_provider.dart';
import 'features/tasks/repositories/task_repository.dart';

class SimpleTaskTrackerApp extends StatelessWidget {
  const SimpleTaskTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskProvider(repository: TaskRepository()),
      child: MaterialApp(
        title: 'Simple Task Tracker',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
        ),
        home: const Scaffold(
          body: Center(
            child: Text('Simple Task Tracker'),
          ),
        ),
      ),
    );
  }
}

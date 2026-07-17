import 'package:flutter/material.dart';

class SimpleTaskTrackerApp extends StatelessWidget {
  const SimpleTaskTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    );
  }
}

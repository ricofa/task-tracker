import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/app_error.dart';
import '../../../core/widgets/app_loading.dart';
import '../../../core/widgets/empty_state.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';
import '../widgets/task_card.dart';
import '../widgets/task_filter_chips.dart';
import 'task_form_page.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskProvider>().loadTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appTitle),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.tasks.isEmpty) {
            return const AppLoading();
          }

          final errorMessage = provider.errorMessage;
          if (errorMessage != null && provider.tasks.isEmpty) {
            return AppError(
              message: errorMessage,
              onRetry: provider.loadTasks,
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TaskFilterChips(
                  selectedStatus: provider.selectedStatus,
                  onSelected: provider.setFilterStatus,
                ),
                const SizedBox(height: 16),
                if (provider.isLoading) const LinearProgressIndicator(),
                if (errorMessage != null && provider.tasks.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      errorMessage,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                Expanded(
                  child: _TaskList(
                    tasks: provider.filteredTasks,
                    onEdit: (task) => _openForm(context, task),
                    onDelete: provider.deleteTask,
                    onStatusChanged: provider.changeStatus,
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context, null),
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
      ),
    );
  }

  Future<void> _openForm(BuildContext context, TaskModel? task) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TaskFormPage(task: task),
      ),
    );
  }
}

class _TaskList extends StatelessWidget {
  const _TaskList({
    required this.tasks,
    required this.onEdit,
    required this.onDelete,
    required this.onStatusChanged,
  });

  final List<TaskModel> tasks;
  final ValueChanged<TaskModel> onEdit;
  final ValueChanged<String> onDelete;
  final Future<void> Function(TaskModel task, TaskStatus status) onStatusChanged;

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return const EmptyState(message: AppStrings.emptyTasks);
    }

    return ListView.separated(
      itemCount: tasks.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final task = tasks[index];

        return TaskCard(
          task: task,
          onEdit: () => onEdit(task),
          onDelete: () => onDelete(task.id),
          onStatusChanged: (status) => onStatusChanged(task, status),
        );
      },
    );
  }
}

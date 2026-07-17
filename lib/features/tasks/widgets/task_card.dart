import 'package:flutter/material.dart';

import '../../../core/utils/date_formatter.dart';
import '../models/task_model.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    required this.task,
    required this.onEdit,
    required this.onDelete,
    required this.onStatusChanged,
    super.key,
  });

  final TaskModel task;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<TaskStatus> onStatusChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      onEdit();
                    } else if (value == 'delete') {
                      onDelete();
                    }
                  },
                  itemBuilder: (context) {
                    return const [
                      PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ];
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(task.description),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Chip(label: Text('Priority: ${task.priority.value}')),
                Chip(label: Text('Due: ${formatShortDate(task.dueDate)}')),
                DropdownButton<TaskStatus>(
                  value: task.status,
                  onChanged: (status) {
                    if (status != null) {
                      onStatusChanged(status);
                    }
                  },
                  items: TaskStatus.values.map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(status.value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../models/task_model.dart';

class TaskFilterChips extends StatelessWidget {
  const TaskFilterChips({
    required this.selectedStatus,
    required this.onSelected,
    super.key,
  });

  final TaskStatus? selectedStatus;
  final ValueChanged<TaskStatus?> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ChoiceChip(
          label: const Text('All'),
          selected: selectedStatus == null,
          onSelected: (_) => onSelected(null),
        ),
        ...TaskStatus.values.map((status) {
          return ChoiceChip(
            label: Text(status.value),
            selected: selectedStatus == status,
            onSelected: (_) => onSelected(status),
          );
        }),
      ],
    );
  }
}

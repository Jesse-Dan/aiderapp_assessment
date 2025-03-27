import 'package:flutter/material.dart';

import '../../../resources/models/task.dart';
import '../views/focus/components/empty_view.dart';
import 'task_tile.dart';

class TaskListView extends StatelessWidget {
  final List<Task> tasks;
  final bool isCompletedList;
  final String emptyMessage;

  const TaskListView({
    super.key,
    required this.tasks,
    required this.isCompletedList,
    required this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    return tasks.isEmpty
        ? EmptyView(emptyMessage)
        : ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return TaskTile(
                task: task,
              );
            },
          );
  }
}

import 'package:do_it_now/src/modules/base/views/home/views/task_detail.dart';
import 'package:do_it_now/src/resources/extensions/date_time.dart';
import 'package:do_it_now/src/resources/extensions/string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/task_provider.dart';
import '../../../resources/models/task.dart';

class TaskTile extends ConsumerWidget {
  final Task task;

  const TaskTile({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskProviderRef = ref.read(taskProvider);

    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(TaskDetailView.routeName, arguments: task);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.black.withOpacity(.1)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Checkbox(
                value: task.isCompleted,
                onChanged: (value) {
                  if (value != null) {
                    taskProviderRef.toggleTaskCompletion(
                        task.id!, task.isCompleted);
                  }
                },
                activeColor: Colors.black,
                side: const BorderSide(width: .7),
              ),
              // Task details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        color: task.isCompleted ? Colors.grey : Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      task.description.truncateWithEllipsis(12, suffix: "..."),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
              Column(
                children: [
                  Text(
                    task.timeline.formatDateForUser,
                    style: const TextStyle(fontSize: 10, color: Colors.black),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          task.category.name,
                          style: TextStyle(
                              fontSize: 10, color: task.category.color),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: task
                              .getPriorityColor(task.priority)
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Priority: ${task.priority}',
                          style: TextStyle(
                            fontSize: 10,
                            color: task.getPriorityColor(task.priority),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.2, end: 0.0),
    );
  }
}

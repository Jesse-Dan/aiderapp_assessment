import 'package:do_it_now/src/resources/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../providers/task_provider.dart';
import '../../../../../resources/models/task.dart';
import 'create_task.dart';

class TaskDetailView extends ConsumerWidget {
  static const routeName = '/TaskDetailView';
  final Task task;

  const TaskDetailView({super.key, required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(task.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    title: const Text('Title'),
                    subtitle: Text(task.title),
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('Description'),
                    subtitle: Text(task.description.isNotEmpty
                        ? task.description
                        : 'No description provided'),
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('Priority'),
                    subtitle: Text(task.priority.toString()),
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('Category'),
                    subtitle: Text(task.category.toString().split('.').last),
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('Timeline'),
                    subtitle: Text(task.timeline.toLocal().toString()),
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('Status'),
                    subtitle:
                        Text(task.isCompleted ? 'Completed' : 'Incomplete'),
                  ),
                ],
              ),
            ),
            // Action Buttons Row
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: SizedBox(
                height: 48,
                width: 500,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: AppButton(
                        onPressed: () =>
                            _handleEdit(context, ref.read(taskProvider)),
                        text: 'Edit',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: AppButton(
                        onPressed: () => _handleDelete(context, ref),
                        text: 'Delete',
                        primaryColor: Colors.red,
                        buttonType: ButtonType.outlined,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleEdit(BuildContext context, TaskProvider taskProvider) {
    taskProvider.titleController.text = task.title;
    taskProvider.descriptionController.text = task.description;
    taskProvider.priority.value = task.priority;
    taskProvider.category.value = task.category;
    taskProvider.dueDate.value = task.timeline;
    taskProvider.isCompleted.value = task.isCompleted;

    Navigator.pushNamed(context, CreateTaskView.routeName).then((_) {
      taskProvider.clearControllers();
    });
  }

  void _handleDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: const Text(
          'Delete Task',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to delete this task?',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Expanded(
            child: AppButton(
              onPressed: () => Navigator.pop(context),
              text: 'Cancel',
              buttonType: ButtonType.outlined,
              primaryColor: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: AppButton(
              onPressed: () async {
                await ref.read(taskProvider).deleteTask(task.id!);
                
                if (context.mounted) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                }
              },
              text: 'Delete',
              primaryColor: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}

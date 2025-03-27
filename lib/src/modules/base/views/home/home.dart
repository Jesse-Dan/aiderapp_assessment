import 'package:do_it_now/src/providers/task_provider.dart';
import 'package:do_it_now/src/resources/extensions/date_time.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/grouped_task_tile.dart';
import 'views/create_task.dart';

class HomeView extends ConsumerWidget {
  static const routeName = '/HomeView';
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    final displayName = user?.displayName ?? 'User';
    final taskProviderRef = ref.watch(taskProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: Colors.black,
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${getGreeting()},\n$displayName!',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Colors.white),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                      "${taskProviderRef.completedTasks.value.length} Done"),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                ExpandableSection(
                  title: 'To-Do',
                  items: taskProviderRef.incompleteTasks.value,
                  initiallyExpanded: true,
                ),
                ExpandableSection(
                  title: 'Completed',
                  items: taskProviderRef.completedTasks.value,
                  initiallyExpanded: false,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, CreateTaskView.routeName);
        },
        label: const Text('Add Task'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

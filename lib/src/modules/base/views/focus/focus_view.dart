import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../providers/task_provider.dart';
import '../../components/task_list_view.dart';
import '../../components/task_tab_bar.dart';

class FocusView extends ConsumerStatefulWidget {
  static const routeName = '/ViewAllTasks';

  const FocusView({super.key});

  @override
  ConsumerState<FocusView> createState() => _FocusViewState();
}

class _FocusViewState extends ConsumerState<FocusView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Fetch tasks on initialization
    ref.read(taskProvider).getTasks();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taskProviderRef = ref.watch(taskProvider);

    return Scaffold(
      appBar: TaskTabBar(tabController: _tabController),
      body: TabBarView(
        controller: _tabController,
        children: [
          TaskListView(
            tasks: taskProviderRef.incompleteTasks.value,
            isCompletedList: false,
            emptyMessage: 'No tasks to do!',
          ),
          TaskListView(
            tasks: taskProviderRef.completedTasks.value,
            isCompletedList: true,
            emptyMessage: 'No tasks completed!',
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class TaskTabBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController tabController;

  const TaskTabBar({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Focus',
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      bottom: TabBar(
        controller: tabController,
        tabs: const [
          Tab(text: 'To-Do'),
          Tab(text: 'Completed'),
        ],
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey,
        indicatorColor: Colors.white,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 90);
}

import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../resources/models/category.dart';
import '../resources/models/task.dart';
import '../resources/utils/show_loading.dart';
import '../resources/utils/show_text.dart';

final taskProvider = ChangeNotifierProvider((ref) {
  return TaskProvider.instance;
});

class TaskProvider extends ChangeNotifier {
  final String _collectionString = "tasks";
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Controllers and value notifiers
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final ValueNotifier<bool> isCompleted = ValueNotifier<bool>(false);
  final ValueNotifier<Category?> category = ValueNotifier<Category?>(null);
  final ValueNotifier<DateTime> dueDate =
      ValueNotifier<DateTime>(DateTime.now());
  final ValueNotifier<int> priority = ValueNotifier<int>(1);

  final ValueNotifier<List<Task>> completedTasks =
      ValueNotifier<List<Task>>([]);
  final ValueNotifier<List<Task>> incompleteTasks =
      ValueNotifier<List<Task>>([]);

  static void initialize() {
    _instance = _instance ??= TaskProvider._();
  }

  static TaskProvider? _instance;
  TaskProvider._();
  static TaskProvider get instance => _instance!;

  void cancelLoading() {
    BotToast.closeAllLoading();
  }

  Future<Task> createTask() async {
    try {
      showLoading('Creating task...');

      final task = Task(
        uuid: FirebaseAuth.instance.currentUser!.uid,
        title: titleController.text,
        description: descriptionController.text,
        priority: priority.value,
        timeline: dueDate.value,
        category: category.value ?? Category.predefinedCategories.first,
        isCompleted: isCompleted.value,
      );

      final docRef =
          await _firestore.collection(_collectionString).add(task.toJson());

      await _firestore
          .collection(_collectionString)
          .doc(docRef.id)
          .update({'id': docRef.id});

      final createdDoc =
          await _firestore.collection(_collectionString).doc(docRef.id).get();
      final createdTask = Task.fromJson(createdDoc.data()!);

      if (createdTask.isCompleted) {
        completedTasks.value = [...completedTasks.value, createdTask];
      } else {
        incompleteTasks.value = [...incompleteTasks.value, createdTask];
      }

      clearControllers();
      cancelLoading();
      showText('Task created successfully!');
      notifyListeners();

      return createdTask;
    } catch (e) {
      cancelLoading();
      showText('Error creating task: $e');
      rethrow; 
    }
  }

  Future<void> updateTask(String id) async {
    try {
      showLoading('Updating task...');

      final updatedTask = Task(
        uuid: FirebaseAuth.instance.currentUser!.uid,
        title: titleController.text,
        description: descriptionController.text,
        priority: priority.value,
        timeline: dueDate.value,
        category: category.value!,
        isCompleted: isCompleted.value,
        id: id, 
      );

      await _firestore
          .collection(_collectionString)
          .doc(id)
          .update(updatedTask.toJson());

      _updateLocalTask(updatedTask);

      clearControllers();
      cancelLoading();
      showText('Task updated successfully!');
      notifyListeners();
    } catch (e) {
      cancelLoading();
      showText('Error updating task: $e');
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      showLoading('Deleting task...');

      await _firestore.collection(_collectionString).doc(id).delete();

      completedTasks.value =
          completedTasks.value.where((task) => task.id != id).toList();
      incompleteTasks.value =
          incompleteTasks.value.where((task) => task.id != id).toList();

      cancelLoading();
      showText('Task deleted successfully!');
      notifyListeners();
    } catch (e) {
      cancelLoading();
      showText('Error deleting task: $e');
    }
  }

  Future<void> getTasks() async {
    try {
      final snapshot = await _firestore
          .collection(_collectionString)
          .where('uuid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      final allTasks =
          snapshot.docs.map((doc) => Task.fromJson(doc.data())).toList();

      completedTasks.value =
          allTasks.where((task) => task.isCompleted).toList();
      incompleteTasks.value =
          allTasks.where((task) => !task.isCompleted).toList();
      notifyListeners();
    } catch (e) {
      showText('Error fetching tasks: $e');
    }
  }

  Future<void> toggleTaskCompletion(
      String id, bool isCurrentlyCompleted) async {
    try {
      showLoading('Updating task completion status...');

      await _firestore.collection(_collectionString).doc(id).update({
        'isCompleted': !isCurrentlyCompleted,
      });

      final taskList =
          isCurrentlyCompleted ? completedTasks.value : incompleteTasks.value;
      final taskIndex = taskList.indexWhere((task) => task.id == id);
      if (taskIndex != -1) {
        final task = taskList[taskIndex];
        final updatedTask = Task(
          uuid: task.uuid,
          title: task.title,
          description: task.description,
          priority: task.priority,
          timeline: task.timeline,
          category: task.category,
          id: task.id,
          isCompleted: !isCurrentlyCompleted,
        );

        if (isCurrentlyCompleted) {
          completedTasks.value =
              completedTasks.value.where((t) => t.id != id).toList();
          incompleteTasks.value = [...incompleteTasks.value, updatedTask];
        } else {
          incompleteTasks.value =
              incompleteTasks.value.where((t) => t.id != id).toList();
          completedTasks.value = [...completedTasks.value, updatedTask];
        }
      }

      cancelLoading();
      showText('Task completion status updated successfully!');
      notifyListeners();
    } catch (e) {
      cancelLoading();
      showText('Error updating task completion status: $e');
    }
  }

  void _updateLocalTask(Task updatedTask) {
    final inCompleted =
        completedTasks.value.indexWhere((t) => t.id == updatedTask.id);
    final inIncomplete =
        incompleteTasks.value.indexWhere((t) => t.id == updatedTask.id);

    if (inCompleted != -1) {
      final updatedList = [...completedTasks.value];
      if (updatedTask.isCompleted) {
        updatedList[inCompleted] = updatedTask;
        completedTasks.value = updatedList;
      } else {
        updatedList.removeAt(inCompleted);
        completedTasks.value = updatedList;
        incompleteTasks.value = [...incompleteTasks.value, updatedTask];
      }
    } else if (inIncomplete != -1) {
      final updatedList = [...incompleteTasks.value];
      if (!updatedTask.isCompleted) {
        updatedList[inIncomplete] = updatedTask;
        incompleteTasks.value = updatedList;
      } else {
        updatedList.removeAt(inIncomplete);
        incompleteTasks.value = updatedList;
        completedTasks.value = [...completedTasks.value, updatedTask];
      }
    } else {
      if (updatedTask.isCompleted) {
        completedTasks.value = [...completedTasks.value, updatedTask];
      } else {
        incompleteTasks.value = [...incompleteTasks.value, updatedTask];
      }
    }
  }

  void clearControllers() {
    titleController.clear();
    descriptionController.clear();
    isCompleted.value = false;
    dueDate.value = DateTime.now();
    priority.value = 1;
    category.value = null;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    isCompleted.dispose();
    category.dispose();
    dueDate.dispose();
    priority.dispose();
    completedTasks.dispose();
    incompleteTasks.dispose();
    super.dispose();
  }
}

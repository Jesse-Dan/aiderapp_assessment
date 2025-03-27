import 'package:do_it_now/src/resources/models/category.dart';
import 'package:flutter/material.dart';

class Task {
  final String? id;
  final String uuid;
  final String title;
  final String description;
  final int priority;
  final Task? subtask;
  final DateTime timeline;
  final Category category;
  bool isCompleted;

  Task({
    this.id,
    required this.uuid,
    required this.title,
    required this.description,
    this.priority = 1,
    this.subtask,
    required this.timeline,
    required this.category,
    this.isCompleted = false,
  }) : assert(priority >= 1 && priority <= 10,
            'Priority must be between 1 and 10');

  Task copyWith({
    String? id,
    String? uuid,
    String? title,
    String? description,
    int? priority,
    Task? subtask,
    DateTime? timeline,
    Category? category,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      subtask: subtask ?? this.subtask,
      timeline: timeline ?? this.timeline,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'title': title,
      'description': description,
      'priority': priority,
      'subtask': subtask?.toJson(),
      'timeline': timeline.toIso8601String(),
      'category': category.toJson(),
      'isCompleted': isCompleted,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      uuid: json['uuid'],
      title: json['title'],
      description: json['description'],
      priority: json['priority'],
      subtask: json['subtask'] != null ? Task.fromJson(json['subtask']) : null,
      timeline: DateTime.parse(json['timeline']),
      category: Category.fromJson(json['category']),
      isCompleted: json['isCompleted'] ?? false,
    );
  }
  Color getPriorityColor(int priority) {
    if (priority >= 8) {
      return Colors.red;
    } else if (priority >= 5) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }
}

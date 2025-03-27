import 'package:do_it_now/src/resources/extensions/context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../providers/task_provider.dart';
import '../../../../../resources/models/category.dart';
import '../../../../../resources/utils/show_text.dart';
import '../../../../../resources/widgets/app_button.dart';
import '../../../../../resources/widgets/app_text_field.dart';

class CreateTaskView extends ConsumerStatefulWidget {
  static const routeName = '/CreateTaskView';

  const CreateTaskView({super.key});

  @override
  ConsumerState<CreateTaskView> createState() => _CreateTaskViewState();
}

class _CreateTaskViewState extends ConsumerState<CreateTaskView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final taskProviderRef = ref.watch(taskProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              AppTextField(
                controller: taskProviderRef.titleController,
                labelText: 'Title',
                hintText: 'Enter task title',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title';
                  }
                  if (value.length < 3) {
                    return 'Title must be at least 3 characters long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: taskProviderRef.descriptionController,
                labelText: 'Description',
                hintText: 'Enter task description',
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a description';
                  }
                  if (value.length < 5) {
                    return 'Description must be at least 5 characters long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text(
                    'Priority:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: Colors.black,
                        inactiveTrackColor: Colors.white,
                        thumbColor: Colors.black,
                        overlayColor: Colors.black.withOpacity(0.2),
                        valueIndicatorColor: Colors.black,
                        valueIndicatorTextStyle:
                            const TextStyle(color: Colors.white),
                      ),
                      child: Slider(
                        value: taskProviderRef.priority.value.toDouble(),
                        min: 1,
                        max: 10,
                        divisions: 9,
                        label: taskProviderRef.priority.value.toString(),
                        onChanged: (value) {
                          taskProviderRef.priority.value = value.toInt();
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                        color: Colors.black, shape: BoxShape.circle),
                    child: Text(
                      '${taskProviderRef.priority.value}',
                      style: context.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w800, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      "Category",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final selectedCategory = await showDialog<Category>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: Colors.black,
                            title: const Text(
                              'Select Category',
                              style: TextStyle(color: Colors.white),
                            ),
                            content: SizedBox(
                              width: double.maxFinite,
                              child: GridView.count(
                                crossAxisCount: 2,
                                crossAxisSpacing: 8.0,
                                mainAxisSpacing: 8.0,
                                shrinkWrap: true,
                                children: Category.predefinedCategories
                                    .map((category) => GestureDetector(
                                          onTap: () {
                                            setState(() => taskProviderRef
                                                .category.value = category);
                                            Navigator.pop(context, category);
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[800],
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  category.icon,
                                                  color: Colors.white,
                                                  size: 26,
                                                ),
                                                const SizedBox(height: 12),
                                                Text(
                                                  category.name
                                                      .toString()
                                                      .split('.')
                                                      .last,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ),
                          );
                        },
                      );

                      if (selectedCategory != null) {
                        taskProviderRef.category.value = selectedCategory;
                        setState(() {});
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: taskProviderRef.category.value == null
                              ? Colors.red
                              : Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            taskProviderRef.category.value?.icon,
                            color: Colors.black,
                            size: 26,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            taskProviderRef.category.value?.name
                                    .toString()
                                    .split('.')
                                    .last ??
                                'Select Category',
                            style: TextStyle(
                              fontSize: 16,
                              color: taskProviderRef.category.value == null
                                  ? Colors.red
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (taskProviderRef.category.value == null)
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Please select a category',
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              AppButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    if (taskProviderRef.category.value == null) {
                      showText('Please select a category');
                      return;
                    }
                    await taskProviderRef.createTask();
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  }
                },
                text: 'Create Task',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

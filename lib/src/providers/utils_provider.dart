import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../resources/models/category.dart';
import '../resources/utils/show_loading.dart';
import '../resources/utils/show_text.dart';

class UtilsProvider extends ChangeNotifier {
  final String _categoriesCollectionString = "categories";
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Controllers and ValueNotifiers for category fields
  final TextEditingController categoryNameController = TextEditingController();
  final ValueNotifier<IconData?> selectedCategoryIcon = ValueNotifier<IconData?>(null);
  final ValueNotifier<Color?> selectedCategoryColor = ValueNotifier<Color?>(null);

  final ValueNotifier<String> selectedCategoryId = ValueNotifier<String>('');
  final ValueNotifier<bool> isEditing = ValueNotifier<bool>(false);

  static void initialize() {
    _instance = _instance ??= UtilsProvider._();
  }

  static UtilsProvider? _instance;
  UtilsProvider._();
  static UtilsProvider get instance => _instance!;

 Future<void> createCategory() async {
  try {
    if (categoryNameController.text.isEmpty ||
        selectedCategoryIcon.value == null ||
        selectedCategoryColor.value == null) {
      showText('Please fill in all fields before creating a category');
      return;
    }

    final category = Category(
      name: categoryNameController.text,
      icon: selectedCategoryIcon.value!,
      color: selectedCategoryColor.value!,
    );

    showLoading('Creating category...');
    await _firestore.collection(_categoriesCollectionString).add(category.toJson());
    showText('Category created successfully');
    clearCategoryFields();
  } catch (e) {
    showText('Error creating category: $e');
  } finally {
    cancelLoading();
  }
}


  Future<void> updateCategory(String id, Category category) async {
    try {
      showLoading('Updating category...');
      await _firestore.collection(_categoriesCollectionString).doc(id).update(category.toJson());
      showText('Category updated successfully');
      clearCategoryFields();
      isEditing.value = false;
      selectedCategoryId.value = '';
    } catch (e) {
      showText('Error updating category: $e');
    } finally {
      cancelLoading();
    }
  }

  void clearCategoryFields() {
    categoryNameController.clear();
    selectedCategoryIcon.value = null;
    selectedCategoryColor.value = null;
  }

  @override
  void dispose() {
    categoryNameController.dispose();
    selectedCategoryIcon.dispose();
    selectedCategoryColor.dispose();
    super.dispose();
  }
}

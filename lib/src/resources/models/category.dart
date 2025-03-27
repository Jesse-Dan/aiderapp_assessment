import 'package:flutter/material.dart';

class Category {
  final String name;
  final IconData icon;
  final Color color;

  Category({required this.name, required this.icon, required this.color});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'iconCodePoint': icon.codePoint,
      'colorValue': color.value,
    };
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['name'],
      icon: IconData(json['iconCodePoint'], fontFamily: 'MaterialIcons'),
      color: Color(json['colorValue']),
    );
  }

  static List<Category> predefinedCategories = [
    Category(
      name: 'Work',
      icon: Icons.work,
      color: Colors.blue,
    ),
    Category(
      name: 'Personal',
      icon: Icons.person,
      color: Colors.green,
    ),
    Category(
      name: 'Shopping',
      icon: Icons.shopping_cart,
      color: Colors.orange,
    ),
    Category(
      name: 'Health',
      icon: Icons.favorite,
      color: Colors.red,
    ),
    Category(
      name: 'Education',
      icon: Icons.school,
      color: Colors.purple,
    ),
    Category(
      name: 'Finance',
      icon: Icons.attach_money,
      color: Colors.indigo,
    ),
  ];

  static List<IconData> iconLibrary = [
    Icons.work_rounded,
    Icons.person_rounded,
    Icons.shopping_cart_rounded,
    Icons.favorite_rounded,
    Icons.school_rounded,
    Icons.attach_money_rounded,
    Icons.home_rounded,
    Icons.sports_rounded,
    Icons.book_rounded,
    Icons.restaurant_rounded,
    Icons.airplanemode_active_rounded,
    Icons.pets_rounded,
    Icons.music_note_rounded,
    Icons.movie_rounded,
    Icons.games_rounded,
    Icons.fitness_center_rounded,
    Icons.local_grocery_store_rounded,
    Icons.card_giftcard_rounded,
    Icons.celebration_rounded,
    Icons.park_rounded,
  ];

  List<Category> appendCustomCategories(List<Category> categories) {
    predefinedCategories.addAll(categories);
    return predefinedCategories;
  }
}

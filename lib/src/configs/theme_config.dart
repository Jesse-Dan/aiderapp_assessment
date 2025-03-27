import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.light);

  void toggleTheme() {
    if (state == ThemeMode.light) {
      state = ThemeMode.dark;
    } else {
      state = ThemeMode.light;
    }
  }

  ThemeMode getTheme() => state;
}

ThemeData get lightTheme => _lightTheme;

final ThemeData _lightTheme = ThemeData.light().copyWith(
  primaryTextTheme: GoogleFonts.sourceCodeProTextTheme(),
  primaryColor: Colors.black,
  textTheme: GoogleFonts.sourceCodeProTextTheme().apply(
    bodyColor: Colors.black,
    displayColor: Colors.black,
  ),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.white),
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Colors.black,
    textTheme: ButtonTextTheme.primary,
  ),
  elevatedButtonTheme: const ElevatedButtonThemeData(),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black),
    ),
    labelStyle: TextStyle(color: Colors.black),
  ),
  iconTheme: const IconThemeData(color: Colors.black),
  cardColor: Colors.white,
  dividerColor: Colors.black,
);

ThemeData get darkTheme => _darkTheme;

final ThemeData _darkTheme = ThemeData.dark().copyWith(
  primaryTextTheme: GoogleFonts.sourceCodeProTextTheme(),
  primaryColor: Colors.black,
  textTheme: GoogleFonts.sourceCodeProTextTheme().apply(
    bodyColor: Colors.white,
    displayColor: Colors.white,
  ),
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.white),
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Colors.black,
    textTheme: ButtonTextTheme.primary,
  ),
  elevatedButtonTheme: const ElevatedButtonThemeData(),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: Colors.black,
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
    labelStyle: TextStyle(color: Colors.white),
  ),
  iconTheme: const IconThemeData(color: Colors.white),
  cardColor: Colors.black,
  dividerColor: Colors.white,
);

Color useTheme(BuildContext context,
    {required Color lightColor, required Color darkColor}) {
  final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
  return isDarkTheme ? darkColor : lightColor;
}

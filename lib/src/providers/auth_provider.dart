import 'package:do_it_now/src/configs/route_config.dart';
import 'package:do_it_now/src/modules/auth/views/login/login.dart';
import 'package:do_it_now/src/modules/base/index.dart';
import 'package:do_it_now/src/resources/utils/show_loading.dart';
import 'package:do_it_now/src/resources/utils/show_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider = ChangeNotifierProvider((ref) {
  return AuthProvider.instance;
});

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static void initialize() {
    _instance = _instance ??= AuthProvider._();
  }

  static AuthProvider? _instance;

  AuthProvider._();

  static AuthProvider get instance => _instance!;

  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Register a new user
  Future<void> registerUser() async {
    try {
      showLoading("Registering...");
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await userCredential.user?.updateDisplayName(
        '${firstnameController.text.trim()} ${lastnameController.text.trim()}',
      );

      notifyListeners();
      showText("Registration successful!");
      Navigator.pushReplacementNamed(
          // ignore: use_build_context_synchronously
          navigatorKey.currentState!.context,
          AppIndex.routeName);
    } on FirebaseAuthException catch (e) {
      showText(e.message ?? 'An unknown error occurred.');
    } catch (e) {
      debugPrint('Error registering user: $e');
      showText('Error registering user.');
    } finally {
      cancelLoading();
    }
  }

  // Login user
  Future<void> loginUser() async {
    try {
      showLoading("Logging In...");
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      notifyListeners();
      Navigator.pushReplacementNamed(
          // ignore: use_build_context_synchronously
          navigatorKey.currentState!.context,
          AppIndex.routeName);
    } on FirebaseAuthException catch (e) {
      showText(e.message ?? 'An unknown error occurred.');
    } catch (e) {
      debugPrint('Error logging in: $e');
      showText('Error logging in.');
    } finally {
      cancelLoading();
    }
  }

  // Logout user
  Future<void> logoutUser() async {
    try {
      showLoading("Logging Out...");
      await _auth.signOut();

      notifyListeners();
      showText("Logout successful!");
      Navigator.pushReplacementNamed(
          // ignore: use_build_context_synchronously
          navigatorKey.currentState!.context,
          LoginView.routeName);
    } catch (e) {
      debugPrint('Error logging out: $e');
      showText('Error logging out.');
    } finally {
      cancelLoading();
    }
  }

  @override
  void dispose() {
    firstnameController.dispose();
    lastnameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

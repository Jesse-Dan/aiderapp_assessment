import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../modules/auth/views/login/login.dart';
import '../modules/auth/views/recover_account/recover_account.dart';
import '../modules/auth/views/register/register.dart';
import '../modules/base/index.dart';
import '../modules/base/views/home/home.dart';
import '../modules/base/views/focus/focus_view.dart';
import '../modules/base/views/home/views/create_task.dart';
import '../modules/base/views/home/views/task_detail.dart';
import '../modules/base/views/profile/profile.dart';
import '../modules/tasks/tasks.dart';
import '../resources/models/task.dart';
import '../resources/widgets/app_loading_indicator.dart';

final navigatorKey = GlobalKey<NavigatorState>();

final navigatorKeyProvider = Provider<GlobalKey<NavigatorState>>((ref) {
  return navigatorKey;
});

class RouteConfig {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppIndex.routeName:
        return MaterialPageRoute(builder: (_) => const AppIndex());
      case HomeView.routeName:
        return MaterialPageRoute(builder: (_) => const HomeView());
      case ProfileView.routeName:
        return MaterialPageRoute(builder: (_) => const ProfileView());
      case TaskView.routeName:
        return MaterialPageRoute(builder: (_) => const TaskView());
      case TaskDetailView.routeName:
        return MaterialPageRoute(
            builder: (_) => TaskDetailView(
                  task: settings.arguments as Task,
                ));
      case FocusView.routeName:
        return MaterialPageRoute(builder: (_) => const FocusView());
      case CreateTaskView.routeName:
        return MaterialPageRoute(builder: (_) => const CreateTaskView());
      case LoginView.routeName:
        return MaterialPageRoute(builder: (_) => const LoginView());
      case RegisterView.routeName:
        return MaterialPageRoute(builder: (_) => const RegisterView());
      case RecoverAccountView.routeName:
        return MaterialPageRoute(builder: (_) => const RecoverAccountView());

      default:
        return MaterialPageRoute(
          builder: (_) => StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                final user = snapshot.data;
                if (user == null) {
                  return const LoginView();
                } else {
                  return const AppIndex();
                }
              }
              return const Scaffold(
                body: Center(child: AppLoadingIndicator()),
              );
            },
          ),
        );
    }
  }
}

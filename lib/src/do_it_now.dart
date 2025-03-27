import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../mains/common.dart';
import 'configs/route_config.dart';
import 'configs/theme_config.dart';
import 'services/initializer.dart';

class DoItNowApp extends ConsumerStatefulWidget {
  const DoItNowApp({super.key});

  @override
  ConsumerState<DoItNowApp> createState() => _DoItNowState();
}

class _DoItNowState extends ConsumerState<DoItNowApp> {
  @override
  void initState() {
    super.initState();

    final appService = ref.read(initProvider);
    appService.pullUserData();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final config = ref.read(flavorConfigProvider);
    final navigatorKey = ref.watch(navigatorKeyProvider);

    return MaterialApp(
      title: config.appTitle,
      theme: config.themeData,
      darkTheme: config.darkThemeData,
      themeMode: themeMode,
      navigatorObservers: [BotToastNavigatorObserver()],
      navigatorKey: navigatorKey,
      onGenerateRoute: RouteConfig.generateRoute,
      builder: (context, child) {
        final botToastBuilder = BotToastInit();
        child = botToastBuilder(context, child);
        return child;
      },
    );
  }
}

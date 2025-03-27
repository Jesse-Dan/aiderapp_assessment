import 'package:do_it_now/src/do_it_now.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../src/services/initializer.dart';
import 'flavour_config.dart';

late StateProvider<FlavorConfig> flavorConfigProvider;

void mainCommon(FlavorConfig config) async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    await Initializer.bootstrapDoItNowApp(config);

    runApp(
      const ProviderScope(child: DoItNowApp()),
    );
  } catch (e) {
    debugPrint("An error occurred: $e");
  }
}

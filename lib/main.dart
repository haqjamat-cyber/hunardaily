import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hunardaily/app.dart';
import 'package:hunardaily/data/local/prefs_service.dart';
import 'package:hunardaily/features/settings/app_settings_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        prefsServiceProvider.overrideWithValue(
          PrefsService(sharedPreferences),
        ),
      ],
      child: const HunarDailyApp(),
    ),
  );
}

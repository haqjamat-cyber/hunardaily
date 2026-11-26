import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hunardaily/app.dart';
import 'package:hunardaily/data/local/prefs_service.dart';
import 'package:hunardaily/features/settings/app_settings_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpApp(WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          prefsServiceProvider.overrideWithValue(PrefsService(prefs)),
        ],
        child: const HunarDailyApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'switches dynamically between English LTR and Urdu RTL across all 4 tabs',
    (tester) async {
      await pumpApp(tester);

      // Default is English LTR
      expect(find.text('Welcome to HunarDaily'), findsOneWidget);
      final initialDirection = Directionality.of(
        tester.element(find.text('Home')),
      );
      expect(initialDirection, TextDirection.ltr);

      // Scroll Home ListView so the language chip is centered and hittable
      await tester.drag(find.byType(ListView), const Offset(0, -300));
      await tester.pumpAndSettle();

      final urduChip = find.byKey(const ValueKey<String>('home_lang_ur'));
      await tester.ensureVisible(urduChip);
      await tester.pumpAndSettle();
      await tester.tap(urduChip);
      await tester.pumpAndSettle();

      // Navigation bar updates to Urdu and entire app flips to RTL
      expect(find.text('ہوم'), findsOneWidget);
      final rtlDirection = Directionality.of(
        tester.element(find.text('ہوم')),
      );
      expect(rtlDirection, TextDirection.rtl);

      // Navigate across Courses, Practice, and Profile tabs in RTL mode
      await tester.tap(find.text('کورسز'));
      await tester.pumpAndSettle();
      expect(find.text('انگلش الفاظ'), findsOneWidget);

      await tester.tap(find.text('مشق'));
      await tester.pumpAndSettle();
      expect(find.text('مشق کا مرکز'), findsOneWidget);

      await tester.tap(find.text('پروفائل'));
      await tester.pumpAndSettle();
      expect(find.text('پروفائل اور سیٹنگز'), findsOneWidget);
    },
  );
}

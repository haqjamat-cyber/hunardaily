# HunarDaily (Phase 2 — Module 1)

**HunarDaily** is an offline-first, privacy-respecting multilingual learning and personal development Android application built with **Flutter + Riverpod + SQLite (`sqflite`)**.

- **Android Application ID:** `com.hunardaily.app`
- **Cost & Privacy (v1):** ₹0 cloud cost, 100% offline Guest Mode, zero personal data collection, zero tracking, zero ads.
- **Interface Languages:** English (`en`), Hindi (`hi`), Urdu (`ur` — full RTL), Bengali (`bn`) — designed to expand cleanly to Arabic (`ar`), Turkish (`tr`), and more.
- **Theme:** Light Theme (Teal/Emerald + Warm Off-White) and Dark Theme (Dark Slate + Bright Teal).

---

## What Is Included in Phase 2 — Module 1

- Complete GitHub-ready Flutter project & clean feature-first folder architecture.
- Android Gradle (Kotlin DSL) build configuration with `com.hunardaily.app`, `supportsRtl="true"`, and zero unnecessary device permissions.
- GitHub Actions workflow (`.github/workflows/android-build.yml`) that automatically runs `flutter analyze`, `flutter test`, and builds both **Debug APK** and **Release APK** artifacts.
- Separation of **App Interface Language** (`en`, `hi`, `ur`, `bn`) from **Course Learning Pair** (`hi_to_en`, `ur_to_en`, `bn_to_en`).
- Accessible in-app reading text scale (`Small` to `Extra Large`) with script-aware line heights (extra vertical spacing for Urdu) and bidirectional LTR/RTL rendering.
- Transparent **Local Storage Notice** informing users that offline guest data is stored only on their device.
- Automated unit and widget tests (`test/`).

---

## Project Structure

```text
hunardaily/
├── .github/workflows/android-build.yml  # Automated analyze, test & APK build
├── android/                             # Complete Android config (com.hunardaily.app)
├── lib/
│   ├── main.dart                        # App bootstrap & ProviderScope
│   ├── app.dart                         # MaterialApp, dynamic Locale, RTL & Theme
│   ├── core/
│   │   ├── config/                      # App constants & future feature flags
│   │   ├── localization/                # UiLanguage, LearningPair & FontScalePreset
│   │   └── theme/                       # Teal/Off-White Light & Dark Slate themes
│   ├── data/local/                      # SharedPreferences service & SQLite config
│   ├── l10n/                            # ARB sources & type-safe 4-language localizations
│   └── features/                        # Home, Courses, Practice, Settings & 4-tab Shell
├── scripts/download_fonts.sh            # Optional open-source Noto font downloader
└── test/                                # Unit & Widget tests (RTL, Theme, Settings)
```

---

## Build Android APK Automatically on GitHub (No PC Required)

1. Create a new repository on GitHub (public or private).
2. Extract `hunardaily_phase2_module1.zip` and upload all files inside `hunardaily/` to the root of your repository (so `pubspec.yaml`, `.github/`, `android/`, `lib/`, and `test/` are at the top level).
3. Push to the `main` branch (or open the **Actions** tab → **HunarDaily Android CI & APK Build** → **Run workflow**).
4. GitHub Actions will automatically run:
   - `flutter pub get`
   - `flutter analyze`
   - `flutter test`
   - `flutter build apk --debug`
   - `flutter build apk --release`
5. Once the workflow turns green, scroll down to **Artifacts** and download **`hunardaily-debug-apk`** (or **`hunardaily-release-apk`**) to install on your Android phone.

---

## Local Setup & Commands (PC / Laptop with Flutter SDK)

### Prerequisites
- Flutter SDK (Stable channel, Dart 3.4+)
- JDK 17 + Android SDK (via Android Studio or Android Command-Line Tools)

### Run & Test Locally
```bash
# 1. Install packages
flutter pub get

# 2. Check for static analysis / lint issues
flutter analyze

# 3. Run all unit and widget tests
flutter test

# 4. Run on a connected Android device or emulator
flutter run

# 5. Build an Android APK locally
flutter build apk --debug
```

*(Note: Because `gradle-wrapper.jar` is excluded from Git by standard `.gitignore` hygiene, if your local machine asks for `gradlew`, run `cd android && gradle wrapper --gradle-version 8.11.1` once — GitHub Actions handles this automatically.)*

---

## Local Data Limitation Notice

In v1, HunarDaily stores user preferences and upcoming learning progress **100% locally on the phone** with no cloud account. If a user uninstalls the app, clears app data, or switches phones, local data is erased. Future phases are architected via repository abstractions and `AppFeatureFlags` so optional cloud sync, accounts, and Admin CMS can be added cleanly later.

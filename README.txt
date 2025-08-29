# Adit Astro (Flutter)

This is a **demo** app for:
- Creating a Kundli by taking Name, DOB, Birth Place, Time
- Kundali Milan (name-based demo scoring)
- Feedback form to report issues
- Multi-language UI (Hindi default, English available)
- Upay & Vidhi suggestions (demo) based on approximate sun sign from DOB

> ⚠️ Disclaimer: Real Vedic astrology requires precise planetary positions (Moon sign, Nakshatra, etc.).
> This code uses simplified placeholders. Integrate a proper SDK/API for production.

## Quick Start

1. Install Flutter (3.19+ recommended) and Android Studio / SDK tools.
2. In a terminal:
   ```bash
   flutter create adit_astro
   cd adit_astro
   ```
3. Replace the generated files with the ones in this package:
   - Overwrite `pubspec.yaml`
   - Create/overwrite `lib/main.dart`
4. Fetch dependencies:
   ```bash
   flutter pub get
   ```
5. Run on device/emulator:
   ```bash
   flutter run
   ```
6. Build a release APK:
   ```bash
   flutter build apk --release
   ```
   The APK will be at `build/app/outputs/flutter-apk/app-release.apk`.

## Next Steps (Production)

- Replace demo astrology with a real engine (e.g., integrate an API providing Panchang, Janam Kundli, Ashtakoot Milan).
- Add place lookup & timezone conversion via a maps/geocoding service.
- Persist feedback to a backend (Firebase/REST) or email.
- Add more languages by extending the `Strings` map or using ARB localization.
- Implement proper North/ South Indian chart drawing and dasha/bhava tables.

# Smart Attendance (IEM) - Ready to Build Flutter Project

This is a **ready-to-build** Flutter project skeleton for the *Smart Attendance* app (Institute of Engineering & Management - IEM).  
It includes login (students/teachers/admin), QR generation (teacher), QR scanning (student), transaction-safe attendance writes, and single-device login logic.  

## Important: Firebase Setup (placeholders)
This repository **does not include** your Firebase configuration files (google-services.json / GoogleService-Info.plist) or `firebase_options.dart`.
You must provide them:

1. Create a Firebase project at https://console.firebase.google.com/
2. Enable **Authentication (Email/Password)** and **Firestore**.
3. Install and configure FlutterFire locally:
   - Install FlutterFire CLI: `dart pub global activate flutterfire_cli`
   - From project root run: `flutterfire configure`
   - This will generate `lib/firebase_options.dart` (required).
4. Place `google-services.json` in `android/app/` and `GoogleService-Info.plist` in `ios/Runner/` if you plan to build for those platforms.

## Build APK (on your machine)
1. Unzip this package.
2. In project root: `flutter pub get`
3. (Optional) Run the app in debug: `flutter run`
4. Build release APK:
   ```
   flutter build apk --release
   ```
   The final APK will be at:
   `build/app/outputs/flutter-apk/app-release.apk`

## Notes
- This skeleton uses placeholders and simple UI. It is intended as a solid starting point.
- Security rules should be added in Firebase Console before going to production.
- See source files under `lib/` for where to add your Firebase config.


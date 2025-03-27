# Flutter App Setup Guide

This guide helps you install Flutter and run Flutter applications on your local machine.

## 📦 Prerequisites

- A computer running **Windows**, **macOS**, or **Linux**
- **Git** installed
- Basic knowledge of using the terminal or command line

## 🛠️ Step 1: Install Flutter

### Windows

1. Download the Flutter SDK:  
   [https://flutter.dev/docs/get-started/install/windows](https://flutter.dev/docs/get-started/install/windows)

2. Extract the zip file and place it in a desired location (e.g. `C:\src\flutter`).

3. Add Flutter to your PATH:
   - Open **System Properties > Environment Variables**
   - Add `C:\src\flutter\bin` to the `Path` variable

### macOS

```bash
brew install --cask flutter
```

Or download manually from: [https://flutter.dev/docs/get-started/install/macos](https://flutter.dev/docs/get-started/install/macos)

### Linux

```bash
sudo snap install flutter --classic
```

Or follow the manual steps: [https://flutter.dev/docs/get-started/install/linux](https://flutter.dev/docs/get-started/install/linux)

---

## 🔍 Step 2: Check Your Setup

```bash
flutter doctor
```

This command checks your environment and shows what’s missing (e.g., Android Studio, emulator, etc).

---

## 📱 Step 3: Set Up an Emulator or Physical Device

- Install **Android Studio** or **Xcode** (for iOS development).
- Open Android Studio and create an emulator (AVD).
- OR connect a real device with USB debugging enabled.

---

## 🚀 Step 4: Run Your App

Navigate to your Flutter project folder:

```bash
cd your_flutter_project
```

Run the app:

```bash
flutter run
```

To build the app for release:

```bash
flutter build apk        # For Android
flutter build ios        # For iOS (macOS only)
```

---

## 🧪 Optional: Hot Reload

Use `r` in the terminal during `flutter run` to **hot reload** after making changes to your code.

---

## 🧼 Troubleshooting

- Run `flutter clean` if you face build issues.
- Use `flutter pub get` to fetch missing dependencies.
- Make sure Android licenses are accepted:

```bash
flutter doctor --android-licenses
```

---

## 📚 Resources

- Official Docs: [https://flutter.dev/docs](https://flutter.dev/docs)
- Widget Catalog: [https://flutter.dev/widgets](https://flutter.dev/widgets)

---

Happy Coding! 🎯

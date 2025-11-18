# Kinli – Baby Tracker App (Flutter + Dart)

## Overview
Kinli is a cross-platform baby tracking app built using **Flutter + Dart**, supporting:
- iOS / Android (mobile)
- Web (Flutter Web)

Kinli helps track:
- Feeding (breast/bottle)
- Sleep sessions
- Diapers (wet/dirty)
- Growth (weight/height/head circumference)
- Pumping sessions

🔥 Kinli uses **Firebase** as its backend to handle authentication, data storage, and real‑time synchronization. 
Firebase is Google’s Backend‑as‑a‑Service (BaaS) platform, which saves development time by providing secure, scalable infrastructure out of the box (so we don’t have to set up servers).

Examples:
- Feeding logs → Stored in Firestore, instantly synced across devices. 
- Baby profiles → Managed with Firebase Authentication. 
- Growth charts → Data saved in Firestore, visualized in the app. 
- Photos/notes → Uploaded to Firebase Storage.

flutter pub add firebase_core firebas
---
## Architecture

```
kinli/
 ├─ android/
 ├─ ios/
 ├─ web/
 ├─ assets/
 │   └─ lang/
 │        ├─ en.arb
 │        ├─ de.arb
 │        └─ ar.arb
 ├─ lib/
 │   ├─ main.dart
 │   ├─ app.dart
 │   ├─ core/
 │   │    ├─ constants/
 │   │    │    └─ app_constants.dart
 │   │    ├─ utils/
 │   │    │    └─ date_utils.dart
 │   │    ├─ errors/
 │   │    │    └─ app_errors.dart
 │   │    └─ services/
 │   │         └─ firebase_service.dart
 │   ├─ data/
 │   │    ├─ models/
 │   │    │    ├─ feeding_entry.dart
 │   │    │    ├─ sleep_entry.dart
 │   │    │    ├─ diaper_entry.dart
 │   │    │    ├─ growth_entry.dart
 │   │    │    └─ pumping_entry.dart
 │   │    ├─ repositories/
 │   │    │    ├─ feeding_repository.dart
 │   │    │    ├─ sleep_repository.dart
 │   │    │    ├─ diaper_repository.dart
 │   │    │    ├─ growth_repository.dart
 │   │    │    └─ pumping_repository.dart
 │   │    └─ local/
 │   │         └─ local_storage.dart
 │   ├─ features/
 │   │    ├─ feeding/
 │   │    │    ├─ view/
 │   │    │    │    ├─ feeding_screen.dart
 │   │    │    │    └─ feeding_list.dart
 │   │    │    ├─ controller/
 │   │    │    │    └─ feeding_controller.dart
 │   │    │    └─ feeding_repository.dart
 │   │    ├─ sleep/
 │   │    │    ├─ view/
 │   │    │    │    ├─ sleep_screen.dart
 │   │    │    │    └─ sleep_list.dart
 │   │    │    ├─ controller/
 │   │    │    │    └─ sleep_controller.dart
 │   │    │    └─ sleep_repository.dart
 │   │    ├─ diaper/
 │   │    │    ├─ view/
 │   │    │    │    ├─ diaper_screen.dart
 │   │    │    │    └─ diaper_list.dart
 │   │    │    ├─ controller/
 │   │    │    │    └─ diaper_controller.dart
 │   │    │    └─ diaper_repository.dart
 │   │    ├─ growth/
 │   │    │    ├─ view/
 │   │    │    │    ├─ growth_screen.dart
 │   │    │    │    └─ growth_chart.dart
 │   │    │    ├─ controller/
 │   │    │    │    └─ growth_controller.dart
 │   │    │    └─ growth_repository.dart
 │   │    └─ pumping/
 │   │         ├─ view/
 │   │         │    ├─ pumping_screen.dart
 │   │         │    └─ pumping_list.dart
 │   │         ├─ controller/
 │   │         │    └─ pumping_controller.dart
 │   │         └─ pumping_repository.dart
 │   ├─ widgets/
 │   │    ├─ custom_button.dart
 │   │    └─ chart_widget.dart
 │   └─ theme/
 │        ├─ app_theme.dart
 │        └─ colors.dart
 ├─ pubspec.yaml
 └─ README.md
```
`main.dart`:
- Entry point of the app.
- boots the app.
- Contains void main() and calls runApp(MyApp()). 
- Sets up global configuration (themes, localization, Firebase initialization).

`models/`:
- structure the data
- Dart classes that represent your data structures:
  - For Kinli: Feeding, SleepLog, GrowthEntry, Pumping. 
  - These define fields (e.g., time, amount, notes) and include toJson() / fromJson() for Firestore.

`services/`:
- talk to Firebase (Firestore/Auth).
- Handle data access. 
  - Example: feeding_repository.dart talks to Firebase Firestore, fetches feeding logs, and saves new ones.

`screens/`
- show UI and call services when data is needed.
- Each app screen (e.g., Feeding Tracker, Sleep Tracker, Growth Chart, Settings). 
- Built with Flutter widgets (Scaffold, AppBar, ListView, etc.).

`widgets/`:
- Reusable UI components. 
- make the UI modular and reusable
- Example: a custom LogCard widget that shows feeding/sleep info in a nice card layout.

`localization/`:
- YAML/ARB files or Dart helpers for English, German, Arabic translations.

`utils/`:
- Small utility functions (e.g., date formatting, validation, constants).

🎯 For Kinli spec
---
## Data Model Example

```dart
class FeedingEntry {
  final String id;
  final DateTime time;
  final double amountOz;
  final String type; // "breast" or "bottle"

  FeedingEntry({
    required this.id,
    required this.time,
    required this.amountOz,
    required this.type,
  });

  Map<String, dynamic> toMap() => {
    "id": id,
    "time": time.toIso8601String(),
    "amountOz": amountOz,
    "type": type,
  };

  factory FeedingEntry.fromMap(String id, Map<String, dynamic> map) {
    return FeedingEntry(
      id: id,
      time: DateTime.parse(map["time"]),
      amountOz: map["amountOz"],
      type: map["type"],
    );
  }
}
```

---
## Repository Example (Firestore)

```dart
class FeedingRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addFeeding(FeedingEntry entry, String babyId) async {
    await _db.collection("babies/$babyId/feeding").add(entry.toMap());
  }

  Stream<List<FeedingEntry>> getFeedingLogs(String babyId) {
    return _db
      .collection("babies/$babyId/feeding")
      .orderBy("time", descending: true)
      .snapshots()
      .map((query) =>
        query.docs.map(
          (doc) => FeedingEntry.fromMap(doc.id, doc.data()),
        ).toList()
      );
  }
}
```

---
## Firebase Structure

```
/users/{userId}/babies/{babyId}/logs/feeding
/users/{userId}/babies/{babyId}/logs/sleep
/users/{userId}/babies/{babyId}/logs/diaper
/users/{userId}/babies/{babyId}/growth
```

---
## Navigation Flow

```
HomeScreen
 ├── FeedingScreen
 ├── SleepScreen
 ├── DiaperScreen
 ├── GrowthScreen
 └── PumpingScreen
```

Bottom Navigation Tabs:
```
Feeding | Sleep | Diaper | Growth | More
```

---
## State Management
Recommended: **Riverpod** (lightweight and scalable)
It is a modern, safe, and testable framework that makes it easy to manage app state and dependencies across the widget tree.
Alternative: Provider (simpler)

### Why Riverpod for Kinli?
- **Clean separation of logic and UI** → Feeding, sleep, and growth logs are managed as state, while screens just display them. 
- **Scalability** → As Kinli grows (multi‑language, more features), Riverpod keeps state predictable and organized. 
- **Testability** → You can easily write unit tests for your repositories and providers. 
- **Performance** → Reduces unnecessary widget rebuilds, making the app smoother.
---
## Why Flutter + Dart
- Single codebase for mobile + web
- UI + business logic shared 100%
- Firebase + Flutter = fast backend setup


---
## Getting Started
1. Install Flutter SDK
2. Install Android Studio or IntelliJ IDEA
3. Install Flutter/Dart plugins
4. Run:

```
flutter doctor
flutter create baby_tracker
flutter run
```




# 💼 Job Tracker

A production-grade Flutter mobile application for tracking job applications — built with strict Clean Architecture, hybrid state management, automated testing, and CI/CD.

---

## 🛠 Tech Stack

| Category | Technology |
|----------|-----------|
| Framework | Flutter & Dart |
| State Management | BLoC + Riverpod (Hybrid) |
| Architecture | Clean Architecture |
| Local Storage | Hive |
| Navigation | GoRouter |
| Testing | flutter_test, BlocTest, Mocktail |
| CI/CD | GitHub Actions |
| ID Generation | UUID v4 |
| Equality | Equatable |

---

## 🏗 Architecture

This project follows strict **Clean Architecture** with three fully separated layers:

```
lib/
├── core/                          # Shared utilities
│   ├── constants/app_colors.dart  # Design system colors
│   └── router/app_router.dart     # Centralized navigation
│
├── domain/                        # Pure Dart — zero dependencies
│   ├── entities/                  # Core business objects
│   ├── repositories/              # Abstract contracts
│   └── usecases/                  # Business logic (one class, one job)
│
├── data/                          # Depends on domain only
│   ├── models/                    # Entities + JSON conversion
│   ├── datasources/               # Hive operations
│   └── repositories/              # Repository implementations
│
└── presentation/                  # Depends on domain only
    ├── bloc/                      # Events, States, BLoC
    ├── pages/                     # Full screens
    └── widgets/                   # Reusable components
```

**Dependency Rule:** Dependencies only point inward.
- Presentation → Domain
- Data → Domain
- Domain → Nothing

---

## ✨ Features

- ✅ Add, edit, and delete job applications
- ✅ Track application status — Applied, Interview, Offer, Rejected
- ✅ Dynamic color-coded status badges
- ✅ Optional notes per application
- ✅ Persistent local storage with Hive
- ✅ Full loading, error, and empty states
- ✅ Retry mechanism on error
- ✅ Input validation with SnackBar feedback
- ✅ Responsive UI with SingleChildScrollView
- ✅ Global error handling — FlutterError.onError + ErrorWidget.builder

---

## 🧪 Testing

14 tests covering all layers:

```
test/
├── domain/usecases/
│   └── get_jobs_usecase_test.dart     # Use case unit tests
├── data/repositories/
│   └── job_repository_impl_test.dart  # Repository unit tests
└── presentation/bloc/
    └── job_bloc_test.dart             # BLoC tests (BlocTest)
```

Run all tests:

```bash
flutter test
```

---

## ⚙️ CI/CD Pipeline

Every push to `main` automatically:

1. ✅ Installs Flutter
2. ✅ Runs `flutter pub get`
3. ✅ Runs all 14 tests — pipeline stops if any fail
4. ✅ Builds release APK
5. ✅ Uploads APK as downloadable artifact

---

## 🚀 How to Run

**Prerequisites:**
- Flutter SDK installed
- Android emulator or physical device

**Steps:**

```bash
# Clone the repository
git clone https://github.com/thefortune-tech/job-tracker.git
cd job-tracker

# Install dependencies
flutter pub get

# Run the app
flutter run

# Run tests
flutter test
```

---

## 📁 Key Design Decisions

**Why Clean Architecture?**
Separation of concerns — the UI never knows about Hive, the domain never knows about Flutter. Each layer is independently testable and replaceable.

**Why Hybrid State Management (BLoC + Riverpod)?**
BLoC handles complex event-driven flows with full traceability. Riverpod handles simpler reactive state with less boilerplate. Each used where it fits best.

**Why Manual Dependency Injection?**
Explicit and transparent. Every dependency is visible in main.dart — no magic, no hidden wiring. Easier to understand, easier to test.

**Why UUID over DateTime for IDs?**
DateTime milliseconds can collide on fast devices or in tests. UUID v4 generates 122 bits of randomness — collision is effectively impossible.

**Why Equatable on States and Entities?**
BlocTest compares states by value not by reference. Equatable makes JobLoading() == JobLoading() return true — essential for reliable tests.

---

## 👨‍💻 Author

**Adeyemi Fortune Adeboye**
Flutter Mobile Developer | Clean Architecture | BLoC · Riverpod · Firebase

- 🌐 [Portfolio](https://thefortune-tech.github.io/portfolio-web/)
- 💻 [GitHub](https://github.com/thefortune-tech)
- 🎥 [YouTube](https://youtube.com/@Fortune_Dev)

---

## 📄 License

All Rights Reserved © 2026 Adeyemi Fortune Adeboye
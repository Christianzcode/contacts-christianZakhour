# contacts_app

This is a Flutter application that manages a list of contacts with offline-first architecture, local caching, and change history tracking.
It demonstrates real-world patterns like stale-while-revalidate data fetching, pending sync queue for offline CRUD, and Last Write Wins conflict resolution.

## Getting Started

Features
Contacts CRUD – Create, edit, delete contacts with validation.
Offline support – All data cached locally (sqflite/Hive). Changes are queued when offline and synced when online.
Remote sync – Fetches users from JSONPlaceholder and keeps local DB in sync.
Change history – Every update/delete is logged with before/after diffs and shown per contact.
Search & pull-to-refresh – Local search by name/email, swipe down to refresh from API.
UI states – Loading, error, empty, content; with retry and cached fallback.


lib/
│── app.dart                 // App root & providers
│── core/                    // utils, network, config
│── data/                    // data sources (local + remote)
│   ├── dto/                 // Data Transfer Objects (JSON)
│   ├── local/               // DAOs for sqflite/Hive
│   ├── remote/              // API clients (Dio)
│   ├── repository/          // Implementation of repositories
│   └── mappers/             // DTO ↔ Entity converters
│── domain/                  // business rules (pure Dart)
│   ├── entities/            // core models (Contact, ChangeRecord)
│   ├── repositories/        // abstract repo contracts
│   └── usecases/            // application use cases (UpsertContact, DeleteContact, etc.)
│── presentation/            // UI & state management
│   ├── blocs/               // BLoC / Cubit state logic
│   ├── screens/             // Flutter pages
│   └── widgets/             // reusable components

how to run my app
git clone https://github.com/Christianzcode/contacts-christianZakhour.git
cd contacts-christianZakhour

flutter pub get

flutter pub run build_runner build --delete-conflicting-outputs

flutter run


apk link
https://we.tl/t-l4Np4jMX0M
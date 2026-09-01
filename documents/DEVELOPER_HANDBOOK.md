# 📘 Caregiver App: Comprehensive Developer Handbook

Welcome to the **Caregiver Partner Mobile Application** project (Phase 11 v2). This handbook is your ultimate guide to understanding the architecture, UI flow, state management, API integration, and local setup of the project.

---

## 1. Executive Summary & Project Overview
The Caregiver App is designed for healthcare professionals (caregivers, nurses) providing in-home patient care. It acts as their primary operational tool to:
* View their daily schedule and assigned patients.
* Navigate to patient locations with GPS verification (Check-In/Check-Out).
* Perform clinical assessments (Vitals, Mood, Mobility).
* Log medication compliance and clinical notes.
* Report emergencies and communicate with family/dispatch.

---

## 2. High-Level Architecture & Tech Stack

This project strictly adheres to **Clean Architecture** principles and a **Feature-First** directory structure.

### Core Technologies
* **Framework**: Flutter (`^3.12.1`)
* **Language**: Dart
* **State Management**: Riverpod (`flutter_riverpod`, `riverpod_annotation`). We use code generation for Providers to ensure type safety and ease of use.
* **Routing**: GoRouter (`go_router`). Handles nested navigation (`StatefulShellRoute`), deep linking, and guard redirects (Auth guards).
* **Networking**: Dio (`dio`). Used for robust HTTP requests, configured with global interceptors for token injection, logging, and error handling.
* **Local Storage / DB**: 
  * `drift` & `sqlite3_flutter_libs` for robust offline-first SQL database capabilities.
  * `flutter_secure_storage` for storing JWT tokens and sensitive user data.
  * `shared_preferences` for lightweight UI states and app preferences.
* **UI/UX**: Material Design 3 (`uses-material-design: true`), SVG Support (`flutter_svg`), FlChart for analytics.
* **Background & Native**: `workmanager` (Background tasks), `geolocator` (GPS Heartbeats), `firebase_messaging` (FCM Push Notifications).

---

## 3. Folder Structure & Clean Architecture Implementation

The `lib/` directory is split into two primary domains: `core` and `features`.

```text
lib/
├── core/                   # ➔ Shared utilities, configurations, and core logic
│   ├── analytics/          # Firebase Analytics, Crashlytics wrappers
│   ├── config/             # Environment configs (Dev, Staging, Prod)
│   ├── network/            # Dio client, API interceptors, error handling models
│   ├── router/             # GoRouter configuration (`app_router.dart`)
│   ├── storage/            # Local storage interfaces and Drift DB schemas
│   ├── theme/              # App colors, typography, and MaterialThemeData
│   └── widgets/            # Reusable UI components (Buttons, Cards, Modals)
│
├── features/               # ➔ Feature-First Architecture Modules
│   ├── auth/               # Login, Token Management
│   ├── emergency/          # Emergency protocols and reporting
│   ├── home/               # The main Dashboard, recent activities
│   ├── patients/           # Patient directory, medical profiles, trends
│   ├── visit_workflow/     # The 12-Step clinical visit lifecycle (Core Logic)
│   └── workspace/          # HR, Attendance, Profile, Settings
│
├── main.dart               # ➔ Default entry point
├── main_dev.dart           # ➔ Dev environment entry point
└── main_prod.dart          # ➔ Prod environment entry point
```

### Data Flow (Repository Pattern)
1. **API / Storage (Data Source)**: Fetches data using `Dio` or reads from `Drift`.
2. **Repository**: Abstracts the data source. Maps raw JSON/DB models to Domain Entities.
3. **Notifier / Controller (Riverpod)**: Holds the business logic and exposes state (e.g., `AsyncValue<Visit>`) to the UI.
4. **UI (Screen / Widget)**: Watches the provider (`ref.watch`) and rebuilds on state changes.

---

## 4. Detailed UI & Navigation Flow

The app utilizes a **4-Tab Navigation** system at its core.

### 4.1 The Application Shell (4-Tabs)
Controlled by `StatefulShellRoute` in `app_router.dart`:
1. **🏠 Home (`/home`)**: Operations Dashboard. Shows the active/next visit hero card, daily progress, notifications, and quick action hubs.
2. **🩺 Visits (`/visits`)**: Deep link to the currently active or upcoming visit workflow.
3. **🚨 Emergency (`/emergency`)**: Quick access to report medical or situational emergencies.
4. **💼 Workspace (`/workspace`)**: Caregiver profile, settings, HR tasks, schedule, and attendance.

### 4.2 The Visit Workflow (12-Step Lifecycle)
Located in `features/visit_workflow/`, this is the most critical flow of the app. It must be followed sequentially.

1. **Visit Details (`/visits`)**: Displays patient info, risks, and the "Start Navigation" button.
2. **Live Route Navigation (`/visits/navigate`)**: Map view showing route to patient. Caregiver taps "I've Arrived".
3. **Arrival & Check-In (`/visits/check-in`)**: App verifies location via GPS Geofence (50 meters).
4. **Care Assessment (`/visits/assessment`)**: Logs Patient Mood, General Wellbeing, and Mobility.
5. **Vitals Capture (`/visits/assessment/blood-pressure`)**: Logs BP, HR, SpO2, Temp, Sugar, Weight.
   * *Edge Case*: If severe vitals are entered (e.g., BP 220/130), the app pushes to **Critical Vital Alert (`/visits/critical-alert`)**.
6. **Medicine Compliance (`/visits/assessment/completion`)**: Checks off meds, adds clinical notes, and captures photos.
7. **Review Visit (`/visits/review`)**: Shows a summary of all entered data.
8. **Submit Confirmation (`/visits/submit/confirmation`)**: Confirms submission to backend.
9. **GPS Check-Out (`/visits/checkout`)**: Verifies caregiver is still on-site.
10. **Visit Completed (`/visits/completed`)**: Success screen, redirects to Home.

---

## 5. API & Network Integration

All networking is routed through `Dio` configured in `lib/core/network/api_client.dart`.

### Environments
* **Dev**: `https://api-dev.parentcare.app`
* **Prod**: `https://api.parentcare.app`

### Universal Headers
Every authorized request automatically includes:
* `Authorization: Bearer <jwt_token>` (Injected via Interceptor).
* `X-Client-Version`, `X-Device-Id`, `X-Device-Timezone`.

### Critical Endpoints (Examples)
1. **Master Dashboard Aggregator**:
   `GET /api/v1/home/dashboard`
   * Fetches caregiver profile, active visit, daily schedule, and care intelligence in a *single roundtrip* to ensure fast startup.
2. **GPS Heartbeat**:
   `POST /api/v1/home/location/heartbeat`
   * Payload: `{ "latitude": 18.5, "longitude": 73.8, "batteryLevel": 85 }`
   * Sent every 30-60 seconds in the background when on duty for safety and live ETAs.
3. **Offline Delta Sync**:
   `GET /api/v1/home/sync`
   * Uses `If-Modified-Since` headers to fetch only what changed since the app last went offline.

---

## 6. Real-time Features & Background Tasks

### WebSockets & Firebase Cloud Messaging (FCM)
* **WebSockets**: Connected when the app is in the foreground. Listens for `SCHEDULE_MODIFIED` or `EMERGENCY_ALERT` events to dynamically update the UI without pull-to-refresh.
* **FCM Push Notifications**: Used for critical alerts when the app is in the background or killed. Tapping a notification routes directly to the relevant screen using GoRouter deep linking.

### Offline Resilience Strategy
If the caregiver enters a dead-zone (no internet):
1. Reads are served from the SQLite (`drift`) cache.
2. Writes (e.g., saving vitals) are stored locally as "Pending Sync" operations.
3. Upon reconnection, a background sync worker flushes pending operations and calls the Delta Sync API.

---

## 7. Developer Onboarding & Local Setup

### Pre-requisites
1. **Flutter SDK**: Ensure you are on `^3.12.1`.
2. **IDE**: VS Code or Android Studio with Flutter/Dart plugins installed.

### Setup Steps
1. Clone the repository and run:
   ```bash
   flutter pub get
   ```
2. **Run Code Generation** (Crucial step for Riverpod, Freezed, and JSON Serializable):
   ```bash
   dart run build_runner build -d
   ```
   *You must run this whenever you modify a file containing `@riverpod`, `@freezed`, or `@JsonSerializable` annotations.*
3. **Run the App** (Using flavors):
   ```bash
   flutter run -t lib/main_dev.dart
   ```

### Coding Conventions
* Always use `ConsumerWidget` or `ConsumerStatefulWidget` instead of `StatefulWidget` to access `WidgetRef`.
* Do not make direct HTTP calls from the UI. Use a Repository.
* Place UI components specific to a feature inside `features/<name>/presentation/widgets/`. 
* Place globally reusable UI components inside `core/widgets/`.

---
*Happy Coding! Refer to `HOME_MODULE_APIS_REQUIREMENTS.md` and `HOME_AND_VISIT_MODULE_FLOW.md` in the `documents/` folder for deeper granular details.*

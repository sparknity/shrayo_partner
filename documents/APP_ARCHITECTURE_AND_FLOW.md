# Caregiver App - Architecture & App Flow Documentation

Welcome to the Caregiver App project! This document is designed to help new Flutter developers understand the project structure, architecture, technology stack, and user flow of the application.

## 1. Technology Stack
The application is built using modern Flutter development practices. Here are the key technologies and packages used:
- **Framework**: Flutter (`^3.12.1`)
- **State Management**: Riverpod (`flutter_riverpod`, `riverpod_annotation`)
- **Routing**: GoRouter (`go_router`)
- **Networking**: Dio (`dio`)
- **Local Storage**: Secure Storage (`flutter_secure_storage`), Shared Preferences (`shared_preferences`), and Drift/SQLite (`drift`, `sqlite3_flutter_libs`) for local database.
- **UI/Styling**: Material Design 3 (`uses-material-design: true`), SVG support (`flutter_svg`), Cached Network Images (`cached_network_image`), and FlChart (`fl_chart`).
- **Other Key Integrations**: Firebase (Crashlytics, Messaging), Google Maps & Geolocator, Permissions, Workmanager (background tasks), FreeRASP (security).

## 2. Project Directory Structure
The project follows a modular, feature-based architecture pattern.

```
lib/
├── core/                   # Core application configurations and utilities
│   ├── analytics/          # Analytics integration
│   ├── config/             # App configuration / Env variables
│   ├── deeplink/           # Deep linking logic
│   ├── network/            # Dio client setup, interceptors
│   ├── router/             # GoRouter configuration and AppShell
│   ├── storage/            # Local storage implementations
│   ├── theme/              # App themes, colors, typography
│   └── ...                 # Other utilities (security, push, sync, widgets)
├── features/               # Feature modules
│   ├── auth/               # Authentication (Login)
│   ├── emergency/          # Emergency handling flow
│   ├── home/               # Dashboard and home screen
│   ├── patients/           # Patient directory, medical profiles
│   ├── visit_workflow/     # The core visit lifecycle (Check-in -> Assessment -> Submit -> Checkout)
│   ├── workspace/          # User profile, attendance, settings, etc.
│   └── ...                 # Other features (daily_logs, notifications, support, protocol_library)
├── main.dart               # App entry point
└── main_*.dart             # Environment specific entry points (dev, staging, prod)
```

## 3. App Routing & Navigation Flow (GoRouter)

The application uses `go_router` for robust navigation, primarily configured in `lib/core/router/app_router.dart`. 

### The Application Shell
After successful login, the app uses a **4-Tab `StatefulShellRoute`** layout (`AppShell`):
1. **Home (`/home`)**: The main dashboard. From here, users can navigate to Notifications, Patient Directories, Logs, Protocol Libraries, and Support.
2. **Visits (`/visits`)**: The core operational tab for the caregiver to manage their current or upcoming visit.
3. **Emergency (`/emergency`)**: Quick access to report and handle patient emergencies.
4. **Workspace (`/workspace`)**: The caregiver's profile, settings, schedule, tasks, attendance, and training center.

### Core User Flows

#### A. Authentication Flow
- **Pre-auth**: The app launches at `AppRoutes.login` (`/login`).
- **Auth state changes**: `appRouterProvider` listens to `authProvider` and `activeVisitProvider`. If `authProvider.isAuthenticated` is false, it redirects to `/login`. Upon successful authentication, it redirects to the requested deep link or defaults to `/home`.

#### B. Visit Workflow (The Core Feature)
Located in `features/visit_workflow/`, this is a multi-step sequential flow for completing a care visit:
1. **Navigation**: `/visits/navigate` (Live Route Navigation)
2. **Check-In**: `/visits/check-in` (GPS verified check-in)
3. **Assessment**: `/visits/assessment` -> `/visits/assessment/blood-pressure` -> `/visits/assessment/completion`
4. **Review & Submit**: `/visits/review` -> `/visits/submit` -> `/visits/submit/requirements` -> `/visits/submit/confirmation`
5. **Check-Out**: `/visits/checkout` -> `/visits/checkout/confirm` -> `/visits/completed`
*Exceptions handled*: Patient not available, Critical vital alerts.

#### C. Emergency Flow
Located in `features/emergency/`, this flow handles critical situations:
1. **Report**: `/emergency/medical`
2. **Analyze**: `/emergency/analyze`
3. **Action**: `/emergency/start-response` -> Active Emergency tracking.

#### D. Patient Management
Accessible mostly from the Home tab (`features/patients/`):
- Patient Directory (`/patients`) -> Patient Overview (`/patients/:id`)
- Deep dive sections: Medical Profile, Medicines, Health Timeline/Trends, Documents, Emergency Info.

#### E. Workspace & HR Features
Accessible from the Workspace tab (`features/workspace/`):
- Profile management (Professional Info, Emergency Contacts)
- Attendance and Scheduling
- Tasks and Document viewing
- Leave requests, Performance reviews, Settings (Privacy/Security, Help).

## 4. State Management (Riverpod)
- The app uses `flutter_riverpod` with `riverpod_annotation` (code generation).
- Providers are scoped by feature (e.g., `authProvider`, `activeVisitProvider`).
- **Data flow**: Typically follows a Repository -> Controller/Notifier -> UI architecture. 
- You will often see `ref.watch()` used in `ConsumerWidget` or `ConsumerStatefulWidget` to rebuild UI when state changes.

## 5. Getting Started for New Developers
1. **Run Code Generation**: Since the project uses Riverpod annotations and potentially Freezed/JsonSerializable, run `dart run build_runner build -d` to generate necessary `.g.dart` files.
2. **Review Routing**: Familiarize yourself with `app_router.dart` and the 4 `StatefulShellBranch` configs.
3. **Check core configurations**: Look into `lib/core/network` to see how API calls are constructed with Dio interceptors. Look at `lib/core/theme` for styling guidelines.
4. **Main Entry Points**: The app provides `main_dev.dart`, `main_staging.dart`, and `main_prod.dart`. Run the app using flavors/targets (e.g., `flutter run -t lib/main_dev.dart`).

## 6. Conventions
- **Feature-First Architecture**: Always place code inside its respective feature folder. Only shareable code goes into `core`.
- **UI Components**: Common widgets (buttons, text fields, cards) should be placed in `core/widgets/` to maintain consistency.
- **State**: Complex state goes into Notifier Providers. Local widget state can use standard `setState` or `hooks` (if used).

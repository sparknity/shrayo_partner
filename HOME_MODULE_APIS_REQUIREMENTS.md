# 🏠 Home Module API Requirements & Technical Specification
**Caregiver Partner Mobile Application (Phase 11 v2)**  
*Document Version: 2.0.0 | Status: Approved for Implementation*

---

## 📑 Table of Contents
1. [Executive Overview & Architecture](#-executive-overview--architecture)
2. [Global Network Standards & Security](#-global-network-standards--security)
3. [Home Module Master Architecture Diagram](#-home-module-master-architecture-diagram)
4. [Master Aggregated Dashboard API](#-1-master-aggregated-dashboard-api)
5. [Granular Home Sub-Resource APIs](#-2-granular-home-sub-resource-apis)
   - [2.1 Caregiver Profile & Shift Status](#21-caregiver-profile--shift-status)
   - [2.2 Update Shift Status](#22-update-shift-status)
   - [2.3 Daily Progress & Performance Metrics](#23-daily-progress--performance-metrics)
   - [2.4 Current / Active Visit Hero](#24-current--active-visit-hero)
   - [2.5 Quick Action Hub Counters](#25-quick-action-hub-counters)
   - [2.6 Recent Activity Stream](#26-recent-activity-stream)
   - [2.7 Upcoming Daily Schedule](#27-upcoming-daily-schedule)
   - [2.8 Care Intelligence & Clinical Briefings](#28-care-intelligence--clinical-briefings)
   - [2.9 Caregiver GPS Location Heartbeat](#29-caregiver-gps-location-heartbeat)
   - [2.10 Home Offline Delta Synchronization](#210-home-offline-delta-synchronization)
6. [Real-Time WebSocket & Push Notification Protocols](#-real-time-websocket--push-notification-protocols)
7. [Offline Caching & Resilience Strategy](#-offline-caching--resilience-strategy)
8. [Data Models & Schema Definitions](#-data-models--schema-definitions)
9. [Frontend Riverpod & Clean Architecture Contract](#-frontend-riverpod--clean-architecture-contract)

---

## 📌 Executive Overview & Architecture

The **Home Module (Tab 0 - Operations Dashboard)** acts as the central command center for the caregiver on shift. It provides immediate situational awareness, active visit triggers, upcoming schedule timelines, daily progress tracking, AI-driven care intelligence briefings, and rapid shortcuts to auxiliary modules (Patients, Logs, Protocols, Support).

### High-Level API Design Goals:
1. **Low Latency & High Responsiveness**: Provide an aggregated master endpoint (`GET /api/v1/home/dashboard`) so the app can populate the entire UI with a single roundtrip during app startup or pull-to-refresh.
2. **Granular Polling/Selective Refresh**: Provide modular endpoints for lightweight background refreshes (e.g., refreshing only the activity feed or progress indicator).
3. **Resilience & Offline-First Support**: Support delta sync headers (`If-None-Match`, `X-Last-Sync-Timestamp`) and robust caching in local SQLite.
4. **Real-time Event Integration**: Support WebSocket/FCM push updates to reactively update the dashboard when visits are reassigned, family messages arrive, or critical vital alerts occur.

---

## 🔒 Global Network Standards & Security

### 1. Environments & Base URLs
| Environment | Base URL |
| :--- | :--- |
| **Development** | `https://api-dev.parentcare.app` |
| **Staging** | `https://api-staging.parentcare.app` |
| **Production** | `https://api.parentcare.app` |

### 2. Authentication & Authorization
All Home Module endpoints require standard HTTP Bearer token authentication via the `Authorization` header:
```http
Authorization: Bearer <jwt_access_token>
```
* **Token Lifetime**: 15 minutes (Refreshed automatically via Refresh Token rotation).
* **Required Scope**: `caregiver:operations`, `visits:read`, `patient:read_summary`.

### 3. Universal Request Headers
| Header Name | Type | Mandatory | Description / Example |
| :--- | :--- | :---: | :--- |
| `Authorization` | `String` | **Yes** | `Bearer eyJhbGciOi...` |
| `Content-Type` | `String` | **Yes** | `application/json; charset=utf-8` |
| `Accept` | `String` | **Yes** | `application/json` |
| `X-Request-Id` | `String` | **Yes** | UUIDv4 for distributed tracing (e.g. `c73a215e-998f-4d32-9c12-32a3915bc821`) |
| `X-Client-Version` | `String` | **Yes** | App version (e.g. `2.4.0 (112)`) |
| `X-Device-Id` | `String` | **Yes** | Unique hardware device identifier |
| `X-Device-Timezone` | `String` | **Yes** | IANA Timezone (e.g. `Asia/Kolkata`) |
| `X-Device-Location` | `String` | Optional | Current coordinates `lat,lng` (e.g. `18.5204,73.8567`) |
| `X-Idempotency-Key` | `String` | Conditional | Required for mutating operations (`POST`, `PATCH`, `PUT`) |

### 4. Standard Response Formats

#### Success Envelope (`200 OK` / `201 Created`)
```json
{
  "success": true,
  "timestamp": "2026-08-20T10:30:00.000Z",
  "requestId": "c73a215e-998f-4d32-9c12-32a3915bc821",
  "data": { ... }
}
```

#### Standard Error Envelope (`4xx` / `5xx`)
```json
{
  "success": false,
  "timestamp": "2026-08-20T10:30:00.000Z",
  "requestId": "c73a215e-998f-4d32-9c12-32a3915bc821",
  "error": {
    "code": "RESOURCE_NOT_FOUND",
    "message": "The requested visit was not found or has been reassigned.",
    "details": [
      {
        "field": "visitId",
        "issue": "Invalid ID format or visit no longer assigned to caregiver"
      }
    ]
  }
}
```

---

## 🗺️ Home Module Master Architecture Diagram

```mermaid
sequenceDiagram
    autonumber
    actor Caregiver as 📱 Caregiver Partner App
    participant Gateway as 🚪 API Gateway / Auth
    participant HomeSvc as 🏠 Home Aggregator Service
    participant VisitSvc as 🩺 Visit Workflow Service
    participant PatientSvc as 👥 Patient Service
    participant IntelEngine as 🧠 Care Intelligence Engine
    participant PushSvc as 🔔 Realtime Notification Hub

    Note over Caregiver,Gateway: App Launch / Foreground Resume
    Caregiver->>Gateway: GET /api/v1/home/dashboard (Headers: Bearer, Lat/Lng)
    Gateway->>Gateway: Validate JWT & Scopes
    Gateway->>HomeSvc: Aggregate Dashboard Request(caregiverId, timezone)
    
    par Parallel Data Retrieval
        HomeSvc->>VisitSvc: Fetch Active Visit & Today's Schedule
        HomeSvc->>PatientSvc: Fetch Patient Health Tags & Risk Scores
        HomeSvc->>IntelEngine: Fetch Contextual Patient Briefing
        HomeSvc->>PushSvc: Fetch Unread Counts & Recent Activity
    end

    HomeSvc-->>Gateway: Combined Dashboard Response
    Gateway-->>Caregiver: 200 OK (JSON Master Payload)
    Caregiver->>Caregiver: Store in SQLite Cache & Render UI

    opt Realtime Push Update (e.g. Schedule Change or Alert)
        PushSvc-->>Caregiver: WebSocket Event / FCM: 'SCHEDULE_UPDATED'
        Caregiver->>Gateway: GET /api/v1/home/upcoming-schedule
        Gateway-->>Caregiver: 200 OK (Updated Timeline)
    end
```

---

## 🚀 1. Master Aggregated Dashboard API

### `GET /api/v1/home/dashboard`
**Purpose**: Primary landing endpoint called when the application opens or when the caregiver initiates a pull-to-refresh on Tab 0. Aggregates all dashboard sub-sections in a single network roundtrip.

* **Method**: `GET`
* **Route**: `/api/v1/home/dashboard`
* **Cache-Control**: `private, max-age=30, stale-while-revalidate=60`

#### Query Parameters:
| Parameter | Type | Required | Default | Description |
| :--- | :--- | :---: | :---: | :--- |
| `date` | `String (YYYY-MM-DD)` | No | Today | Date for which schedule and progress are requested |
| `latitude` | `Float` | No | - | Current caregiver latitude for live distance calculation |
| `longitude` | `Float` | No | - | Current caregiver longitude for live distance calculation |

#### Sample Request:
```http
GET /api/v1/home/dashboard?date=2026-08-20&latitude=18.5529&longitude=73.9532 HTTP/1.1
Host: api.parentcare.app
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI...
X-Request-Id: 7b844e1c-5d18-4796-98dc-1e07b8b4b1a4
X-Client-Version: 2.4.0
Accept: application/json
```

#### Sample Response (`200 OK`):
```json
{
  "success": true,
  "timestamp": "2026-08-20T08:30:00.000Z",
  "requestId": "7b844e1c-5d18-4796-98dc-1e07b8b4b1a4",
  "data": {
    "caregiver": {
      "id": "cg-8821",
      "firstName": "Anita",
      "lastName": "Deshmukh",
      "role": "Senior Clinical Caregiver",
      "avatarUrl": "https://cdn.parentcare.app/avatars/cg-8821.jpg",
      "shiftStatus": "ACTIVE",
      "shiftStartTime": "2026-08-20T08:00:00.000Z",
      "currentDateFormatted": "MON, OCT 26",
      "unreadNotificationCount": 3,
      "hasCriticalAlerts": true
    },
    "dailyProgress": {
      "totalVisits": 6,
      "completedVisits": 2,
      "inProgressVisits": 1,
      "pendingVisits": 3,
      "completionPercentage": 33.33,
      "formattedProgressText": "33% Complete",
      "hoursWorked": 2.5,
      "targetHours": 8.0
    },
    "currentVisit": {
      "id": "v-101",
      "patientId": "p-1004",
      "patientName": "Sunita Patil",
      "patientAge": 78,
      "patientGender": "Female",
      "avatarUrl": "https://cdn.parentcare.app/patients/p-1004.jpg",
      "riskLevel": "HIGH_RISK",
      "riskBadgeColor": "#E11D48",
      "scheduledTime": "10:30 AM",
      "scheduledTimeSlot": "10:30 AM - 11:30 AM",
      "scheduledStartTime": "2026-08-20T10:30:00.000Z",
      "scheduledEndTime": "2026-08-20T11:30:00.000Z",
      "status": "SCHEDULED",
      "sessionStage": "IDLE",
      "careType": "Routine Check & Vital Monitoring",
      "location": {
        "address": "Flat 402, Ganga Carnation, Koregaon Park, Pune",
        "zoneName": "Pune West",
        "latitude": 18.5362,
        "longitude": 73.8958,
        "distanceKm": 2.3,
        "distanceFormatted": "2.3km Away",
        "travelTimeMinutes": 12,
        "travelInfoFormatted": "12m via Route A"
      },
      "healthTags": [
        { "id": "ht-1", "label": "#Diabetic", "color": "#16A34A" },
        { "id": "ht-2", "label": "#Mobility", "color": "#0284C7" },
        { "id": "ht-3", "label": "#HighFallRisk", "color": "#DC2626" }
      ],
      "actions": {
        "canStartSession": true,
        "canResumeSession": false,
        "canNavigate": true,
        "directPhoneParent": "+919822011223",
        "directPhoneFamily": "+919822099887"
      }
    },
    "quickActions": {
      "patientDirectoryCount": 12,
      "dailyLogsCount": 18,
      "activeProtocolsCount": 24,
      "supportTicketsPending": 0
    },
    "recentActivities": [
      {
        "id": "act-501",
        "type": "VISIT_COMPLETED",
        "title": "Morning Visit Completed",
        "subtitle": "Patient: David Smith",
        "timePill": "08:45 AM",
        "timestamp": "2026-08-20T08:45:00.000Z",
        "iconType": "CHECK",
        "iconBg": "#DCFCE7",
        "iconColor": "#16A34A",
        "referenceId": "v-099"
      },
      {
        "id": "act-502",
        "type": "FAMILY_NOTIFICATION_SENT",
        "title": "Family Notification Sent",
        "subtitle": "Automated status report successfully delivered to Sarah Smith.",
        "timePill": null,
        "timestamp": "2026-08-20T08:46:12.000Z",
        "iconType": "MAIL",
        "iconBg": "#E0F2FE",
        "iconColor": "#0284C7",
        "referenceId": "notif-902"
      }
    ],
    "upcomingSchedule": [
      {
        "id": "sch-201",
        "visitId": "v-102",
        "type": "PATIENT_VISIT",
        "timeFormatted": "12:00 PM",
        "scheduledStartTime": "2026-08-20T12:00:00.000Z",
        "badgeText": "IN 1H 15M",
        "title": "Ramesh Joshi",
        "subtitle": "Medication Support",
        "icon": "LINK",
        "isHighlighted": true,
        "isDashed": false,
        "status": "PENDING"
      },
      {
        "id": "sch-202",
        "visitId": "v-103",
        "type": "PATIENT_VISIT",
        "timeFormatted": "03:30 PM",
        "scheduledStartTime": "2026-08-20T15:30:00.000Z",
        "badgeText": null,
        "title": "Lata Kulkarni",
        "subtitle": "Follow-up Visit",
        "icon": "MEDICAL_SERVICES",
        "isHighlighted": false,
        "isDashed": false,
        "status": "PENDING"
      },
      {
        "id": "sch-203",
        "visitId": null,
        "type": "SHIFT_HANDOVER",
        "timeFormatted": "05:15 PM",
        "scheduledStartTime": "2026-08-20T17:15:00.000Z",
        "badgeText": null,
        "title": "Shift Handover",
        "subtitle": "Review daily logs with supervisor",
        "icon": null,
        "isHighlighted": false,
        "isDashed": true,
        "status": "SCHEDULED"
      }
    ],
    "careIntelligence": {
      "id": "ci-9041",
      "patientId": "p-1004",
      "category": "BEHAVIORAL_INSIGHT",
      "headline": "CARE INTELLIGENCE",
      "message": "Mrs. Patil responds best to low-stimulus instructions during morning rounds. Speak softly and maintain eye contact.",
      "priority": "HIGH",
      "generatedAt": "2026-08-20T07:00:00.000Z"
    }
  }
}
```

---

## 🛠️ 2. Granular Home Sub-Resource APIs

### 2.1 Caregiver Profile & Shift Status
#### `GET /api/v1/home/profile`
**Purpose**: Fetch the logged-in caregiver's profile summary, shift status, and notification counter for the app header.

* **Method**: `GET`
* **Route**: `/api/v1/home/profile`

#### Response (`200 OK`):
```json
{
  "success": true,
  "data": {
    "id": "cg-8821",
    "name": "Anita Deshmukh",
    "firstName": "Anita",
    "avatarUrl": "https://cdn.parentcare.app/avatars/cg-8821.jpg",
    "role": "Senior Clinical Caregiver",
    "zone": "Pune West",
    "shiftStatus": "ACTIVE",
    "shiftStartedAt": "2026-08-20T08:00:00.000Z",
    "notifications": {
      "unreadCount": 3,
      "hasCriticalAlert": true,
      "lastAlertId": "notif-991"
    }
  }
}
```

---

### 2.2 Update Shift Status
#### `PATCH /api/v1/home/shift-status`
**Purpose**: Update the caregiver's active duty state (`ACTIVE`, `ON_BREAK`, `OFF_DUTY`, `EMERGENCY_LEAVE`).

* **Method**: `PATCH`
* **Route**: `/api/v1/home/shift-status`
* **Headers**: Requires `X-Idempotency-Key`

#### Request Body:
```json
{
  "shiftStatus": "ON_BREAK",
  "reason": "Scheduled 30-minute lunch break",
  "currentLocation": {
    "latitude": 18.5362,
    "longitude": 73.8958
  }
}
```

#### Validation Rules:
| Field | Type | Required | Validation Rules |
| :--- | :--- | :---: | :--- |
| `shiftStatus` | `String` | **Yes** | Enum: `ACTIVE`, `ON_BREAK`, `OFF_DUTY`, `EMERGENCY_LEAVE` |
| `reason` | `String` | Optional | Max 250 characters |
| `currentLocation` | `Object` | **Yes** | Must include valid `latitude` (-90 to +90) and `longitude` (-180 to +180) |

#### Response (`200 OK`):
```json
{
  "success": true,
  "data": {
    "caregiverId": "cg-8821",
    "shiftStatus": "ON_BREAK",
    "updatedAt": "2026-08-20T13:00:00.000Z",
    "breakEndTimeEstimated": "2026-08-20T13:30:00.000Z"
  }
}
```

---

### 2.3 Daily Progress & Performance Metrics
#### `GET /api/v1/home/daily-progress`
**Purpose**: Supplies real-time progress calculations for the daily visit progress bar.

* **Method**: `GET`
* **Route**: `/api/v1/home/daily-progress`
* **Query Parameters**: `date` (`YYYY-MM-DD`, optional, defaults to today)

#### Response (`200 OK`):
```json
{
  "success": true,
  "data": {
    "date": "2026-08-20",
    "totalAssignedVisits": 6,
    "completedVisits": 2,
    "inProgressVisits": 1,
    "pendingVisits": 3,
    "cancelledVisits": 0,
    "completionRate": 0.3333,
    "progressPercentage": 33,
    "totalLoggedHours": 2.5,
    "targetHours": 8.0,
    "vitalsLoggedCount": 8,
    "medicationsAdministeredCount": 4
  }
}
```

---

### 2.4 Current / Active Visit Hero
#### `GET /api/v1/home/current-visit`
**Purpose**: Returns the most immediate actionable visit (the visit currently in progress or the next scheduled visit on the caregiver's route).

* **Method**: `GET`
* **Route**: `/api/v1/home/current-visit`
* **Query Parameters**: `latitude`, `longitude` (optional, for live travel calculation)

#### Response (`200 OK`):
```json
{
  "success": true,
  "data": {
    "id": "v-101",
    "patientId": "p-1004",
    "patientName": "Sunita Patil",
    "patientAge": 78,
    "gender": "Female",
    "avatarUrl": "https://cdn.parentcare.app/patients/p-1004.jpg",
    "scheduledTime": "10:30 AM",
    "scheduledEndTime": "11:30 AM",
    "timeRemaining": "In 45 minutes",
    "riskLevel": "HIGH_RISK",
    "careType": "Routine Wellness & Vital Monitoring",
    "address": {
      "street": "Flat 402, Ganga Carnation, Lane 5",
      "area": "Koregaon Park",
      "city": "Pune",
      "state": "Maharashtra",
      "pincode": "411001",
      "zone": "Pune West",
      "latitude": 18.5362,
      "longitude": 73.8958
    },
    "travelInfo": {
      "distanceMeters": 2300,
      "distanceText": "2.3km Away",
      "durationSeconds": 720,
      "durationText": "12m via Route A",
      "trafficCondition": "CLEAR"
    },
    "healthTags": [
      { "id": "tag-1", "name": "Diabetic", "tagCode": "#Diabetic", "color": "#16A34A" },
      { "id": "tag-2", "name": "Mobility Support", "tagCode": "#Mobility", "color": "#0284C7" }
    ],
    "previousVisitSummary": {
      "caregiverName": "Nurse Priya",
      "date": "2026-08-19",
      "notesSnippet": "Patient reported slight morning dizziness. Vitals were BP 130/85."
    },
    "sessionState": {
      "status": "SCHEDULED",
      "canStart": true,
      "isLate": false
    }
  }
}
```

---

### 2.5 Quick Action Hub Counters
#### `GET /api/v1/home/quick-stats`
**Purpose**: Returns badge count metadata for the 4-Grid Navigation cards on the Home Screen.

* **Method**: `GET`
* **Route**: `/api/v1/home/quick-stats`

#### Response (`200 OK`):
```json
{
  "success": true,
  "data": {
    "patients": {
      "totalAssigned": 12,
      "highRiskCount": 3,
      "badgeText": "12 Patients"
    },
    "dailyLogs": {
      "totalLogsToday": 2,
      "pendingReview": 0,
      "badgeText": "2 Logged"
    },
    "protocols": {
      "totalAvailable": 45,
      "recentlyUpdated": 3,
      "badgeText": "Clinical SOPs"
    },
    "support": {
      "activeTickets": 0,
      "helplineAvailable": true,
      "supervisorOnDuty": "Dr. Rajesh Sharma"
    }
  }
}
```

---

### 2.6 Recent Activity Stream
#### `GET /api/v1/home/recent-activities`
**Purpose**: Paginated list of today's caregiver events, logs, family alerts, and visit milestones.

* **Method**: `GET`
* **Route**: `/api/v1/home/recent-activities`

#### Query Parameters:
| Parameter | Type | Required | Default | Description |
| :--- | :--- | :---: | :---: | :--- |
| `page` | `Integer` | No | `1` | Page number |
| `limit` | `Integer` | No | `10` | Number of activities per page |
| `filter` | `String` | No | `ALL` | `ALL`, `VISITS`, `NOTIFICATIONS`, `VITALS`, `EMERGENCY` |

#### Response (`200 OK`):
```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": "act-501",
        "type": "VISIT_COMPLETED",
        "category": "VISITS",
        "title": "Morning Visit Completed",
        "subtitle": "Patient: David Smith",
        "timePill": "08:45 AM",
        "timestamp": "2026-08-20T08:45:00.000Z",
        "icon": "CHECK",
        "iconBg": "#DCFCE7",
        "iconColor": "#16A34A",
        "metadata": {
          "patientId": "p-1002",
          "visitId": "v-099",
          "durationMinutes": 45
        }
      },
      {
        "id": "act-502",
        "type": "FAMILY_NOTIFICATION_SENT",
        "category": "NOTIFICATIONS",
        "title": "Family Notification Sent",
        "subtitle": "Automated status report successfully delivered to Sarah Smith.",
        "timePill": null,
        "timestamp": "2026-08-20T08:46:12.000Z",
        "icon": "MAIL",
        "iconBg": "#E0F2FE",
        "iconColor": "#0284C7",
        "metadata": {
          "recipientName": "Sarah Smith",
          "channel": "SMS_AND_APP"
        }
      }
    ],
    "pagination": {
      "currentPage": 1,
      "totalPages": 1,
      "totalItems": 2,
      "hasNextPage": false
    }
  }
}
```

---

### 2.7 Upcoming Daily Schedule
#### `GET /api/v1/home/upcoming-schedule`
**Purpose**: Returns the remaining timeline of visits, medication rounds, and administrative checkpoints for the day.

* **Method**: `GET`
* **Route**: `/api/v1/home/upcoming-schedule`
* **Query Parameters**: `filter` (`ALL`, `VISITS_ONLY`, `TASKS_ONLY`, default `ALL`)

#### Response (`200 OK`):
```json
{
  "success": true,
  "data": {
    "date": "2026-08-20",
    "timeline": [
      {
        "id": "sch-201",
        "visitId": "v-102",
        "itemType": "PATIENT_VISIT",
        "timeFormatted": "12:00 PM",
        "scheduledStartTime": "2026-08-20T12:00:00.000Z",
        "badgeText": "IN 1H 15M",
        "title": "Ramesh Joshi",
        "subtitle": "Medication Support",
        "icon": "LINK",
        "isHighlighted": true,
        "isDashed": false,
        "patientId": "p-1005",
        "status": "PENDING"
      },
      {
        "id": "sch-202",
        "visitId": "v-103",
        "itemType": "PATIENT_VISIT",
        "timeFormatted": "03:30 PM",
        "scheduledStartTime": "2026-08-20T15:30:00.000Z",
        "badgeText": null,
        "title": "Lata Kulkarni",
        "subtitle": "Follow-up Visit",
        "icon": "MEDICAL_SERVICES",
        "isHighlighted": false,
        "isDashed": false,
        "patientId": "p-1006",
        "status": "PENDING"
      },
      {
        "id": "sch-203",
        "visitId": null,
        "itemType": "OPERATIONAL_TASK",
        "timeFormatted": "05:15 PM",
        "scheduledStartTime": "2026-08-20T17:15:00.000Z",
        "badgeText": null,
        "title": "Shift Handover",
        "subtitle": "Submit physical log copies and debrief",
        "icon": null,
        "isHighlighted": false,
        "isDashed": true,
        "patientId": null,
        "status": "SCHEDULED"
      }
    ]
  }
}
```

---

### 2.8 Care Intelligence & Clinical Briefings
#### `GET /api/v1/home/care-intelligence`
**Purpose**: AI/Clinical engine insights tailored for the current upcoming patient based on past history, behavioral notes, and vitals trends.

* **Method**: `GET`
* **Route**: `/api/v1/home/care-intelligence`
* **Query Parameters**: `patientId` (optional)

#### Response (`200 OK`):
```json
{
  "success": true,
  "data": {
    "id": "ci-9041",
    "patientId": "p-1004",
    "patientName": "Sunita Patil",
    "category": "BEHAVIORAL_COMMUNICATION",
    "headline": "CARE INTELLIGENCE",
    "message": "Mrs. Patil responds best to low-stimulus instructions during morning rounds. Speak softly and maintain eye contact.",
    "severity": "INFO",
    "source": "AI_SYNTHESIS_AND_SUPERVISOR_NOTE",
    "confidenceScore": 0.94,
    "createdAt": "2026-08-20T07:00:00.000Z"
  }
}
```

#### `POST /api/v1/home/care-intelligence/:id/acknowledge`
**Purpose**: Acknowledge that the caregiver read the briefing.

* **Method**: `POST`
* **Route**: `/api/v1/home/care-intelligence/ci-9041/acknowledge`
* **Response (`200 OK`)**:
```json
{
  "success": true,
  "data": {
    "id": "ci-9041",
    "acknowledgedAt": "2026-08-20T10:15:00.000Z"
  }
}
```

---

### 2.9 Caregiver GPS Location Heartbeat
#### `POST /api/v1/home/location/heartbeat`
**Purpose**: Periodically transmitted by the mobile client (every 30–60 seconds while on duty) to calculate live ETAs for next visits, trigger automated arrival geofencing, and ensure field safety.

* **Method**: `POST`
* **Route**: `/api/v1/home/location/heartbeat`

#### Request Body:
```json
{
  "latitude": 18.536254,
  "longitude": 73.895842,
  "accuracyMeters": 4.5,
  "speedMps": 5.2,
  "headingDegrees": 184.2,
  "batteryLevel": 85,
  "isCharging": false,
  "recordedAt": "2026-08-20T10:28:10.000Z"
}
```

#### Response (`200 OK`):
```json
{
  "success": true,
  "data": {
    "recorded": true,
    "nextVisitDistanceMeters": 2150,
    "estimatedTravelMinutes": 11,
    "geofenceStatus": "APPROACHING"
  }
}
```

---

### 2.10 Home Offline Delta Synchronization
#### `GET /api/v1/home/sync`
**Purpose**: Allows the mobile client to synchronize all home data during offline-to-online transitions using delta markers.

* **Method**: `GET`
* **Route**: `/api/v1/home/sync`
* **Headers**: `If-Modified-Since` (Timestamp of last successful sync)

#### Query Parameters:
| Parameter | Type | Required | Description |
| :--- | :--- | :---: | :--- |
| `lastSyncTimestamp` | `ISO8601 String` | **Yes** | Example: `2026-08-20T07:30:00.000Z` |

#### Response (`200 OK` - With Changes):
```json
{
  "success": true,
  "timestamp": "2026-08-20T10:30:00.000Z",
  "data": {
    "hasUpdates": true,
    "updatedVisits": [ ... ],
    "updatedSchedule": [ ... ],
    "newActivities": [ ... ],
    "deletedVisitIds": []
  }
}
```
*If no changes occurred since `lastSyncTimestamp`, returns `304 Not Modified`.*

---

## ⚡ Real-Time WebSocket & Push Notification Protocols

When active on duty, the application establishes a secure WebSocket connection to receive instant operational dispatches.

### WebSocket Connection URL:
```
wss://api.parentcare.app/ws/v1/caregiver?token=<jwt_access_token>
```

### Event Message Payloads:

#### 1. Visit Schedule Modification (`SCHEDULE_MODIFIED`)
Triggered when dispatch or a supervisor re-assigns or changes visit times.
```json
{
  "event": "SCHEDULE_MODIFIED",
  "timestamp": "2026-08-20T09:45:00.000Z",
  "data": {
    "visitId": "v-102",
    "action": "RESCHEDULED",
    "oldTime": "01:00 PM",
    "newTime": "12:00 PM",
    "message": "Visit for Ramesh Joshi moved to 12:00 PM"
  }
}
```

#### 2. Critical Vital / Health Alert Broadcast (`CRITICAL_ALERT_BROADCAST`)
Triggered when high-risk threshold is reported on a patient assigned to the caregiver.
```json
{
  "event": "CRITICAL_ALERT_BROADCAST",
  "timestamp": "2026-08-20T09:50:00.000Z",
  "data": {
    "patientId": "p-1004",
    "patientName": "Sunita Patil",
    "alertType": "HYPERTENSIVE_CRISIS",
    "vitalSummary": "BP: 220/130 mmHg",
    "actionRequired": "VERIFY_MEDICATION"
  }
}
```

---

## 💾 Offline Caching & Resilience Strategy

1. **Local SQLite Storage**:
   - The master dashboard payload is cached locally in SQLite table `cached_home_dashboard`.
   - On cold start:
     1. Client loads and displays SQLite cached snapshot immediately (`< 50ms`).
     2. Background network call initiates `GET /api/v1/home/dashboard`.
     3. On response, UI updates smoothly without jarring content shifts.
2. **TTL & Cache Expiration**:
   - Master Dashboard Snapshot TTL: `15 minutes`.
   - In offline mode, the app displays a subtle offline indicator (`Last synced 10:15 AM`) and continues serving cached schedule items.

---

## 📦 Data Models & Schema Definitions

### JSON Schemas & Validation Table

| Entity Name | Required Fields | Optional Fields | Notes |
| :--- | :--- | :--- | :--- |
| `CaregiverProfile` | `id`, `firstName`, `lastName`, `shiftStatus` | `avatarUrl`, `role`, `unreadNotificationCount` | `shiftStatus`: `ACTIVE`, `ON_BREAK`, `OFF_DUTY`, `EMERGENCY_LEAVE` |
| `DailyProgress` | `totalVisits`, `completedVisits`, `completionPercentage` | `hoursWorked`, `targetHours` | `completionPercentage` float 0.0 to 100.0 |
| `CurrentVisitHero` | `id`, `patientId`, `patientName`, `scheduledTime`, `riskLevel` | `avatarUrl`, `healthTags`, `location`, `travelInfo` | Risk: `HIGH_RISK`, `MEDIUM_RISK`, `LOW_RISK` |
| `ActivityFeedItem` | `id`, `type`, `title`, `timestamp` | `subtitle`, `timePill`, `iconType`, `referenceId` | Types: `VISIT_COMPLETED`, `FAMILY_NOTIFICATION_SENT`, `ALERT_TRIGGERED` |
| `UpcomingScheduleItem`| `id`, `itemType`, `timeFormatted`, `title`, `isHighlighted` | `visitId`, `badgeText`, `subtitle`, `icon` | Types: `PATIENT_VISIT`, `SHIFT_HANDOVER`, `BREAK` |
| `CareIntelligence` | `id`, `headline`, `message`, `priority` | `patientId`, `category`, `createdAt` | Priority: `HIGH`, `MEDIUM`, `LOW` |

---

## 🏛️ Frontend Riverpod & Clean Architecture Contract

### 1. Domain Entities (`lib/features/home/domain/entities/home_models.dart`)
```dart
class HomeDashboardData {
  final CaregiverProfile caregiver;
  final DailyProgress dailyProgress;
  final CurrentVisitHero? currentVisit;
  final QuickActionCounts quickActions;
  final List<ActivityItem> recentActivities;
  final List<UpcomingScheduleItem> upcomingSchedule;
  final CareIntelligenceItem? careIntelligence;

  const HomeDashboardData({
    required this.caregiver,
    required this.dailyProgress,
    this.currentVisit,
    required this.quickActions,
    required this.recentActivities,
    required this.upcomingSchedule,
    this.careIntelligence,
  });
}
```

### 2. Repository Interface (`lib/features/home/domain/repositories/home_repository.dart`)
```dart
abstract class HomeRepository {
  Future<Result<HomeDashboardData>> getDashboardData({
    DateTime? date,
    double? latitude,
    double? longitude,
  });

  Future<Result<void>> updateShiftStatus({
    required ShiftStatus status,
    String? reason,
    required double latitude,
    required double longitude,
  });

  Future<Result<List<ActivityItem>>> getRecentActivities({
    int page = 1,
    int limit = 10,
    String? filter,
  });

  Future<Result<void>> sendLocationHeartbeat({
    required double latitude,
    required double longitude,
    required double accuracy,
  });
}
```

### 3. State Management (`lib/features/home/presentation/providers/home_provider.dart`)
```dart
final homeDashboardProvider = FutureProvider.autoDispose<HomeDashboardData>((ref) async {
  final repository = ref.watch(homeRepositoryProvider);
  final location = ref.watch(userLocationProvider);

  final result = await repository.getDashboardData(
    latitude: location?.latitude,
    longitude: location?.longitude,
  );

  return result.when(
    success: (data) => data,
    failure: (failure) => throw failure,
  );
});
```

---

## 🎯 Verification & Testing Matrix

| Scenario | HTTP / Method | Expected Status | Validation Criteria |
| :--- | :--- | :---: | :--- |
| **Normal Launch** | `GET /api/v1/home/dashboard` | `200 OK` | Valid JSON matching `HomeDashboardData` schema with all sub-objects populated. |
| **No Active Visits** | `GET /api/v1/home/dashboard` | `200 OK` | `currentVisit` is `null`, `upcomingSchedule` is empty array, progress is `0%`. |
| **Invalid Token** | `GET /api/v1/home/dashboard` | `401 Unauthorized` | Returns `UnauthorizedFailure` and redirects app to `/login`. |
| **Update Shift on Break** | `PATCH /api/v1/home/shift-status` | `200 OK` | Caregiver `shiftStatus` updates to `ON_BREAK` and UI badge updates instantly. |
| **Send Heartbeat** | `POST /api/v1/home/location/heartbeat` | `200 OK` | Server logs location and returns updated ETA/distance. |
| **Offline Cache Check** | Offline Network State | SQLite Cache | SQLite loads cached dashboard without network crash or blank screen. |

---

*Authored by: Mobile Architecture & Backend Engineering Team*  
*Document Ref: `PC-API-SPEC-HOME-v2.0`*

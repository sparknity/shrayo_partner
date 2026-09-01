 # Caregiver App --- Home Module UI & Flow Specification {#caregiver-app--home-module-ui--flow-specification}

## 1. Objective {#1-objective}

The Caregiver Home module should be the caregiver\'s daily operational
command center. It must be attractive, clean, responsive, fast, and
ready for future live caregiver tracking.

The design should not be only a collection of cards. The primary visit
area must be **state-driven** so the same UI can later support:

`ASSIGNED → ACCEPTED → ON_THE_WAY → ARRIVED → IN_PROGRESS → COMPLETED`
 
Excepti on states:

`REJECTED / CANCELLED / FAILED / NO_SHOW`

------------------------------------------------------------------------

## 2. Home Scope {#2-home-scope}

Focus only on:

1.  Operations Dashboard
2.  Notifications
3.  Notification Details
4.  My Patients
5.  Daily Visit Logs
6.  Clinical Protocols
7.  Caregiver Support Hub

Bottom navigation remains:

`Home | Visits | Emergency | Workspace`

------------------------------------------------------------------------

## 3. Recommended Home Flow {#3-recommended-home-flow}

``` text
Operations Dashboard
│
├── Notification Icon
│   └── Notifications
│       └── Notification Details
│
├── Daily Progress
│
├── Current / Next Visit
│   └── Visit Details
│
├── Quick Actions
│   ├── My Patients
│   ├── Daily Logs
│   ├── Clinical Protocols
│   └── Support
│
├── Upcoming Visits
├── Recent Activity
└── Care Intelligence
```

------------------------------------------------------------------------

# 4. Home Dashboard UI {#4-home-dashboard-ui}

## Header

Show:

-   Caregiver avatar
-   Caregiver name
-   Availability/status
-   Notification icon
-   Optional greeting

Example:

``` text
Good Morning, Anjali 👋
Ready for today's care?

● Available                         🔔
```

Possible status values:

-   Available
-   On Visit
-   On Break
-   Offline

Keep status compact.

------------------------------------------------------------------------

# 5. Daily Progress {#5-daily-progress}

The caregiver should immediately understand today\'s workload.

``` text
Today's Progress

2 of 6 visits completed

██████░░░░ 33%

2 Completed   1 Ongoing   3 Upcoming
```

Required data:

-   totalVisits
-   completedVisits
-   ongoingVisits
-   upcomingVisits
-   progressPercentage

Do not mix visit completion with task completion.

------------------------------------------------------------------------

# 6. Primary Current Visit Card {#6-primary-current-visit-card}

This is the most important Home component.

## Assigned

``` text
CURRENT VISIT

Mrs. Sunita Patil
10:30 AM
High Risk

📍 Pune West

[Accept Visit]
[View Visit]
```

## Accepted

``` text
UPCOMING VISIT

Mrs. Sunita Patil
10:30 AM

📍 Pune West
Home Care Visit

[Start Navigation]
[View Visit]
```

## On The Way

``` text
ON THE WAY

Mrs. Sunita Patil

📍 Pune West
🚗 2.3 km away
ETA 12 min

[Open Route]
[View Visit]
```

## Arrived

``` text
ARRIVAL

You are near the patient's location.

Distance: 80 m

[Confirm Arrival]
```

## Visit In Progress

``` text
VISIT IN PROGRESS

Mrs. Sunita Patil

Started 10:31 AM
Duration 42 min

[Continue Visit]
```

## Completed

``` text
VISIT COMPLETED

Mrs. Sunita Patil
10:30 AM – 11:32 AM

Care tasks completed
Visit report submitted

[View Summary]
```

### Important naming rule

Use **Start Visit**, not **Start Session**.

Navigation and visit actions should be separate.

------------------------------------------------------------------------

# 7. Quick Actions {#7-quick-actions}

Recommended:

``` text
┌──────────────┐  ┌──────────────┐
│ 👤           │  │ 📋           │
│ My Patients  │  │ Daily Logs   │
└──────────────┘  └──────────────┘

┌──────────────┐  ┌──────────────┐
│ 📖           │  │ 🆘           │
│ Protocols    │  │ Support      │
└──────────────┘  └──────────────┘
```

### My Patients

If caregivers only access assigned patients, use **My Patients** rather
than a general Patient Directory.

Do not show caregiver actions such as:

-   Add Resident
-   New Admission
-   Administrative patient creation

Those belong to admin/operations roles.

------------------------------------------------------------------------

# 8. Upcoming Visits {#8-upcoming-visits}

Show only the next 2--3 visits on Home.

``` text
Upcoming Visits                         View All

10:30 AM   Mrs. Sunita Patil
           Pune West
           High Risk

12:00 PM   Mr. Ramesh Joshi
           Kothrud
           Stable

03:30 PM   Mrs. Lata Kulkarni
           Bavdhan
           Follow-up
```

Home should remain a dashboard, not a full visit-management screen.

------------------------------------------------------------------------

# 9. Recent Activity {#9-recent-activity}

Show meaningful events only:

-   Visit completed
-   Medication recorded
-   Protocol updated
-   Supervisor message
-   Important patient event

Example:

``` text
✓ Visit completed
Mrs. Patil • 11:32 AM

✓ Medication recorded
Mr. Joshi • 10:15 AM

⚠ Protocol updated
Medication Administration • 9:40 AM
```

Avoid low-value system events.

------------------------------------------------------------------------

# 10. Care Intelligence {#10-care-intelligence}

Keep this section, but initially treat it as an informational care tip.

``` text
CARE INTELLIGENCE

Care Tip

Mrs. Patil responds best to
low-stimulus instructions.

Based on the current care plan.

[View Care Plan]
```

Future AI recommendations must remain clearly distinguishable from
clinical instructions.

------------------------------------------------------------------------

# 11. Notifications {#11-notifications}

Recommended filters:

`All | Unread | Mentions`

Backend notification types:

-   VISIT
-   PATIENT
-   MEDICATION
-   EMERGENCY
-   SUPERVISOR
-   SYSTEM
-   PROTOCOL

Example:

``` text
Medication Protocol Updated
Critical
10 min ago

The medication administration
protocol for Mrs. Patil was updated.
```

------------------------------------------------------------------------

# 12. Notification Details {#12-notification-details}

Recommended structure:

``` text
[Priority]

Medication Protocol Updated

Today, 9:40 AM

The medication administration protocol
for Mrs. Patil has been updated.

Related Activity

Medication Administration
Version 2.4

[View Related Activity]
[Mark as Read]
```

Use contextual actions. Keep Print only if the business specifically
requires it.

Every notification should be able to reference a related entity such as:

-   VISIT
-   PATIENT
-   PROTOCOL
-   INCIDENT

------------------------------------------------------------------------

# 13. My Patients {#13-my-patients}

Recommended:

``` text
MY PATIENTS

3 Active Patients

[ Search patients... ]

[All] [Today] [High Risk]

────────────────────────

Mrs. Sunita Patil
High Risk
Next Visit: 10:30 AM
Pune West

[View Patient]
```

Recommended API:

`GET /caregivers/me/patients`

Access must be controlled by backend authorization.

------------------------------------------------------------------------

# 14. Daily Visit Logs {#14-daily-visit-logs}

Daily Logs should primarily be an audit/history view.

Filters:

-   Today
-   Yesterday
-   This Week
-   Custom Date
-   Patient
-   Visit Type
-   Status
-   Severity

Preferred data flow:

``` text
Visit
 ↓
Care Tasks / Vitals / Medicines / Observations
 ↓
Visit Completion
 ↓
Daily Visit Log
```

Avoid arbitrary manual clinical log creation unless specifically
required.

------------------------------------------------------------------------

# 15. Clinical Protocols {#15-clinical-protocols}

Recommended UI:

``` text
CLINICAL PROTOCOLS

[ Search protocols... ]

[All] [Critical] [Medication] [Patient Care]

Critical Action
Medication Administration
Patient Care
Mobility Assistance
```

Protocol details should contain:

-   Title
-   Category
-   Version
-   Effective date
-   Last updated
-   Instructions
-   Mandatory/optional status
-   Acknowledgement status

Example:

``` text
Medication Administration

Version 2.4
Updated: 15 Aug 2026

[Read Protocol]
[Acknowledge]
```

Protocol versioning is important.

------------------------------------------------------------------------

# 16. Caregiver Support Hub {#16-caregiver-support-hub}

Recommended sections:

### Immediate Assistance

-   Call Supervisor
-   Live Chat

### Emergency Incident

-   Report Urgent Incident

### IT Support

-   New Ticket
-   Track Ticket

### Operations Manual

-   Search
-   Categories

### Caregiver Wellbeing

-   Wellness Hub

Keep emergency actions visually distinct from normal support.

------------------------------------------------------------------------

# 17. Responsive UI Requirements {#17-responsive-ui-requirements}

The UI must work on:

-   Small phones: approximately 320--360 px
-   Standard phones: approximately 375--430 px
-   Large phones
-   Tablets

## Small screens

-   Stack cards vertically
-   Allow text wrapping
-   Never create horizontal overflow
-   Avoid fixed widths
-   Avoid fixed heights for dynamic content
-   Keep buttons touch-friendly

## Tablets

Do not simply stretch the phone UI.

Use an adaptive layout such as:

``` text
┌───────────────────────────────┐
│ Header                        │
├───────────────┬───────────────┤
│ Progress      │ Current Visit │
├───────────────┴───────────────┤
│ Quick Actions                 │
├───────────────┬───────────────┤
│ Recent        │ Upcoming      │
└───────────────┴───────────────┘
```

------------------------------------------------------------------------

# 18. Flutter Responsive Rules {#18-flutter-responsive-rules}

Avoid fixed phone widths such as:

``` dart
Container(width: 390)
```

Prefer:

-   LayoutBuilder
-   MediaQuery
-   Expanded
-   Flexible
-   Wrap
-   ConstrainedBox
-   AspectRatio

Use centralized spacing, radius and typography constants.

Use SafeArea for system UI.

Interactive controls should generally provide about 44--48 logical
pixels of touch area.

------------------------------------------------------------------------

# 19. Loading States {#19-loading-states}

Every API-driven Home section needs a loading state.

Use skeletons for:

-   Header
-   Progress card
-   Current visit
-   Quick actions
-   Upcoming visits
-   Recent activity

Avoid a blank dashboard while loading.

------------------------------------------------------------------------

# 20. Empty States {#20-empty-states}

### No Active Visit

``` text
No active visit

You're all caught up.

[View Upcoming Visits]
```

### No Upcoming Visits

``` text
No upcoming visits

You have no visits scheduled.
```

### No Recent Activity

``` text
No recent activity yet.
```

------------------------------------------------------------------------

# 21. Error and Partial Failure States {#21-error-and-partial-failure-states}

If the dashboard fails:

``` text
Unable to load dashboard

Please check your connection
and try again.

[Retry]
```

Do not fail the entire Home screen because one secondary section fails.

Example:

``` text
Dashboard       ✓
Current Visit   ✓
Upcoming        ✓
Recent Activity ✗
```

Only Recent Activity should show a retry state.

Support pull-to-refresh.

------------------------------------------------------------------------

# 22. Visual Design Principles {#22-visual-design-principles}

Priority order:

1.  Current/Next Visit
2.  Today\'s Progress
3.  Quick Actions
4.  Upcoming Visits
5.  Recent Activity
6.  Care Intelligence

The most important action should have the strongest visual hierarchy.

Avoid making every card equally prominent.

Use the existing Shrayo design language, but improve:

-   Spacing
-   Typography hierarchy
-   Card consistency
-   Button hierarchy
-   Status clarity
-   Responsive behavior
-   Empty/loading/error states

Use color semantically, not decoratively.

------------------------------------------------------------------------

# 23. API-Oriented Home Architecture {#23-api-oriented-home-architecture}

Recommended primary endpoint:

`GET /caregivers/me/dashboard`

Suggested response:

``` json
{
  "caregiver": {},
  "dailyProgress": {
    "totalVisits": 6,
    "completedVisits": 2,
    "ongoingVisits": 1,
    "upcomingVisits": 3,
    "progressPercentage": 33
  },
  "currentVisit": {},
  "recentActivities": [],
  "upcomingVisits": [],
  "careIntelligence": {}
}
```

Do not make the Home screen call a large number of independent APIs
before it can render.

Secondary modules should use their own endpoints.

------------------------------------------------------------------------

# 24. Visit Action Architecture {#24-visit-action-architecture}

Backend should return allowed actions for the current visit state.

Example:

``` json
{
  "visitId": "V123",
  "status": "ON_THE_WAY",
  "allowedActions": [
    "VIEW_VISIT",
    "VIEW_ROUTE",
    "CONFIRM_ARRIVAL"
  ]
}
```

This keeps business rules out of hardcoded Flutter UI.

------------------------------------------------------------------------

# 25. Future Live Tracking Foundation {#25-future-live-tracking-foundation}

The Home module should be ready for:

``` text
Caregiver Assigned
       ↓
Accept
       ↓
Start Navigation
       ↓
ON_THE_WAY
       ↓
Live GPS
       ↓
ETA
       ↓
Arrived
       ↓
Start Visit
       ↓
Complete Visit
```

Location tracking should be associated with the active visit/travel
state, not continuously enabled from login.

------------------------------------------------------------------------

# 26. Performance {#26-performance}

Because the Home will eventually include live status, notifications, ETA
and patient information:

-   Use lazy lists
-   Avoid unnecessary widget rebuilds
-   Cache stable data
-   Paginate long lists
-   Debounce search
-   Avoid aggressive polling
-   Use realtime updates only where necessary
-   Keep image loading optimized

Animations should be subtle and fast.

------------------------------------------------------------------------

# 27. Final Recommended Home Order {#27-final-recommended-home-order}

``` text
Header
   ↓
Daily Progress
   ↓
Current / Next Visit
   ↓
Quick Actions
   ↓
Upcoming Visits
   ↓
Recent Activity
   ↓
Care Intelligence
   ↓
Bottom Navigation
```

If there is no active visit, show the **Next Visit** rather than an
empty current-visit card.

------------------------------------------------------------------------

# 28. Implementation Phases {#28-implementation-phases}

## Phase 1 --- UI Foundation {#phase-1--ui-foundation}

-   [ ] Responsive Home scaffold
-   [ ] Header
-   [ ] Daily Progress
-   [ ] Current/Next Visit
-   [ ] Quick Actions
-   [ ] Upcoming Visits
-   [ ] Recent Activity
-   [ ] Care Intelligence
-   [ ] Bottom Navigation

## Phase 2 --- UI States {#phase-2--ui-states}

-   [ ] Loading
-   [ ] Empty
-   [ ] Error
-   [ ] Partial failure
-   [ ] Pull-to-refresh
-   [ ] Assigned
-   [ ] Accepted
-   [ ] On The Way
-   [ ] Arrived
-   [ ] In Progress
-   [ ] Completed

## Phase 3 --- Navigation {#phase-3--navigation}

-   [ ] Notifications
-   [ ] Notification Details
-   [ ] My Patients
-   [ ] Daily Logs
-   [ ] Clinical Protocols
-   [ ] Support Hub

## Phase 4 --- Backend {#phase-4--backend}

-   [ ] Dashboard API
-   [ ] Notification API
-   [ ] Patient API
-   [ ] Visit API
-   [ ] Daily Logs API
-   [ ] Protocol API
-   [ ] Support API

## Phase 5 --- Future Tracking {#phase-5--future-tracking}

-   [ ] Visit state machine
-   [ ] Location permission
-   [ ] GPS service abstraction
-   [ ] Route/navigation integration
-   [ ] Arrival validation
-   [ ] Live location architecture
-   [ ] ETA architecture

------------------------------------------------------------------------

# 29. Final Acceptance Criteria {#29-final-acceptance-criteria}

The Home module is ready for development handoff when:

-   [ ] UI matches the Shrayo visual design
-   [ ] No horizontal overflow exists on small phones
-   [ ] Layout adapts correctly to larger screens/tablets
-   [ ] Current Visit is state-driven
-   [ ] Start Session has been replaced with Start Visit
-   [ ] Caregiver sees assigned patients only
-   [ ] Administrative patient actions are hidden
-   [ ] Loading, empty and error states exist
-   [ ] Pull-to-refresh works
-   [ ] Notification navigation works
-   [ ] Quick Actions navigate correctly
-   [ ] Visit actions are backend-driven
-   [ ] API models are separated from UI widgets
-   [ ] Home is prepared for future live tracking
-   [ ] UI remains fast and usable on real devices

------------------------------------------------------------------------

# 30. Final Recommendation {#30-final-recommendation}

The existing Home design is a strong visual foundation. The production
implementation should focus on **workflow-first, state-driven and
responsive design**.

The four most important decisions are:

1.  Use **My Patients** for caregiver-specific access.
2.  Remove administrative patient actions from caregiver UI.
3.  Use **Start Visit** instead of **Start Session**.
4.  Build the primary visit card around:

`Assigned → Accepted → On The Way → Arrived → In Progress → Completed`

This gives the Caregiver app a clean Home experience today while keeping
the architecture ready for future **Manager Assignment → Caregiver
Tracking → ETA → Arrival → Visit → Parent Live Tracking** functionality.

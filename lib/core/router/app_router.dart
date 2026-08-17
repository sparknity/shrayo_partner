import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';

// Home & Pushed Screens
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/notifications/presentation/screens/notification_details_screen.dart';
import '../../features/patients/presentation/screens/patient_directory_screen.dart';
import '../../features/patients/presentation/screens/patient_overview_screen.dart';
import '../../features/patients/presentation/screens/medical_profile_screen.dart';
import '../../features/patients/presentation/screens/medicines_management_screen.dart';
import '../../features/patients/presentation/screens/health_timeline_screen.dart';
import '../../features/patients/presentation/screens/health_trends_screen.dart';
import '../../features/patients/presentation/screens/medical_documents_screen.dart';
import '../../features/patients/presentation/screens/emergency_information_screen.dart';
import '../../features/patients/data/fixtures/patient_fixtures.dart';
import '../../features/daily_logs/presentation/screens/daily_visit_logs_screen.dart';
import '../../features/protocol_library/presentation/screens/clinical_protocol_library_screen.dart';
import '../../features/support/presentation/screens/caregiver_support_hub_screen.dart';

// Visits Workflow Screens
import '../../features/visit_workflow/presentation/custom_screens/current_visit_screen.dart';
import '../../features/visit_workflow/presentation/custom_screens/navigation_screen.dart';
import '../../features/visit_workflow/presentation/custom_screens/check_in_screen.dart';
import '../../features/visit_workflow/presentation/custom_screens/care_assessment_screen.dart';
import '../../features/visit_workflow/presentation/custom_screens/assessment_completion_screen.dart';
import '../../features/visit_workflow/presentation/custom_screens/blood_pressure_details_screen.dart';
import '../../features/visit_workflow/presentation/custom_screens/review_visit_screen.dart';
import '../../features/visit_workflow/presentation/custom_screens/submit_visit_screen.dart';
import '../../features/visit_workflow/presentation/custom_screens/submission_requirements_screen.dart';
import '../../features/visit_workflow/presentation/screens/submission_confirmation_screen.dart';
import '../../features/visit_workflow/presentation/screens/gps_check_out_screen.dart';
import '../../features/visit_workflow/presentation/custom_screens/check_out_screen.dart';
import '../../features/visit_workflow/presentation/screens/visit_completed_screen.dart';
import '../../features/visit_workflow/presentation/screens/critical_vital_alert_review_screen.dart';
import '../../features/visit_workflow/presentation/screens/patient_not_available_screen.dart';

// Emergency Screens
import '../../features/emergency/presentation/custom_screens/report_patient_emergency_screen.dart';
import '../../features/emergency/presentation/custom_screens/medical_emergency_screen.dart';
import '../../features/emergency/presentation/custom_screens/analyze_situation_screen.dart';
import '../../features/emergency/presentation/custom_screens/start_emergency_response_screen.dart';
import '../../features/emergency/presentation/custom_screens/active_emergency_screen.dart';
import '../../features/emergency/presentation/custom_screens/update_progress_screen.dart';
import '../../features/emergency/presentation/custom_screens/complete_emergency_screen.dart';
import '../../features/emergency/presentation/custom_screens/emergency_history_screen.dart';

// Workspace Screens
import '../../features/workspace/presentation/screens/workspace_home_screen.dart';
import '../../features/workspace/presentation/screens/my_profile_screen.dart';
import '../../features/workspace/presentation/screens/edit_profile_screen.dart';
import '../../features/workspace/presentation/screens/professional_information_screen.dart';
import '../../features/workspace/presentation/screens/caregiver_emergency_contact_screen.dart';
import '../../features/workspace/presentation/screens/attendance_screen.dart';
import '../../features/workspace/presentation/screens/attendance_history_screen.dart';
import '../../features/workspace/presentation/screens/attendance_details_screen.dart';
import '../../features/workspace/presentation/screens/my_schedule_screen.dart';
import '../../features/workspace/presentation/screens/tasks_screen.dart';
import '../../features/workspace/presentation/screens/task_details_screen.dart';
import '../../features/workspace/presentation/screens/workspace_documents_screen.dart';
import '../../features/workspace/presentation/screens/workspace_document_details_screen.dart';
import '../../features/workspace/presentation/screens/training_screen.dart';
import '../../features/workspace/presentation/screens/training_details_screen.dart';
import '../../features/workspace/presentation/screens/course_details_screen.dart';
import '../../features/workspace/presentation/screens/settings_screen.dart';
import '../../features/workspace/presentation/screens/privacy_security_screen.dart';
import '../../features/workspace/presentation/screens/settings_details_screen.dart';
import '../../features/workspace/presentation/screens/about_application_screen.dart';
import '../../features/workspace/presentation/screens/help_support_screen.dart';
import '../../features/workspace/presentation/screens/performance_screen.dart';
import '../../features/workspace/presentation/screens/performance_details_screen.dart';
import '../../features/workspace/presentation/screens/request_leave_screen.dart';
import '../../features/workspace/presentation/screens/leave_request_status_screen.dart';
import '../../features/support/presentation/screens/support_ticket_screen.dart';
import '../../features/support/presentation/screens/support_ticket_details_screen.dart';

import '../../features/visit_workflow/presentation/providers/active_visit_provider.dart';
import 'app_shell.dart';
import 'router_extensions.dart';

/// Combines multiple [Listenable]s into a single [Listenable] for [GoRouter.refreshListenable].
class CombinedListenable extends ChangeNotifier {
  CombinedListenable(List<Listenable> listenables) {
    for (final listenable in listenables) {
      listenable.addListener(notifyListeners);
    }
  }
}

/// Static route path constants for the Caregiver App (Phase 11 v2).
abstract class AppRoutes {
  static const String login = '/login';

  // Core Shell Tabs
  static const String home = '/home';
  static const String visits = '/visits';
  static const String emergency = '/emergency';
  static const String workspace = '/workspace';

  // Home Pushed Routes
  static const String notifications = '/notifications';
  static const String notificationDetail = '/notifications/:id';
  static const String patients = '/patients';
  static const String patientDetail = '/patients/:id';
  static const String patientMedicalProfile = '/patients/:id/medical-profile';
  static const String patientMedicines = '/patients/:id/medicines';
  static const String patientHealthTimeline = '/patients/:id/health-timeline';
  static const String patientHealthTrends = '/patients/:id/health-trends';
  static const String patientDocuments = '/patients/:id/documents';
  static const String patientEmergency = '/patients/:id/emergency';
  static const String logs = '/logs';
  static const String protocol = '/protocol';
  static const String support = '/support';

  // Visits Pushed Workflow Routes
  static const String visitNavigate = '/visits/navigate';
  static const String visitCheckIn = '/visits/check-in';
  static const String visitAssessment = '/visits/assessment';
  static const String visitAssessmentCompletion = '/visits/assessment/completion';
  static const String visitBloodPressure = '/visits/assessment/blood-pressure';
  static const String visitReview = '/visits/review';
  static const String visitSubmit = '/visits/submit';
  static const String visitSubmitRequirements = '/visits/submit/requirements';
  static const String visitSubmitConfirmation = '/visits/submit/confirmation';
  static const String visitCheckout = '/visits/checkout';
  static const String visitCheckoutConfirm = '/visits/checkout/confirm';
  static const String visitCompleted = '/visits/completed';
  static const String visitCriticalAlert = '/visits/critical-alert';
  static const String visitPatientNotAvailable = '/visits/patient-not-available';

  // Emergency Pushed Routes
  static const String emergencyMedical = '/emergency/medical';
  static const String emergencyAnalyze = '/emergency/analyze';
  static const String emergencyStartResponse = '/emergency/start-response';
  static const String emergencyActive = '/emergency/:id/active';
  static const String emergencyUpdateProgress = '/emergency/:id/update-progress';
  static const String emergencyComplete = '/emergency/:id/complete';
  static const String emergencyHistory = '/emergency/:id/history';
  static const String emergencyHistoryList = '/emergency/history';

  // Workspace Sub-routes
  static const String workspaceProfile = '/workspace/profile';
  static const String workspaceProfileEdit = '/workspace/profile/edit';
  static const String workspaceProfileProfessionalInfo = '/workspace/profile/professional-info';
  static const String workspaceProfileEmergencyContact = '/workspace/profile/emergency-contact';
  static const String workspaceAttendance = '/workspace/attendance';
  static const String workspaceAttendanceHistory = '/workspace/attendance/history';
  static const String workspaceAttendanceDetail = '/workspace/attendance/history/:id';
  static const String workspaceSchedule = '/workspace/schedule';
  static const String workspaceTasks = '/workspace/tasks';
  static const String workspaceTaskDetail = '/workspace/tasks/:id';
  static const String workspaceDocuments = '/workspace/documents';
  static const String workspaceDocumentDetail = '/workspace/documents/:id';
  static const String workspaceTraining = '/workspace/training';
  static const String workspaceTrainingDetail = '/workspace/training/:id';
  static const String workspaceCourseDetail = '/workspace/training/:id/course/:courseId';
  static const String workspaceSettings = '/workspace/settings';
  static const String workspacePrivacySecurity = '/workspace/settings/privacy-security';
  static const String workspaceSettingsDetails = '/workspace/settings/details';
  static const String workspaceAbout = '/workspace/settings/about';
  static const String workspaceHelpSupport = '/workspace/settings/help-support';
  static const String workspaceHelp = '/workspace/help';
  static const String workspacePerformance = '/workspace/performance';
  static const String workspacePerformanceDetail = '/workspace/performance/:id';
  static const String workspaceLeave = '/workspace/leave';
  static const String workspaceLeaveStatus = '/workspace/leave/status';
  static const String workspaceSupportTicket = '/workspace/support-ticket';
  static const String workspaceSupportTicketDetail = '/workspace/support-ticket/:id';

  static const List<String> publicPaths = [login];
}

/// Root navigator key for full-screen modals and pushed routes.
final rootNavigatorKey = GlobalKey<NavigatorState>();

/// Provider creating the main application [GoRouter] instance.
final appRouterProvider = Provider<GoRouter>((ref) {
  final authNotifier = ref.watch(authProvider.notifier);
  final activeVisitNotifier = ref.watch(activeVisitProvider.notifier);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.home,
    refreshListenable: CombinedListenable([authNotifier, activeVisitNotifier]),
    redirect: (BuildContext context, GoRouterState state) {
      final authState = ref.read(authProvider);
      final isAuthed = authState.isAuthenticated;
      final matchedLocation = state.matchedLocation;
      final isPublic = AppRoutes.publicPaths.contains(matchedLocation);

      if (!isAuthed && !isPublic) {
        final encodedTarget = Uri.encodeComponent(state.uri.toString());
        return '${AppRoutes.login}?returnTo=$encodedTarget';
      }

      if (isAuthed && isPublic) {
        final returnToTarget = state.returnTo;
        if (returnToTarget != null && returnToTarget.isNotEmpty) {
          return Uri.decodeComponent(returnToTarget);
        }
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      // Pre-auth Login
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),

      // 4-Tab Authenticated StatefulShellRoute
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          // Tab 0: Home
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          // Tab 1: Visits
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.visits,
                builder: (context, state) => const CurrentVisitScreen(),
              ),
            ],
          ),
          // Tab 2: Emergency
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.emergency,
                builder: (context, state) => const ReportPatientEmergencyScreen(),
              ),
            ],
          ),
          // Tab 3: Workspace
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.workspace,
                builder: (context, state) => const WorkspaceHomeScreen(),
              ),
            ],
          ),
        ],
      ),

      // Home Pushed Routes
      GoRoute(
        path: AppRoutes.notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: AppRoutes.notificationDetail,
        builder: (context, state) => NotificationDetailsScreen(id: state.pathParameters['id'] ?? ''),
      ),
      GoRoute(
        path: AppRoutes.patients,
        builder: (context, state) => const PatientDirectoryScreen(),
      ),
      GoRoute(
        path: AppRoutes.patientDetail,
        builder: (context, state) => PatientOverviewScreen(id: state.pathParameters['id'] ?? ''),
      ),
      GoRoute(
        path: AppRoutes.patientMedicalProfile,
        builder: (context, state) => MedicalProfileScreen(id: state.pathParameters['id'] ?? ''),
      ),
      GoRoute(
        path: AppRoutes.patientMedicines,
        builder: (context, state) => MedicinesManagementScreen(id: state.pathParameters['id'] ?? ''),
      ),
      GoRoute(
        path: AppRoutes.patientHealthTimeline,
        builder: (context, state) => HealthTimelineScreen(id: state.pathParameters['id'] ?? ''),
      ),
      GoRoute(
        path: AppRoutes.patientHealthTrends,
        builder: (context, state) => const HealthTrendsScreen(),
      ),
      GoRoute(
        path: AppRoutes.patientDocuments,
        builder: (context, state) => const MedicalDocumentsScreen(),
      ),
      GoRoute(
        path: AppRoutes.patientEmergency,
        builder: (context, state) {
          final patientId = state.pathParameters['id'] ?? 'p-1';
          final patient = PatientFixtures.patients.firstWhere(
            (p) => p['id'] == patientId,
            orElse: () => PatientFixtures.patients.first,
          );
          return EmergencyInformationScreen(patient: patient);
        },
      ),
      GoRoute(
        path: AppRoutes.logs,
        builder: (context, state) => const DailyVisitLogsScreen(),
      ),
      GoRoute(
        path: AppRoutes.protocol,
        builder: (context, state) => const ClinicalProtocolLibraryScreen(),
      ),
      GoRoute(
        path: AppRoutes.support,
        builder: (context, state) => const CaregiverSupportHubScreen(),
      ),

      // Visits Pushed Workflow Routes
      GoRoute(
        path: AppRoutes.visitNavigate,
        builder: (context, state) => const NavigationScreen(),
      ),
      GoRoute(
        path: AppRoutes.visitCheckIn,
        builder: (context, state) => const CheckInScreen(),
      ),
      GoRoute(
        path: AppRoutes.visitAssessment,
        builder: (context, state) => const CareAssessmentScreen(),
      ),
      GoRoute(
        path: AppRoutes.visitAssessmentCompletion,
        builder: (context, state) => const AssessmentCompletionScreen(),
      ),
      GoRoute(
        path: AppRoutes.visitBloodPressure,
        builder: (context, state) => const BloodPressureDetailsScreen(),
      ),
      GoRoute(
        path: AppRoutes.visitReview,
        builder: (context, state) => const ReviewVisitScreen(),
      ),
      GoRoute(
        path: AppRoutes.visitSubmit,
        builder: (context, state) => const SubmitVisitScreen(),
      ),
      GoRoute(
        path: AppRoutes.visitSubmitRequirements,
        builder: (context, state) => const SubmissionRequirementsScreen(),
      ),
      GoRoute(
        path: AppRoutes.visitSubmitConfirmation,
        builder: (context, state) => const SubmissionConfirmationScreen(),
      ),
      GoRoute(
        path: AppRoutes.visitCheckout,
        builder: (context, state) => const GpsCheckOutScreen(),
      ),
      GoRoute(
        path: AppRoutes.visitCheckoutConfirm,
        builder: (context, state) => const CheckOutScreen(),
      ),
      GoRoute(
        path: AppRoutes.visitCompleted,
        builder: (context, state) => const VisitCompletedScreen(),
      ),
      GoRoute(
        path: AppRoutes.visitCriticalAlert,
        builder: (context, state) => const CriticalVitalAlertReviewScreen(),
      ),
      GoRoute(
        path: AppRoutes.visitPatientNotAvailable,
        builder: (context, state) => const PatientNotAvailableScreen(),
      ),

      // Emergency Pushed Routes
      GoRoute(
        path: AppRoutes.emergencyMedical,
        builder: (context, state) => const MedicalEmergencyScreen(),
      ),
      GoRoute(
        path: AppRoutes.emergencyAnalyze,
        builder: (context, state) => const AnalyzeSituationScreen(),
      ),
      GoRoute(
        path: AppRoutes.emergencyStartResponse,
        builder: (context, state) => const StartEmergencyResponseScreen(),
      ),
      GoRoute(
        path: AppRoutes.emergencyActive,
        builder: (context, state) => ActiveEmergencyScreen(id: state.pathParameters['id'] ?? 'em-501'),
      ),
      GoRoute(
        path: AppRoutes.emergencyUpdateProgress,
        builder: (context, state) => UpdateProgressScreen(id: state.pathParameters['id'] ?? ''),
      ),
      GoRoute(
        path: AppRoutes.emergencyComplete,
        builder: (context, state) => CompleteEmergencyScreen(id: state.pathParameters['id'] ?? ''),
      ),
      GoRoute(
        path: AppRoutes.emergencyHistory,
        builder: (context, state) => EmergencyHistoryScreen(id: state.pathParameters['id'] ?? ''),
      ),
      GoRoute(
        path: AppRoutes.emergencyHistoryList,
        builder: (context, state) => const EmergencyHistoryScreen(),
      ),

      // Workspace Pushed Sub-routes
      GoRoute(
        path: AppRoutes.workspaceProfile,
        builder: (context, state) => const MyProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.workspaceProfileEdit,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.workspaceProfileProfessionalInfo,
        builder: (context, state) => const ProfessionalInformationScreen(),
      ),
      GoRoute(
        path: AppRoutes.workspaceProfileEmergencyContact,
        builder: (context, state) => const CaregiverEmergencyContactScreen(),
      ),
      GoRoute(
        path: AppRoutes.workspaceAttendance,
        builder: (context, state) => const AttendanceScreen(),
      ),
      GoRoute(
        path: AppRoutes.workspaceAttendanceHistory,
        builder: (context, state) => const AttendanceHistoryScreen(),
      ),
      GoRoute(
        path: AppRoutes.workspaceAttendanceDetail,
        builder: (context, state) => AttendanceDetailsScreen(id: state.pathParameters['id'] ?? ''),
      ),
      GoRoute(
        path: AppRoutes.workspaceSchedule,
        builder: (context, state) => const MyScheduleScreen(),
      ),
      GoRoute(
        path: AppRoutes.workspaceTasks,
        builder: (context, state) => const TasksScreen(),
      ),
      GoRoute(
        path: AppRoutes.workspaceTaskDetail,
        builder: (context, state) => TaskDetailsScreen(id: state.pathParameters['id'] ?? ''),
      ),
      GoRoute(
        path: AppRoutes.workspaceDocuments,
        builder: (context, state) => const WorkspaceDocumentsScreen(),
      ),
      GoRoute(
        path: AppRoutes.workspaceDocumentDetail,
        builder: (context, state) => WorkspaceDocumentDetailsScreen(id: state.pathParameters['id'] ?? ''),
      ),
      GoRoute(
        path: AppRoutes.workspaceTraining,
        builder: (context, state) => const TrainingScreen(),
      ),
      GoRoute(
        path: AppRoutes.workspaceTrainingDetail,
        builder: (context, state) => TrainingDetailsScreen(id: state.pathParameters['id'] ?? ''),
      ),
      GoRoute(
        path: AppRoutes.workspaceCourseDetail,
        builder: (context, state) => CourseDetailsScreen(
          id: state.pathParameters['id'] ?? '',
          courseId: state.pathParameters['courseId'] ?? '',
        ),
      ),
      GoRoute(
        path: AppRoutes.workspaceSettings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.workspacePrivacySecurity,
        builder: (context, state) => const PrivacySecurityScreen(),
      ),
      GoRoute(
        path: AppRoutes.workspaceSettingsDetails,
        builder: (context, state) => const SettingsDetailsScreen(),
      ),
      GoRoute(
        path: AppRoutes.workspaceAbout,
        builder: (context, state) => const AboutApplicationScreen(),
      ),
      GoRoute(
        path: AppRoutes.workspaceHelpSupport,
        builder: (context, state) => const HelpSupportScreen(),
      ),
      GoRoute(
        path: AppRoutes.workspaceHelp,
        builder: (context, state) => const HelpSupportScreen(),
      ),
      GoRoute(
        path: AppRoutes.workspacePerformance,
        builder: (context, state) => const PerformanceScreen(),
      ),
      GoRoute(
        path: AppRoutes.workspacePerformanceDetail,
        builder: (context, state) => PerformanceDetailsScreen(id: state.pathParameters['id'] ?? ''),
      ),
      GoRoute(
        path: AppRoutes.workspaceLeave,
        builder: (context, state) => const RequestLeaveScreen(),
      ),
      GoRoute(
        path: AppRoutes.workspaceLeaveStatus,
        builder: (context, state) => const LeaveRequestStatusScreen(),
      ),
      GoRoute(
        path: AppRoutes.workspaceSupportTicket,
        builder: (context, state) => const SupportTicketScreen(),
      ),
      GoRoute(
        path: AppRoutes.workspaceSupportTicketDetail,
        builder: (context, state) => SupportTicketDetailsScreen(id: state.pathParameters['id'] ?? ''),
      ),
    ],
  );
});

import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';

import '../widgets/home_header.dart';
import '../widgets/daily_progress_card.dart';
import '../widgets/primary_current_visit_card.dart';
import '../widgets/quick_actions_grid.dart';
import '../widgets/recent_activity_section.dart';
import '../widgets/upcoming_visits_section.dart';
import '../widgets/care_intelligence_card.dart';

/// Home tab landing screen matching `Operations Dashboard - Redesign Final.png` EXACTLY.
/// Refactored to use modular components and responsive layout builder.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Adaptive logic for tablets
            bool isTablet = constraints.maxWidth >= 600;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 840),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.m,
                    vertical: AppSpacing.s,
                  ),
                  child: isTablet
                      ? _buildTabletLayout(context)
                      : _buildMobileLayout(context),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HomeHeader(
          name: 'Anita',
          date: 'MON, OCT 26',
          hasUnreadNotifications: true,
        ),
        const SizedBox(height: AppSpacing.m),
        const DailyProgressCard(
          progressPercentage: 0.33,
          progressText: '33% Complete',
        ),
        const SizedBox(height: AppSpacing.m),
        const PrimaryCurrentVisitCard(
          status: VisitStatus.assigned,
          patientName: 'Sunita Patil',
          patientAge: 78,
          location: 'Pune West',
          distance: '2.3km Away',
          scheduledTime: '10:30 AM',
          isHighRisk: true,
          healthTags: ['#Diabetic', '#Mobility'],
          travelInfo: '12m via Route A',
        ),
        const SizedBox(height: AppSpacing.l),
        const QuickActionsGrid(),
        const SizedBox(height: AppSpacing.l),
        const RecentActivitySection(),
        const SizedBox(height: AppSpacing.l),
        const UpcomingVisitsSection(),
        const SizedBox(height: AppSpacing.l),
        const CareIntelligenceCard(
          content: 'Mrs. Patil responds best to low-stimulus instructions during morning rounds. Speak softly and maintain eye contact.',
        ),
        const SizedBox(height: AppSpacing.l),
      ],
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HomeHeader(
          name: 'Anita',
          date: 'MON, OCT 26',
          hasUnreadNotifications: true,
        ),
        const SizedBox(height: AppSpacing.m),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 4,
              child: Column(
                children: const [
                  DailyProgressCard(
                    progressPercentage: 0.33,
                    progressText: '33% Complete',
                  ),
                  SizedBox(height: AppSpacing.l),
                  QuickActionsGrid(),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.l),
            const Expanded(
              flex: 5,
              child: PrimaryCurrentVisitCard(
                status: VisitStatus.assigned,
                patientName: 'Sunita Patil',
                patientAge: 78,
                location: 'Pune West',
                distance: '2.3km Away',
                scheduledTime: '10:30 AM',
                isHighRisk: true,
                healthTags: ['#Diabetic', '#Mobility'],
                travelInfo: '12m via Route A',
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.l),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Expanded(
              child: RecentActivitySection(),
            ),
            SizedBox(width: AppSpacing.l),
            Expanded(
              child: UpcomingVisitsSection(),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.l),
        const CareIntelligenceCard(
          content: 'Mrs. Patil responds best to low-stimulus instructions during morning rounds. Speak softly and maintain eye contact.',
        ),
        const SizedBox(height: AppSpacing.l),
      ],
    );
  }
}

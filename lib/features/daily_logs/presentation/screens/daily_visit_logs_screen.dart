import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/status_pill.dart';
import '../../data/fixtures/daily_logs_fixtures.dart';

/// Daily Visit Logs screen matching `Daily Visit Logs - Redesign Final.png`.
class DailyVisitLogsScreen extends StatelessWidget {
  const DailyVisitLogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final logs = DailyLogsFixtures.logs;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: const Text(
          'Daily Visit Logs',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 840),
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.m),
              itemCount: logs.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppSpacing.s),
              itemBuilder: (context, index) {
                final log = logs[index];
                final vitals = log['vitals'] as Map<String, dynamic>;

                return Card(
                  elevation: 1,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppSpacing.cardRadius,
                    side: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.m),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                log['patientName'],
                                style: AppTextStyles.titleMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF0F172A),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            StatusPill(
                              label: log['status'],
                              backgroundColor: AppColors.healthGreenLight
                                  .withValues(alpha: 0.3),
                              textColor: AppColors.healthGreen,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${log['visitDate']} • ${log['timeRange']}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const Divider(height: AppSpacing.m, color: Color(0xFFE2E8F0)),
                        Text(
                          log['summary'],
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: const Color(0xFF334155),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.m),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.s,
                            vertical: AppSpacing.s,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: AppSpacing.cardRadius,
                            border: Border.all(color: const Color(0xFFF1F5F9)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _VitalMetric(label: 'BP', value: vitals['bp']),
                              _VitalMetric(label: 'Pulse', value: vitals['pulse']),
                              _VitalMetric(label: 'Temp', value: vitals['temp']),
                              _VitalMetric(label: 'SpO2', value: vitals['spo2']),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _VitalMetric extends StatelessWidget {
  final String label;
  final String value;

  const _VitalMetric({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.textSecondary,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTextStyles.labelLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }
}

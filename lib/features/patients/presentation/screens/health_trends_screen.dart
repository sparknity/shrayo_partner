import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/chart_card.dart';

/// Health Trends screen matching `Health Trends.png`.
class HealthTrendsScreen extends StatelessWidget {
  const HealthTrendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ChartCard(
            title: 'Blood Pressure Trend (Last 7 Days)',
            subtitle: 'Avg Systolic 138 mmHg / Diastolic 86 mmHg',
            unit: 'mmHg',
            spots: [
              FlSpot(1, 142),
              FlSpot(2, 138),
              FlSpot(3, 145),
              FlSpot(4, 136),
              FlSpot(5, 140),
              FlSpot(6, 135),
              FlSpot(7, 138),
            ],
          ),
          const SizedBox(height: AppSpacing.m),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.m),
              child: Row(
                children: const [
                  Icon(Icons.insights, color: AppColors.primaryBlue),
                  SizedBox(width: AppSpacing.m),
                  Expanded(
                    child: Text('Systolic readings trending downwards by 5% following medication adjustment.'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

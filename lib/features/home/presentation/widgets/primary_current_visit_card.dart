import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

enum VisitStatus {
  assigned,
  accepted,
  onTheWay,
  arrived,
  inProgress,
  completed,
}

class PrimaryCurrentVisitCard extends StatelessWidget {
  final VisitStatus status;
  final String patientName;
  final int patientAge;
  final String location;
  final String distance;
  final String scheduledTime;
  final bool isHighRisk;
  final List<String> healthTags;
  final String travelInfo;

  const PrimaryCurrentVisitCard({
    super.key,
    required this.status,
    required this.patientName,
    required this.patientAge,
    required this.location,
    required this.distance,
    required this.scheduledTime,
    required this.isHighRisk,
    this.healthTags = const [],
    required this.travelInfo,
  });

  String get _statusLabel {
    switch (status) {
      case VisitStatus.assigned:
        return 'CURRENT VISIT';
      case VisitStatus.accepted:
        return 'UPCOMING VISIT';
      case VisitStatus.onTheWay:
        return 'ON THE WAY';
      case VisitStatus.arrived:
        return 'ARRIVAL';
      case VisitStatus.inProgress:
        return 'VISIT IN PROGRESS';
      case VisitStatus.completed:
        return 'VISIT COMPLETED';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppSpacing.cardRadius,
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Patient Header Image Banner
          Stack(
            children: [
              Container(
                height: 170,
                decoration: const BoxDecoration(
                  color: Color(0xFF475569),
                ),
                child: const Center(
                  child: Icon(
                    Icons.person,
                    size: 64,
                    color: AppColors.white,
                  ),
                ),
              ),
              Container(
                height: 170,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withValues(alpha: 0.7),
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
              Positioned(
                top: 14,
                left: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0052CC),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _statusLabel,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 14,
                left: 14,
                right: 14,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$patientName, $patientAge',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                      softWrap: true,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: AppColors.white,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '$location • $distance',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.white,
                            ),
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Card Body Details
          Padding(
            padding: const EdgeInsets.all(AppSpacing.m),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            scheduledTime,
                            style: AppTextStyles.headlineSmall.copyWith(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF0052CC),
                              fontSize: 22,
                            ),
                            softWrap: true,
                          ),
                          Text(
                            'SCHEDULED TIME',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: const Color(0xFF64748B),
                              letterSpacing: 0.5,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isHighRisk)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE4E6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.diamond_outlined,
                              size: 13,
                              color: Color(0xFFE11D48),
                            ),
                            SizedBox(width: 4),
                            Text(
                              'HIGH RISK',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFE11D48),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.m),

                // Health Tags & Travel Info Row (Using Wrap/Expanded to prevent overflow)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F7FF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'HEALTH TAGS',
                              style: AppTextStyles.labelSmall.copyWith(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Wrap(
                              spacing: 4,
                              runSpacing: 4,
                              children: healthTags.map((tag) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: const Color(0xFFE2E8F0),
                                    ),
                                  ),
                                  child: Text(
                                    tag,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F7FF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'TRAVEL INFO',
                              style: AppTextStyles.labelSmall.copyWith(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              travelInfo,
                              style: AppTextStyles.labelLarge.copyWith(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF0F172A),
                              ),
                              softWrap: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.m),

                // Main Action Button (Min 46dp Height)
                Material(
                  color: const Color(0xFF0052CC),
                  borderRadius: BorderRadius.circular(24),
                  child: InkWell(
                    onTap: () => context.go('/visits'),
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(minHeight: 48),
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.play_circle_fill,
                            size: 20,
                            color: AppColors.white,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _getMainActionText(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                                color: AppColors.white,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.s),

                // Quick Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: Material(
                        color: const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          onTap: () => context.push('/visits/navigate'),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            height: 48,
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.map_outlined,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s),
                    Expanded(
                      child: Material(
                        color: const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          onTap: () => context.push('/patients/p-1'),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            height: 48,
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.badge_outlined,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getMainActionText() {
    switch (status) {
      case VisitStatus.assigned:
        return 'ACCEPT VISIT';
      case VisitStatus.accepted:
        return 'START NAVIGATION';
      case VisitStatus.onTheWay:
        return 'OPEN ROUTE';
      case VisitStatus.arrived:
        return 'CONFIRM ARRIVAL';
      case VisitStatus.inProgress:
        return 'CONTINUE VISIT';
      case VisitStatus.completed:
        return 'VIEW SUMMARY';
    }
  }
}

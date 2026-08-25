import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class UpcomingVisitsSection extends StatelessWidget {
  const UpcomingVisitsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.m),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppSpacing.cardRadius,
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Upcoming',
                style: AppTextStyles.titleLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
              ),
              Row(
                children: const [
                  Text(
                    'ALL',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: Color(0xFF64748B),
                    size: 18,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.m),
          const _UpcomingTimelineItem(
            time: '12:00 PM',
            badgeText: 'IN 1H 15M',
            title: 'Ramesh Joshi',
            subtitle: 'Medication Support',
            icon: Icons.link,
            isHighlighted: true,
            isLast: false,
          ),
          const _UpcomingTimelineItem(
            time: '03:30 PM',
            title: 'Lata Kulkarni',
            subtitle: 'Follow-up Visit',
            icon: Icons.medical_services_outlined,
            isHighlighted: false,
            isLast: false,
          ),
          const _UpcomingTimelineItem(
            time: '05:15 PM',
            title: 'Shift Handover',
            isDashed: true,
            isHighlighted: false,
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _UpcomingTimelineItem extends StatelessWidget {
  final String time;
  final String? badgeText;
  final String title;
  final String? subtitle;
  final IconData? icon;
  final bool isHighlighted;
  final bool isDashed;
  final bool isLast;

  const _UpcomingTimelineItem({
    required this.time,
    this.badgeText,
    required this.title,
    this.subtitle,
    this.icon,
    this.isHighlighted = false,
    this.isDashed = false,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 65,
            child: Text(
              time,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: isHighlighted
                    ? const Color(0xFF0052CC)
                    : const Color(0xFF64748B),
              ),
            ),
          ),
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.only(top: 2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isHighlighted
                      ? const Color(0xFF0052CC)
                      : const Color(0xFFCBD5E1),
                  border: isHighlighted
                      ? Border.all(color: const Color(0xFFDBEAFE), width: 3)
                      : null,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: const Color(0xFFE2E8F0),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
            ],
          ),
          const SizedBox(width: AppSpacing.m),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.l),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: isDashed
                                ? const Color(0xFF64748B)
                                : const Color(0xFF0F172A),
                          ),
                        ),
                      ),
                      if (badgeText != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF08A),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            badgeText!,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF854D0E),
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (icon != null) ...[
                          Icon(
                            icon,
                            size: 14,
                            color: const Color(0xFF64748B),
                          ),
                          const SizedBox(width: 4),
                        ],
                        Expanded(
                          child: Text(
                            subtitle!,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

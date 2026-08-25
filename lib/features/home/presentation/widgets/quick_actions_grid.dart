import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Adjust aspect ratio based on screen width for better responsive look
        double ratio = constraints.maxWidth > 500 ? 2.0 : 1.35;
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: AppSpacing.m,
          mainAxisSpacing: AppSpacing.m,
          childAspectRatio: ratio,
          children: [
            _GridNavCard(
              title: 'Patients',
              icon: Icons.people_alt_outlined,
              iconBg: const Color(0xFFDBEAFE),
              iconColor: const Color(0xFF0052CC),
              onTap: () => context.push('/patients'),
            ),
            _GridNavCard(
              title: 'Daily Logs',
              icon: Icons.edit_note_outlined,
              iconBg: const Color(0xFFDBEAFE),
              iconColor: const Color(0xFF0052CC),
              onTap: () => context.push('/logs'),
            ),
            _GridNavCard(
              title: 'Protocol',
              icon: Icons.medical_services_outlined,
              iconBg: const Color(0xFFDBEAFE),
              iconColor: const Color(0xFF0052CC),
              onTap: () => context.push('/protocol'),
            ),
            _GridNavCard(
              title: 'Support',
              icon: Icons.headset_mic_outlined,
              iconBg: const Color(0xFFDBEAFE),
              iconColor: const Color(0xFF0052CC),
              onTap: () => context.push('/support'),
            ),
          ],
        );
      }
    );
  }
}

class _GridNavCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final VoidCallback onTap;

  const _GridNavCard({
    required this.title,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: AppSpacing.cardRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppSpacing.cardRadius,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.m),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFF1F5F9)),
            borderRadius: AppSpacing.cardRadius,
            boxShadow: const [
              BoxShadow(
                color: Color(0x06000000),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(height: AppSpacing.s),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

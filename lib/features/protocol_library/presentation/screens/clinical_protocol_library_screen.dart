import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Clinical Protocol Library screen matching `Clinical Protocols - Redesign Final.png`.
class ClinicalProtocolLibraryScreen extends StatelessWidget {
  const ClinicalProtocolLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: const Text(
          'Clinical Protocol Library',
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.m),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Page Header
                  const Text(
                    'Clinical Protocol Library',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Evidence-based standard operating procedures for critical medical response and long-term care management.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF64748B),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.m),

                  // Search Bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: const TextField(
                      style: TextStyle(fontSize: 14, color: Color(0xFF0F172A)),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          color: Color(0xFF94A3B8),
                          size: 20,
                        ),
                        prefixIconConstraints: BoxConstraints(minWidth: 32, minHeight: 20),
                        hintText: 'Search clinical protocols...',
                        hintStyle: TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.l),

                  // Top Category Cards
                  _CategoryCard(
                    iconBg: const Color(0xFFDC2626),
                    icon: Icons.emergency,
                    title: 'Critical Action',
                    description: 'Cardiac, Respiratory, Stroke & Acute trauma SOPs.',
                    linkColor: const Color(0xFFDC2626),
                    onTap: () {},
                  ),
                  const SizedBox(height: AppSpacing.m),
                  _CategoryCard(
                    iconBg: const Color(0xFF0052CC),
                    icon: Icons.local_pharmacy,
                    title: 'Medication',
                    description:
                        'Dosage safety, error reporting, and controlled substance SOPs.',
                    linkColor: const Color(0xFF0052CC),
                    onTap: () {},
                  ),
                  const SizedBox(height: AppSpacing.m),
                  _CategoryCard(
                    iconBg: const Color(0xFF16A34A),
                    icon: Icons.clean_hands,
                    title: 'Patient Care',
                    description:
                        'Hygiene, wound care, mobility, and infection control SOPs.',
                    linkColor: const Color(0xFF16A34A),
                    onTap: () {},
                  ),
                  const SizedBox(height: AppSpacing.l),

                  // Commonly Referenced Section Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Commonly Referenced',
                        style: AppTextStyles.titleLarge.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      Row(
                        children: const [
                          Text(
                            'View All (42)',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0052CC),
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down,
                            size: 16,
                            color: Color(0xFF0052CC),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s),

                  // SOP Cards
                  _SopCard(
                    iconBg: const Color(0xFFDBEAFE),
                    icon: Icons.accessibility_new,
                    title: 'Fall Response SOP',
                    tag: 'HIGH PRIORITY',
                    tagBg: const Color(0xFFFFEDD5),
                    tagTextColor: const Color(0xFFC2410C),
                    description:
                        'Step-by-step procedure for immediate injury assessment and safe lifting post-unwitnessed fall.',
                    readTime: '4 min read',
                    badge1: '✓ Clinical Board Approved',
                    badge2: '↻ Updated Jan 2024',
                  ),
                  const SizedBox(height: AppSpacing.m),
                  _SopCard(
                    iconBg: const Color(0xFFDBEAFE),
                    icon: Icons.favorite,
                    title: 'Cardiac Event (BLS)',
                    tag: 'IMMEDIATE ACTION',
                    tagBg: const Color(0xFFFEE2E2),
                    tagTextColor: const Color(0xFF991B1B),
                    description:
                        'Universal Basic Life Support (BLS) steps for unresponsive patients including AED deployment.',
                    readTime: '2 min read',
                    badge1: '✓ AHA Compliant',
                  ),
                  const SizedBox(height: AppSpacing.m),
                  _SopCard(
                    iconBg: const Color(0xFFDBEAFE),
                    icon: Icons.content_paste_search,
                    title: 'Medication Error Reporting',
                    tag: 'COMPLIANCE',
                    tagBg: const Color(0xFFDBEAFE),
                    tagTextColor: const Color(0xFF1E40AF),
                    description:
                        'Standard workflow for logging medication incidents, dosage errors, or adverse reactions.',
                    readTime: '6 min read',
                    badge1: '✓ Risk Management Approved',
                  ),
                  const SizedBox(height: AppSpacing.l),

                  // Annual Compliance Dark Banner
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.l),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: AppSpacing.cardRadius,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0x33FFFFFF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.shield_outlined,
                                size: 14,
                                color: AppColors.white,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Annual Compliance Required',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.m),
                        Text(
                          'Maintain Your Certification',
                          style: AppTextStyles.titleLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Access your personalized learning path, simulation tests, and mandatory compliance logs to keep your status active.',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: const Color(0xFF94A3B8),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.l),
                        Material(
                          color: const Color(0xFF0052CC),
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            onTap: () {},
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: double.infinity,
                              height: 44,
                              alignment: Alignment.center,
                              child: const Text(
                                'Go to LMS Dashboard',
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.s),
                        Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            onTap: () {},
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: double.infinity,
                              height: 44,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: const Color(0xFF475569)),
                              ),
                              child: const Text(
                                'View Compliance Log',
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final Color iconBg;
  final IconData icon;
  final String title;
  final String description;
  final Color linkColor;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.iconBg,
    required this.icon,
    required this.title,
    required this.description,
    required this.linkColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.white, size: 24),
            ),
            const SizedBox(height: AppSpacing.m),
            Text(
              title,
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.m),
            InkWell(
              onTap: onTap,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Explore Protocols',
                    style: TextStyle(
                      color: linkColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_forward, size: 16, color: linkColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SopCard extends StatelessWidget {
  final Color iconBg;
  final IconData icon;
  final String title;
  final String tag;
  final Color tagBg;
  final Color tagTextColor;
  final String description;
  final String readTime;
  final String badge1;
  final String? badge2;

  const _SopCard({
    required this.iconBg,
    required this.icon,
    required this.title,
    required this.tag,
    required this.tagBg,
    required this.tagTextColor,
    required this.description,
    required this.readTime,
    required this.badge1,
    this.badge2,
  });

  @override
  Widget build(BuildContext context) {
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
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: const Color(0xFF0052CC), size: 20),
                ),
                const SizedBox(width: AppSpacing.m),
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.textSecondary),
              ],
            ),
            const SizedBox(height: AppSpacing.s),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: tagBg,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                tag,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: tagTextColor,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: AppSpacing.s),
            Row(
              children: [
                const Icon(
                  Icons.access_time,
                  size: 14,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  readTime,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              badge1,
              style: AppTextStyles.bodySmall.copyWith(
                color: const Color(0xFF15803D),
                fontWeight: FontWeight.bold,
              ),
            ),
            if (badge2 != null) ...[
              const SizedBox(height: 2),
              Text(
                badge2!,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

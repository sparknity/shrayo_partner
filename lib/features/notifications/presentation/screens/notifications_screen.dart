import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Notification list screen matching `Notifications-1.png`.
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _selectedCategoryIndex = 0;

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
          'Notification',
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
                  // Filter Pills Row (Horizontally Scrollable for all screen sizes)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: [
                        _CategoryPill(
                          label: 'All',
                          isSelected: _selectedCategoryIndex == 0,
                          onTap: () => setState(() => _selectedCategoryIndex = 0),
                        ),
                        const SizedBox(width: AppSpacing.s),
                        _CategoryPill(
                          label: 'Unread',
                          isSelected: _selectedCategoryIndex == 1,
                          onTap: () => setState(() => _selectedCategoryIndex = 1),
                        ),
                        const SizedBox(width: AppSpacing.s),
                        _CategoryPill(
                          label: 'Mentions',
                          isSelected: _selectedCategoryIndex == 2,
                          onTap: () => setState(() => _selectedCategoryIndex = 2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.l),

                  // EMERGENCY Section Header
                  Text(
                    'EMERGENCY',
                    style: AppTextStyles.labelSmall.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.6,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s),
                  _NotificationCard(
                    bgColor: const Color(0xFFFFF7ED),
                    borderColor: const Color(0xFFFFEDD5),
                    icon: Icons.emergency,
                    iconBg: const Color(0xFFFFEDD5),
                    iconColor: const Color(0xFFEA580C),
                    title: 'Critical: Fall Detected',
                    timeText: 'Just now',
                    subtitle: 'Patient in Room 402 triggered the motion sensor.',
                    hasUnreadDot: true,
                    unreadDotColor: const Color(0xFFEA580C),
                    onTap: () => context.push('/notifications/notif-101'),
                  ),
                  const SizedBox(height: AppSpacing.l),

                  // RECENT Section Header
                  Text(
                    'RECENT',
                    style: AppTextStyles.labelSmall.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.6,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s),

                  // Notification Card 1: Visit Reminder
                  _NotificationCard(
                    bgColor: AppColors.white,
                    borderColor: const Color(0xFFE2E8F0),
                    icon: Icons.calendar_today,
                    iconBg: const Color(0xFFEFF6FF),
                    iconColor: const Color(0xFF0052CC),
                    title: 'Visit Reminder',
                    timeText: '15m ago',
                    subtitle: 'Upcoming medication review...',
                    onTap: () => context.push('/notifications/notif-102'),
                  ),
                  const SizedBox(height: AppSpacing.s),

                  // Notification Card 2: Janet (Supervisor)
                  Card(
                    elevation: 1,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppSpacing.cardRadius,
                      side: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    child: InkWell(
                      onTap: () => context.push('/notifications/notif-103'),
                      borderRadius: AppSpacing.cardRadius,
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.m),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                const CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Color(0xFFCBD5E1),
                                  child: Icon(Icons.person, color: AppColors.white),
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF16A34A),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.chat_bubble,
                                      size: 10,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: AppSpacing.m),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Expanded(
                                        child: Text(
                                          'Janet (Supervisor)',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Color(0xFF0F172A),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Row(
                                        children: const [
                                          Text(
                                            '2h ago',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF0052CC),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(width: 6),
                                          Icon(
                                            Icons.circle,
                                            size: 8,
                                            color: Color(0xFF0052CC),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '"Please review the updated protocols for the overnight..."',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.textSecondary,
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s),

                  // Notification Card 3: System Update
                  _NotificationCard(
                    bgColor: AppColors.white,
                    borderColor: const Color(0xFFE2E8F0),
                    icon: Icons.settings,
                    iconBg: const Color(0xFFF1F5F9),
                    iconColor: AppColors.textSecondary,
                    title: 'System Update',
                    timeText: '4h ago',
                    subtitle: 'Workspace version 2.4.1 is now live.',
                    onTap: () => context.push('/notifications/notif-104'),
                  ),
                  const SizedBox(height: AppSpacing.s),

                  // Notification Card 4: Visit Completed
                  _NotificationCard(
                    bgColor: AppColors.white,
                    borderColor: const Color(0xFFE2E8F0),
                    icon: Icons.event_available,
                    iconBg: const Color(0xFFEFF6FF),
                    iconColor: const Color(0xFF0052CC),
                    title: 'Visit Completed',
                    timeText: '6h ago',
                    subtitle: 'Marcus Thorne marked the visit complete.',
                    onTap: () => context.push('/notifications/notif-105'),
                  ),
                  const SizedBox(height: AppSpacing.l),

                  // YESTERDAY Section Header
                  Text(
                    'YESTERDAY',
                    style: AppTextStyles.labelSmall.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.6,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s),

                  // Notification Card 5: Weekly Report Ready
                  _NotificationCard(
                    bgColor: AppColors.white,
                    borderColor: const Color(0xFFE2E8F0),
                    icon: Icons.assignment_outlined,
                    iconBg: const Color(0xFFF1F5F9),
                    iconColor: AppColors.textSecondary,
                    title: 'Weekly Report Ready',
                    timeText: '1d ago',
                    subtitle: 'Your activity summary for last week is ready.',
                    onTap: () => context.push('/notifications/notif-106'),
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

class _CategoryPill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryPill({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? const Color(0xFF0052CC) : const Color(0xFFE2E8F0),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isSelected ? AppColors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final Color bgColor;
  final Color borderColor;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String timeText;
  final String subtitle;
  final bool hasUnreadDot;
  final Color? unreadDotColor;
  final VoidCallback onTap;

  const _NotificationCard({
    required this.bgColor,
    required this.borderColor,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.timeText,
    required this.subtitle,
    this.hasUnreadDot = false,
    this.unreadDotColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.cardRadius,
        side: BorderSide(color: borderColor),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppSpacing.cardRadius,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.m),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: AppSpacing.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                        const SizedBox(width: 8),
                        Row(
                          children: [
                            Text(
                              timeText,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: hasUnreadDot
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: hasUnreadDot
                                    ? (unreadDotColor ??
                                          const Color(0xFF0052CC))
                                    : AppColors.textSecondary,
                              ),
                            ),
                            if (hasUnreadDot) ...[
                              const SizedBox(width: 6),
                              Icon(
                                Icons.circle,
                                size: 8,
                                color:
                                    unreadDotColor ?? const Color(0xFF0052CC),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

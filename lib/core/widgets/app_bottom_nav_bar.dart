import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Caregiver App bottom navigation bar tab items matching Phase 11 v2 spec:
/// Tab 0: Home (/home)
/// Tab 1: Visits (/visits)
/// Tab 2: Emergency (/emergency)
/// Tab 3: Workspace (/workspace)
enum CaregiverNavTab {
  home('Home', Icons.home_outlined, Icons.home),
  visits('Visits', Icons.assignment_ind_outlined, Icons.assignment_ind),
  emergency('Emergency', Icons.warning_amber_rounded, Icons.warning_rounded),
  workspace('Workspace', Icons.grid_view_outlined, Icons.grid_view);

  const CaregiverNavTab(this.label, this.icon, this.activeIcon);
  final String label;
  final IconData icon;
  final IconData activeIcon;
}

/// Custom Bottom Navigation Bar for the Caregiver App (4 Tabs).
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.unreadNotificationsCount = 0,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final int unreadNotificationsCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: AppSpacing.cardShadow,
        border: const Border(
          top: BorderSide(color: AppColors.borderDivider, width: 0.5),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(CaregiverNavTab.values.length, (index) {
              final tab = CaregiverNavTab.values[index];
              final isSelected = currentIndex == index;

              return Expanded(
                child: InkWell(
                  onTap: () => onTap(index),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isSelected ? tab.activeIcon : tab.icon,
                        size: 24,
                        color: isSelected
                            ? AppColors.primaryBlue
                            : AppColors.textSecondary,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        tab.label,
                        style: AppTextStyles.labelSmall.copyWith(
                          fontSize: 11,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: isSelected
                              ? AppColors.primaryBlue
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

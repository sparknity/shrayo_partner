import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Patient Emergency Information screen matching `Emergency Information.png`.
class EmergencyInformationScreen extends StatelessWidget {
  final Map<String, dynamic> patient;

  const EmergencyInformationScreen({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    final List<String> allergies = List<String>.from(
      patient['allergies'] ?? ['Penicillin', 'Peanuts', 'Latex'],
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: const Color(0xFFFFF1F2),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: AppSpacing.cardRadius,
              side: const BorderSide(color: Color(0xFFFECDD3)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.m),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.warning_amber_rounded, color: Color(0xFFDC2626)),
                      SizedBox(width: 8),
                      Text(
                        'Critical Patient Allergies',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFDC2626),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: allergies
                        .map(
                          (a) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFFFECDD3)),
                            ),
                            child: Text(
                              a,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF991B1B),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.m),
          Card(
            elevation: 1,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: AppSpacing.cardRadius,
              side: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFDBEAFE),
                child: Icon(Icons.person, color: Color(0xFF0052CC)),
              ),
              title: Text(
                patient['emergencyContactName'] ?? 'Emergency Contact (Sarah Chen)',
                style: AppTextStyles.titleSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
              ),
              subtitle: Text(
                patient['emergencyContactPhone'] ?? '+1 (555) 839-2041 (Daughter)',
                style: const TextStyle(color: Color(0xFF64748B)),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.call, color: Color(0xFF0052CC)),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}

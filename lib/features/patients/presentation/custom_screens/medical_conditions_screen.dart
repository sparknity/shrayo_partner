import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/fixtures/patient_fixtures.dart';

/// Medical Conditions custom screen gap placeholder (`custom_screens/medical_conditions_screen.dart`).
class MedicalConditionsScreen extends StatelessWidget {
  const MedicalConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final conditions = PatientFixtures.medicalConditions;

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.m),
      itemCount: conditions.length,
      itemBuilder: (context, index) {
        final item = conditions[index];
        return Card(
          elevation: 1,
          margin: const EdgeInsets.only(bottom: AppSpacing.s),
          child: ListTile(
            title: Text(item['title'], style: AppTextStyles.titleSmall.copyWith(fontWeight: FontWeight.bold)),
            subtitle: Text('${item['severity']} • Diagnosed ${item['diagnosedDate']}\n${item['notes']}'),
            isThreeLine: true,
            leading: const CircleAvatar(
              backgroundColor: AppColors.primaryBlueLight,
              child: Icon(Icons.medical_services_outlined, color: AppColors.primaryBlue),
            ),
          ),
        );
      },
    );
  }
}

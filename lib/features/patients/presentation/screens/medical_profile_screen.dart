import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/fixtures/patient_fixtures.dart';

/// Medical Profile screen matching Screen 2 in Figma Developer Handoff (5).
class MedicalProfileScreen extends StatelessWidget {
  final String id;

  const MedicalProfileScreen({super.key, this.id = 'p-1'});

  @override
  Widget build(BuildContext context) {
    final patient = PatientFixtures.patients.firstWhere(
      (p) => p['id'] == id || p['code'] == id,
      orElse: () => PatientFixtures.patients.first,
    );

    final patientId = patient['id'] as String? ?? 'p-1';
    final patientName = patient['name'] as String? ?? 'Mrs. Sunita Patil';
    final patientCode = patient['code'] as String? ?? '0820-SP';
    final age = patient['age'] ?? 78;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
          onPressed: () => context.canPop() ? context.pop() : context.push('/patients/$patientId'),
        ),
        title: const Text(
          'Medical Profile',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Patient Header Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              patientName,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0F172A),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Patient ID: #$patientCode • Age: $age',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF64748B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0052CC),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Active Care',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 9 Category Navigation Cards
                  _CategoryCard(
                    icon: Icons.monitor_heart_outlined,
                    iconBg: const Color(0xFFEFF6FF),
                    iconColor: const Color(0xFF0052CC),
                    title: 'Medical Conditions',
                    onTap: () {
                      // Navigate to Medicines Management as requested in flow
                      context.push('/patients/$patientId/medicines');
                    },
                  ),
                  const SizedBox(height: 10),

                  _CategoryCard(
                    icon: Icons.warning_amber_rounded,
                    iconBg: const Color(0xFFFEE2E2),
                    iconColor: const Color(0xFFEF4444),
                    title: 'Allergies',
                    onTap: () {
                      _showInfoDialog(
                        context,
                        title: 'Allergies',
                        content: 'Known Allergies: Penicillin, Sulfa Drugs.\nReaction: Mild skin rash, hives.\nSeverity: Moderate.',
                      );
                    },
                  ),
                  const SizedBox(height: 10),

                  _CategoryCard(
                    icon: Icons.healing_outlined,
                    iconBg: const Color(0xFFDCFCE7),
                    iconColor: const Color(0xFF16A34A),
                    title: 'Past Surgeries',
                    onTap: () {
                      _showInfoDialog(
                        context,
                        title: 'Past Surgeries',
                        content: '1. Bilateral Cataract Surgery (2019)\n2. Appendectomy (1998)\nNo surgical complications noted.',
                      );
                    },
                  ),
                  const SizedBox(height: 10),

                  _CategoryCard(
                    icon: Icons.assignment_outlined,
                    iconBg: const Color(0xFFEFF6FF),
                    iconColor: const Color(0xFF0052CC),
                    title: 'Current Diagnoses',
                    onTap: () {
                      _showInfoDialog(
                        context,
                        title: 'Current Diagnoses',
                        content: '• Type 2 Diabetes Mellitus (E11.9)\n• Essential Hypertension (I10)\n• Bilateral Knee Osteoarthritis (M17.0)',
                      );
                    },
                  ),
                  const SizedBox(height: 10),

                  _CategoryCard(
                    icon: Icons.self_improvement_outlined,
                    iconBg: const Color(0xFFF1F5F9),
                    iconColor: const Color(0xFF475569),
                    title: 'Lifestyle Habits',
                    onTap: () {
                      _showInfoDialog(
                        context,
                        title: 'Lifestyle Habits',
                        content: '• Diet: Low sodium, diabetic renal diet\n• Exercise: Light 15-minute assisted morning walk\n• Sleep: 7-8 hours nightly',
                      );
                    },
                  ),
                  const SizedBox(height: 10),

                  _CategoryCard(
                    icon: Icons.accessible_outlined,
                    iconBg: const Color(0xFFEFF6FF),
                    iconColor: const Color(0xFF0052CC),
                    title: 'Mobility Status',
                    onTap: () {
                      _showInfoDialog(
                        context,
                        title: 'Mobility Status',
                        content: '• Status: Walking with support (Walker/Cane)\n• Transfer: Independent with supervision\n• Fall Risk: High (History of slip in 2022)',
                      );
                    },
                  ),
                  const SizedBox(height: 10),

                  _CategoryCard(
                    icon: Icons.vaccines_outlined,
                    iconBg: const Color(0xFFDCFCE7),
                    iconColor: const Color(0xFF16A34A),
                    title: 'Vaccination History',
                    onTap: () {
                      _showInfoDialog(
                        context,
                        title: 'Vaccination History',
                        content: '• Influenza: Oct 2023 (Up to date)\n• Pneumococcal: Sep 2022\n• COVID-19 Booster: Nov 2023',
                      );
                    },
                  ),
                  const SizedBox(height: 10),

                  _CategoryCard(
                    icon: Icons.shield_outlined,
                    iconBg: const Color(0xFFEFF6FF),
                    iconColor: const Color(0xFF0052CC),
                    title: 'Insurance Information',
                    onTap: () {
                      _showInfoDialog(
                        context,
                        title: 'Insurance Information',
                        content: 'Provider: Star Health Senior Care\nPolicy Number: SH-998234-A\nCoverage: Comprehensive In-Home & Hospitalization',
                      );
                    },
                  ),
                  const SizedBox(height: 10),

                  _CategoryCard(
                    icon: Icons.event_note_outlined,
                    iconBg: const Color(0xFFDCFCE7),
                    iconColor: const Color(0xFF16A34A),
                    title: 'Current Treatment Plan',
                    onTap: () {
                      _showInfoDialog(
                        context,
                        title: 'Current Treatment Plan',
                        content: '1. Glycemic & BP control regimen\n2. Physiotherapy 3x/week for knee mobility\n3. Bi-weekly nurse home visit assessment',
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context, {required String title, required String content}) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.info_outline, color: Color(0xFF0052CC), size: 22),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        content: Text(
          content,
          style: const TextStyle(fontSize: 13.5, color: Color(0xFF334155), height: 1.45),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              'Close',
              style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF0052CC)),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.015),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: Color(0xFF94A3B8),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

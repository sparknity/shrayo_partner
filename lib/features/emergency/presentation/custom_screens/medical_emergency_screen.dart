import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Screen 2: Report Patient Emergency matching 2.png in Developer Handoff (5).
class MedicalEmergencyScreen extends StatefulWidget {
  const MedicalEmergencyScreen({super.key});

  @override
  State<MedicalEmergencyScreen> createState() => _MedicalEmergencyScreenState();
}

class _MedicalEmergencyScreenState extends State<MedicalEmergencyScreen> {
  String _selectedCategory = 'Fall / Injury';

  final List<Map<String, dynamic>> _categories = [
    {
      'id': 'med_emergency',
      'title': 'Medical Emergency',
      'subtitle': 'Chest pain, seizure, stroke',
      'icon': Icons.medical_services_outlined,
      'color': Color(0xFF0052CC),
    },
    {
      'id': 'fall_injury',
      'title': 'Fall / Injury',
      'subtitle': 'Slipped, fracture, bleeding',
      'icon': Icons.person_outline,
      'color': Color(0xFF16A34A),
    },
    {
      'id': 'breathing',
      'title': 'Breathing Difficulty',
      'subtitle': 'Shortness of breath, asthma',
      'icon': Icons.air,
      'color': Color(0xFF334155),
    },
    {
      'id': 'cardiac',
      'title': 'Cardiac Symptoms',
      'subtitle': 'Irregular heartbeat, discomfort',
      'icon': Icons.monitor_heart_outlined,
      'color': Color(0xFFEF4444),
    },
    {
      'id': 'unresponsive',
      'title': 'Unresponsive',
      'subtitle': 'Patient unconscious',
      'icon': Icons.volume_off_outlined,
      'color': Color(0xFF475569),
    },
    {
      'id': 'med_reaction',
      'title': 'Medication Reaction',
      'subtitle': 'Allergic, overdose',
      'icon': Icons.medication_outlined,
      'color': Color(0xFF16A34A),
    },
    {
      'id': 'mental_health',
      'title': 'Mental Health',
      'subtitle': 'Anxiety, confusion',
      'icon': Icons.psychology_outlined,
      'color': Color(0xFF0052CC),
    },
    {
      'id': 'other',
      'title': 'Other Emergency',
      'subtitle': 'Miscellaneous incident',
      'icon': Icons.warning_amber_rounded,
      'color': Color(0xFF64748B),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
          onPressed: () => context.canPop() ? context.pop() : context.go('/emergency'),
        ),
        title: const Text(
          'Report Patient Emergency',
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Recently Used
                  const Text(
                    'RECENTLY USED',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF64748B),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _RecentlyUsedPill(
                        icon: Icons.directions_walk,
                        label: 'Fall / Injury',
                        iconColor: const Color(0xFF16A34A),
                        isSelected: _selectedCategory == 'Fall / Injury',
                        onTap: () => setState(() => _selectedCategory = 'Fall / Injury'),
                      ),
                      const SizedBox(width: 8),
                      _RecentlyUsedPill(
                        icon: Icons.medical_services_outlined,
                        label: 'Medical Emergency',
                        iconColor: const Color(0xFF0052CC),
                        isSelected: _selectedCategory == 'Medical Emergency',
                        onTap: () => setState(() => _selectedCategory = 'Medical Emergency'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 2. 8-Category Emergency Grid (2x4)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.12,
                    ),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      final isSelected = _selectedCategory == cat['title'];

                      return Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedCategory = cat['title'];
                            });
                          },
                          borderRadius: BorderRadius.circular(18),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFFEFF6FF) : Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: isSelected ? const Color(0xFF0052CC) : const Color(0xFFE2E8F0),
                                width: isSelected ? 1.8 : 1.0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.015),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  cat['icon'] as IconData,
                                  color: cat['color'] as Color,
                                  size: 24,
                                ),
                                const Spacer(),
                                Text(
                                  cat['title'] as String,
                                  style: const TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF0F172A),
                                    height: 1.2,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  cat['subtitle'] as String,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF64748B),
                                    height: 1.2,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // 3. Emergency Reminder Box
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFDBEAFE)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.info,
                          color: Color(0xFF0052CC),
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Emergency Reminder',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0052CC),
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                'Always prioritize patient safety. If the patient is in immediate danger, call EMS (911) first before documenting.',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: Color(0xFF334155),
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 4. Action Buttons
                  Material(
                    color: const Color(0xFF0052CC),
                    borderRadius: BorderRadius.circular(14),
                    child: InkWell(
                      onTap: () => context.push('/emergency/analyze'),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        alignment: Alignment.center,
                        child: const Text(
                          'Continue to Assessment',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 15.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: TextButton(
                      onPressed: () => context.pop(),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RecentlyUsedPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;
  final bool isSelected;
  final VoidCallback onTap;

  const _RecentlyUsedPill({
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? const Color(0xFFEFF6FF) : Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? const Color(0xFF0052CC) : const Color(0xFFCBD5E1),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: iconColor, size: 16),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

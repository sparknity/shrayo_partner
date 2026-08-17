import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../patients/data/fixtures/patient_fixtures.dart';

/// Screen 3: Emergency Assessment matching 3.png in Developer Handoff (5).
class AnalyzeSituationScreen extends StatefulWidget {
  const AnalyzeSituationScreen({super.key});

  @override
  State<AnalyzeSituationScreen> createState() => _AnalyzeSituationScreenState();
}

class _AnalyzeSituationScreenState extends State<AnalyzeSituationScreen> {
  bool _isConscious = true;
  String _bleedingStatus = 'None'; // 'None', 'Minor', 'Severe'
  String _mobilityStatus = 'With Assistance'; // 'Yes, fully mobile', 'With Assistance', 'No, immobilized'
  double _painLevel = 7.0;
  final Set<String> _selectedSymptoms = {'Fracture Suspected', 'Confusion'};
  final TextEditingController _notesCtrl = TextEditingController();

  final List<String> _symptomOptions = [
    'Swelling',
    'Fracture Suspected',
    'Head Injury',
    'Vomiting',
    'Confusion',
    'Difficulty Speaking',
    'Other',
  ];

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final patient = PatientFixtures.patients.first;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
          onPressed: () => context.canPop() ? context.pop() : context.go('/emergency/medical'),
        ),
        title: const Text(
          'Emergency Assessment',
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
                  const Text(
                    'Emergency Assessment',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Assess the patient\'s current condition.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Patient Info Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
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
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: CachedNetworkImage(
                                imageUrl: patient['avatarUrl'] ??
                                    'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400',
                                width: 52,
                                height: 52,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  width: 52,
                                  height: 52,
                                  color: const Color(0xFFCBD5E1),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    patient['name'] ?? 'Mrs. Sunita Patil',
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF0F172A),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'ID: ${patient['code'] ?? '8829-SP'} • ${patient['age'] ?? 78} Years • ${patient['gender'] ?? 'Female'}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF64748B),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: const [
                            _AssessmentTag('DIABETIC'),
                            _AssessmentTag('CARDIAC'),
                            _AssessmentTag('HIGH FALL RISK'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 1. Is the patient conscious?
                  const Text(
                    '1. Is the patient conscious?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _ChoiceButton(
                          label: 'Yes',
                          isSelected: _isConscious,
                          onTap: () => setState(() => _isConscious = true),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ChoiceButton(
                          label: 'No',
                          isSelected: !_isConscious,
                          onTap: () => setState(() => _isConscious = false),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 2. Is there visible bleeding?
                  const Text(
                    '2. Is there visible bleeding?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _ChoiceButton(
                          label: 'None',
                          isSelected: _bleedingStatus == 'None',
                          onTap: () => setState(() => _bleedingStatus = 'None'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _ChoiceButton(
                          label: 'Minor',
                          isSelected: _bleedingStatus == 'Minor',
                          onTap: () => setState(() => _bleedingStatus = 'Minor'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _ChoiceButton(
                          label: 'Severe',
                          isDanger: true,
                          isSelected: _bleedingStatus == 'Severe',
                          onTap: () => setState(() => _bleedingStatus = 'Severe'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 3. Can the patient move independently?
                  const Text(
                    '3. Can the patient move independently?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _MobilityOptionCard(
                    title: 'Yes, fully mobile',
                    isSelected: _mobilityStatus == 'Yes, fully mobile',
                    onTap: () => setState(() => _mobilityStatus = 'Yes, fully mobile'),
                  ),
                  const SizedBox(height: 8),
                  _MobilityOptionCard(
                    title: 'With Assistance',
                    isSelected: _mobilityStatus == 'With Assistance',
                    onTap: () => setState(() => _mobilityStatus = 'With Assistance'),
                  ),
                  const SizedBox(height: 8),
                  _MobilityOptionCard(
                    title: 'No, immobilized',
                    isSelected: _mobilityStatus == 'No, immobilized',
                    onTap: () => setState(() => _mobilityStatus = 'No, immobilized'),
                  ),
                  const SizedBox(height: 20),

                  // 4. Pain Level Slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '4. Pain Level',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        _painLevel.round().toString(),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0052CC),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: const Color(0xFF0052CC),
                      inactiveTrackColor: const Color(0xFFE2E8F0),
                      thumbColor: const Color(0xFF0052CC),
                      overlayColor: const Color(0xFF0052CC).withValues(alpha: 0.15),
                      trackHeight: 6,
                    ),
                    child: Slider(
                      value: _painLevel,
                      min: 0,
                      max: 10,
                      divisions: 10,
                      onChanged: (val) => setState(() => _painLevel = val),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        '0 - No Pain',
                        style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '10 - Excruciating',
                        style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 5. Additional Symptoms
                  const Text(
                    '5. Additional Symptoms',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _symptomOptions.map((sym) {
                      final isSelected = _selectedSymptoms.contains(sym);
                      return FilterChip(
                        label: Text(sym),
                        selected: isSelected,
                        selectedColor: const Color(0xFF0052CC),
                        backgroundColor: Colors.white,
                        labelStyle: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : const Color(0xFF0F172A),
                        ),
                        side: BorderSide(
                          color: isSelected ? const Color(0xFF0052CC) : const Color(0xFFCBD5E1),
                        ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        showCheckmark: false,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedSymptoms.add(sym);
                            } else {
                              _selectedSymptoms.remove(sym);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Optional Notes
                  const Text(
                    'Optional Notes',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: TextField(
                      controller: _notesCtrl,
                      maxLines: 3,
                      style: const TextStyle(fontSize: 13.5, color: Color(0xFF0F172A)),
                      decoration: const InputDecoration(
                        hintText: 'Add important observations...',
                        hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                        contentPadding: EdgeInsets.all(14),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Bottom Action Buttons
                  Material(
                    color: const Color(0xFF0052CC),
                    borderRadius: BorderRadius.circular(14),
                    child: InkWell(
                      onTap: () => context.push('/emergency/start-response'),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        alignment: Alignment.center,
                        child: const Text(
                          'Analyze Situation',
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
                  Material(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(14),
                    child: InkWell(
                      onTap: () => context.pop(),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        width: double.infinity,
                        height: 48,
                        alignment: Alignment.center,
                        child: const Text(
                          'Cancel Assessment',
                          style: TextStyle(
                            color: Color(0xFF475569),
                            fontWeight: FontWeight.w700,
                            fontSize: 14.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AssessmentTag extends StatelessWidget {
  final String label;

  const _AssessmentTag(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFED7AA)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w800,
          color: Color(0xFFD97706),
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _ChoiceButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isDanger;
  final VoidCallback onTap;

  const _ChoiceButton({
    required this.label,
    required this.isSelected,
    this.isDanger = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor;
    Color textColor;
    Color bgColor;

    if (isSelected) {
      borderColor = const Color(0xFF0052CC);
      textColor = const Color(0xFF0052CC);
      bgColor = const Color(0xFFEFF6FF);
    } else {
      borderColor = const Color(0xFFCBD5E1);
      textColor = isDanger ? const Color(0xFFDC2626) : const Color(0xFF0F172A);
      bgColor = Colors.white;
    }

    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 46,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor, width: isSelected ? 1.8 : 1.0),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _MobilityOptionCard extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _MobilityOptionCard({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? const Color(0xFFEFF6FF) : Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? const Color(0xFF0052CC) : const Color(0xFFCBD5E1),
              width: isSelected ? 1.8 : 1.0,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
              Icon(
                isSelected ? Icons.check_circle : Icons.circle_outlined,
                color: isSelected ? const Color(0xFF0052CC) : const Color(0xFF94A3B8),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Screen 14: Parent Details & Clinical Mood/Mobility Assessment matching `14.png`.
class CareAssessmentScreen extends StatefulWidget {
  const CareAssessmentScreen({super.key});

  @override
  State<CareAssessmentScreen> createState() => _CareAssessmentScreenState();
}

class _CareAssessmentScreenState extends State<CareAssessmentScreen> {
  bool _greetingCompleted = true;
  String _selectedFeeling = 'Good';
  String _selectedMood = 'Happy';
  String _selectedMobility = 'Walking Independently';
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Parent Details',
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Patient Header Card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: CachedNetworkImage(
                                imageUrl:
                                    'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400',
                                width: 68,
                                height: 68,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  width: 68,
                                  height: 68,
                                  color: const Color(0xFFCBD5E1),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  width: 68,
                                  height: 68,
                                  color: const Color(0xFFCBD5E1),
                                  alignment: Alignment.center,
                                  child: const Text('SP'),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Mrs. Sunita Patil',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  const Text(
                                    'Age: 78 • ID: #PT- 8842',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEFF6FF),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text(
                                      'Routine Wellness',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF0052CC),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFE4E6),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Text(
                                '✱ Diabetes',
                                style: TextStyle(
                                  color: Color(0xFFE11D48),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFE4E6),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(
                                    Icons.directions_run,
                                    color: Color(0xFFE11D48),
                                    size: 14,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'High Fall Risk',
                                    style: TextStyle(
                                      color: Color(0xFFE11D48),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Greeting Completed Toggle Card
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.waving_hand_outlined,
                          color: Color(0xFF0052CC),
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Greeting Completed',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                        ),
                        Switch(
                          value: _greetingCompleted,
                          activeTrackColor: const Color(0xFF0052CC),
                          onChanged: (val) => setState(() => _greetingCompleted = val),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Section: How is the patient feeling overall?
                  const Text(
                    'How is the patient feeling overall?',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 12),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 2.1,
                    children: [
                      _FeelingOptionTile(
                        icon: Icons.sentiment_very_satisfied,
                        iconColor: const Color(0xFF16A34A),
                        label: 'Excellent',
                        isSelected: _selectedFeeling == 'Excellent',
                        onTap: () => setState(() => _selectedFeeling = 'Excellent'),
                      ),
                      _FeelingOptionTile(
                        icon: Icons.sentiment_satisfied_alt,
                        iconColor: const Color(0xFF16A34A),
                        label: 'Good',
                        isSelected: _selectedFeeling == 'Good',
                        onTap: () => setState(() => _selectedFeeling = 'Good'),
                      ),
                      _FeelingOptionTile(
                        icon: Icons.sentiment_neutral,
                        iconColor: const Color(0xFF64748B),
                        label: 'Fair',
                        isSelected: _selectedFeeling == 'Fair',
                        onTap: () => setState(() => _selectedFeeling = 'Fair'),
                      ),
                      _FeelingOptionTile(
                        icon: Icons.sentiment_dissatisfied,
                        iconColor: const Color(0xFFDC2626),
                        label: 'Poor',
                        isSelected: _selectedFeeling == 'Poor',
                        onTap: () => setState(() => _selectedFeeling = 'Poor'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Section: Mood Observation
                  const Text(
                    'Mood Observation',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: [
                        _MoodTile(
                          emoji: '😊',
                          label: 'Happy',
                          isSelected: _selectedMood == 'Happy',
                          onTap: () => setState(() => _selectedMood = 'Happy'),
                        ),
                        const SizedBox(width: 10),
                        _MoodTile(
                          emoji: '😌',
                          label: 'Calm',
                          isSelected: _selectedMood == 'Calm',
                          onTap: () => setState(() => _selectedMood = 'Calm'),
                        ),
                        const SizedBox(width: 10),
                        _MoodTile(
                          emoji: '😐',
                          label: 'Neutral',
                          isSelected: _selectedMood == 'Neutral',
                          onTap: () => setState(() => _selectedMood = 'Neutral'),
                        ),
                        const SizedBox(width: 10),
                        _MoodTile(
                          emoji: '😰',
                          label: 'Anxious',
                          isSelected: _selectedMood == 'Anxious',
                          onTap: () => setState(() => _selectedMood = 'Anxious'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Section: Mobility Status
                  const Text(
                    'Mobility Status',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _MobilityOptionTile(
                    icon: Icons.directions_walk,
                    label: 'Walking Independently',
                    isSelected: _selectedMobility == 'Walking Independently',
                    onTap: () =>
                        setState(() => _selectedMobility = 'Walking Independently'),
                  ),
                  const SizedBox(height: 10),
                  _MobilityOptionTile(
                    icon: Icons.nordic_walking,
                    label: 'Walking Stick',
                    isSelected: _selectedMobility == 'Walking Stick',
                    onTap: () =>
                        setState(() => _selectedMobility = 'Walking Stick'),
                  ),
                  const SizedBox(height: 10),
                  _MobilityOptionTile(
                    icon: Icons.accessible,
                    label: 'Wheelchair',
                    isSelected: _selectedMobility == 'Wheelchair',
                    onTap: () => setState(() => _selectedMobility = 'Wheelchair'),
                  ),
                  const SizedBox(height: 10),
                  _MobilityOptionTile(
                    icon: Icons.bed,
                    label: 'Bedridden',
                    isSelected: _selectedMobility == 'Bedridden',
                    onTap: () => setState(() => _selectedMobility = 'Bedridden'),
                  ),
                  const SizedBox(height: 20),

                  // Section: Additional Observations
                  const Text(
                    'Additional Observations',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFCBD5E1)),
                    ),
                    padding: const EdgeInsets.all(14),
                    child: TextField(
                      controller: _notesController,
                      maxLines: 4,
                      style: const TextStyle(fontSize: 14, color: Color(0xFF0F172A)),
                      decoration: const InputDecoration(
                        hintText:
                            'Type your notes here about behavior, conversation, or physical changes...',
                        hintStyle:
                            TextStyle(color: Color(0xFF94A3B8), fontSize: 13.5),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Continue Button
                  Material(
                    color: const Color(0xFF0052CC),
                    borderRadius: BorderRadius.circular(14),
                    child: InkWell(
                      onTap: () => context.push('/visits/assessment/blood-pressure'),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        width: double.infinity,
                        height: 52,
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'Continue',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FeelingOptionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FeelingOptionTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? const Color(0xFFEFF6FF) : Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? const Color(0xFF0052CC) : const Color(0xFFE2E8F0),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: iconColor, size: 22),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected ? const Color(0xFF0052CC) : const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MoodTile extends StatelessWidget {
  final String emoji;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _MoodTile({
    required this.emoji,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? const Color(0xFFEFF6FF) : Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 78,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? const Color(0xFF0052CC) : const Color(0xFFE2E8F0),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected ? const Color(0xFF0052CC) : const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MobilityOptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _MobilityOptionTile({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? const Color(0xFFEFF6FF) : Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? const Color(0xFF0052CC) : const Color(0xFFE2E8F0),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFF0052CC), size: 22),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    color: isSelected ? const Color(0xFF0052CC) : const Color(0xFF0F172A),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

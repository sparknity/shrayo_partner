import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Screen 11: Medicine Compliance, Clinical Notes & Visit Photos matching `11.png`.
class SubmitVisitScreen extends StatefulWidget {
  const SubmitVisitScreen({super.key});

  @override
  State<SubmitVisitScreen> createState() => _SubmitVisitScreenState();
}

class _SubmitVisitScreenState extends State<SubmitVisitScreen> {
  String _selectedCompliance = 'Medicine Taken';
  final Set<String> _selectedNotesTags = {'Patient Stable', 'Medicine Given'};
  final TextEditingController _clinicalNotesCtrl = TextEditingController(
    text:
        'Patient condition is stable. Morning medication administered following breakfast. Assisted with light walking exercise in the garden for 15 minutes.',
  );

  @override
  void dispose() {
    _clinicalNotesCtrl.dispose();
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
          'Medicine Compliance',
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
                  // Section 1: Medicine Compliance
                  Row(
                    children: const [
                      Icon(
                        Icons.medical_services_outlined,
                        color: Color(0xFF0052CC),
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Medicine Compliance',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Compliance Buttons Grid / Flow
                  Row(
                    children: [
                      Expanded(
                        child: _ComplianceButton(
                          icon: Icons.check,
                          iconColor: const Color(0xFF16A34A),
                          label: 'Medicine Taken',
                          isSelected: _selectedCompliance == 'Medicine Taken',
                          onTap: () =>
                              setState(() => _selectedCompliance = 'Medicine Taken'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ComplianceButton(
                          icon: Icons.history,
                          iconColor: const Color(0xFF0052CC),
                          label: 'Already Taken',
                          isSelected: _selectedCompliance == 'Already Taken',
                          onTap: () =>
                              setState(() => _selectedCompliance = 'Already Taken'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _ComplianceButton(
                          icon: Icons.close,
                          iconColor: const Color(0xFFDC2626),
                          label: 'Missed',
                          isSelected: _selectedCompliance == 'Missed',
                          onTap: () =>
                              setState(() => _selectedCompliance = 'Missed'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ComplianceButton(
                          icon: Icons.block,
                          iconColor: const Color(0xFF334155),
                          label: 'Refused',
                          isSelected: _selectedCompliance == 'Refused',
                          onTap: () =>
                              setState(() => _selectedCompliance = 'Refused'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _ComplianceButton(
                    icon: Icons.inventory_2_outlined,
                    iconColor: const Color(0xFF64748B),
                    label: 'Medicine Not Available',
                    isSelected: _selectedCompliance == 'Medicine Not Available',
                    onTap: () =>
                        setState(() => _selectedCompliance = 'Medicine Not Available'),
                  ),
                  const SizedBox(height: 24),

                  // Section 2: Visit Notes
                  Row(
                    children: const [
                      Icon(
                        Icons.description_outlined,
                        color: Color(0xFF0052CC),
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Visit Notes',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Quick Suggestion Chips
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      'Patient Stable',
                      'Medicine Given',
                      'Needs Follow-up',
                      'Family Updated',
                      'Recommended Doctor Visit',
                    ].map((tag) {
                      final isSelected = _selectedNotesTags.contains(tag);
                      return InkWell(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedNotesTags.remove(tag);
                            } else {
                              _selectedNotesTags.add(tag);
                            }
                          });
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFEFF6FF)
                                : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF0052CC)
                                  : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight:
                                  isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isSelected
                                  ? const Color(0xFF0052CC)
                                  : const Color(0xFF334155),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),

                  // Notes Text Box
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFCBD5E1)),
                    ),
                    padding: const EdgeInsets.all(14),
                    child: TextField(
                      controller: _clinicalNotesCtrl,
                      maxLines: 5,
                      style: const TextStyle(fontSize: 14, color: Color(0xFF0F172A)),
                      decoration: const InputDecoration(
                        hintText: 'Type detailed clinical notes here...',
                        hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 13.5),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Section 3: Visit Photos
                  Row(
                    children: const [
                      Icon(
                        Icons.camera_alt_outlined,
                        color: Color(0xFF0052CC),
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Visit Photos',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: [
                        // Capture Photo Dashed Box
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F7FF),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFF93C5FD),
                              style: BorderStyle.solid,
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.add_a_photo_outlined,
                                color: Color(0xFF0052CC),
                                size: 24,
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Capture\nPhoto',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0052CC),
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Thumbnail 1: Pill organizer
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: CachedNetworkImage(
                            imageUrl:
                                'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=300',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Thumbnail 2: BP monitor
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: CachedNetworkImage(
                            imageUrl:
                                'https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?w=300',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Review Visit Button
                  Material(
                    color: const Color(0xFF0052CC),
                    borderRadius: BorderRadius.circular(14),
                    child: InkWell(
                      onTap: () => context.push('/visits/review'),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        width: double.infinity,
                        height: 52,
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'Review Visit',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(width: 6),
                            Icon(
                              Icons.chevron_right,
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

class _ComplianceButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ComplianceButton({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.isSelected,
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
            border: Border.all(
              color: isSelected ? const Color(0xFF0052CC) : const Color(0xFFE2E8F0),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: iconColor, size: 18),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    color: const Color(0xFF0F172A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

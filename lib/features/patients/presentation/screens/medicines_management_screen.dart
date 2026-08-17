import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/fixtures/patient_fixtures.dart';

/// Medicines Management screen matching Screen 3 in Figma Developer Handoff (5).
class MedicinesManagementScreen extends StatefulWidget {
  final String id;

  const MedicinesManagementScreen({super.key, this.id = 'p-1'});

  @override
  State<MedicinesManagementScreen> createState() => _MedicinesManagementScreenState();
}

class _MedicinesManagementScreenState extends State<MedicinesManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _activeFilter = 'All'; // 'All', 'Pending', 'Taken'

  // Local state for interactive "Mark as Given -> Completed"
  late List<Map<String, dynamic>> _medList;

  @override
  void initState() {
    super.initState();
    _medList = PatientFixtures.medicines.map((m) => Map<String, dynamic>.from(m)).toList();
    _searchController.addListener(() {
      final query = _searchController.text.trim();
      if (_searchQuery != query) {
        setState(() {
          _searchQuery = query;
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _markAsGiven(int index) {
    setState(() {
      _medList[index]['status'] = 'Taken';
      _medList[index]['loggedAt'] = 'Just now';
    });

    final medName = _medList[index]['name'] ?? 'Medication';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Color(0xFF22C55E), size: 18),
            const SizedBox(width: 8),
            Text(
              '$medName marked as Given / Completed',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF0F172A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  List<Map<String, dynamic>> get _filteredMedicines {
    return _medList.where((med) {
      final name = (med['name'] as String? ?? '').toLowerCase();
      final dosage = (med['dosage'] as String? ?? '').toLowerCase();
      final status = (med['status'] as String? ?? '').toLowerCase();

      // Search filter
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        if (!name.contains(q) && !dosage.contains(q)) {
          return false;
        }
      }

      // Pill filter
      if (_activeFilter == 'Pending') {
        return status == 'pending' || status == 'upcoming';
      } else if (_activeFilter == 'Taken') {
        return status == 'taken' || status == 'completed';
      }

      return true;
    }).toList();
  }

  int get _totalCount => _medList.length;
  int get _pendingCount => _medList.where((m) => m['status'] == 'Pending' || m['status'] == 'Upcoming').length;
  int get _takenCount => _medList.where((m) => m['status'] == 'Taken').length;

  @override
  Widget build(BuildContext context) {
    final patientId = widget.id.isNotEmpty ? widget.id : 'p-1';
    final filtered = _filteredMedicines;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
          onPressed: () => context.canPop() ? context.pop() : context.push('/patients/$patientId/medical-profile'),
        ),
        title: const Text(
          'Medicines',
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
            child: Column(
              children: [
                // Top Search Bar & Filter Chips
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    children: [
                      // Search field
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: TextField(
                          controller: _searchController,
                          style: const TextStyle(fontSize: 14, color: Color(0xFF0F172A)),
                          decoration: const InputDecoration(
                            hintText: 'Search medication name...',
                            hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 13.5),
                            prefixIcon: Icon(Icons.search, color: Color(0xFF94A3B8), size: 20),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Filter Pills Row
                      Row(
                        children: [
                          _FilterPill(
                            label: 'All ($_totalCount)',
                            isSelected: _activeFilter == 'All',
                            onTap: () => setState(() => _activeFilter = 'All'),
                          ),
                          const SizedBox(width: 8),
                          _FilterPill(
                            label: 'Pending ($_pendingCount)',
                            isSelected: _activeFilter == 'Pending',
                            onTap: () => setState(() => _activeFilter = 'Pending'),
                          ),
                          const SizedBox(width: 8),
                          _FilterPill(
                            label: 'Taken ($_takenCount)',
                            isSelected: _activeFilter == 'Taken',
                            onTap: () => setState(() => _activeFilter = 'Taken'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),

                // Medicines List
                Expanded(
                  child: filtered.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.medication_liquid_outlined, size: 48, color: Color(0xFF94A3B8)),
                              SizedBox(height: 12),
                              Text(
                                'No medications found',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final med = filtered[index];
                            final originalIndex = _medList.indexOf(med);
                            final status = med['status'] as String? ?? 'Pending';
                            final isTaken = status == 'Taken';

                            return _MedicationCard(
                              med: med,
                              isTaken: isTaken,
                              onMarkGiven: () => _markAsGiven(originalIndex),
                              onEyeIconTap: () {
                                // Navigate to Health Timeline screen
                                context.push('/patients/$patientId/health-timeline');
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterPill({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? const Color(0xFF0052CC) : Colors.white,
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
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: isSelected ? Colors.white : const Color(0xFF475569),
            ),
          ),
        ),
      ),
    );
  }
}

class _MedicationCard extends StatelessWidget {
  final Map<String, dynamic> med;
  final bool isTaken;
  final VoidCallback onMarkGiven;
  final VoidCallback onEyeIconTap;

  const _MedicationCard({
    required this.med,
    required this.isTaken,
    required this.onMarkGiven,
    required this.onEyeIconTap,
  });

  @override
  Widget build(BuildContext context) {
    final status = med['status'] as String? ?? 'Pending';
    final name = med['name'] as String? ?? '';
    final dosage = med['dosage'] as String? ?? '';
    final form = med['form'] as String? ?? '1 Tablet';
    final frequency = med['frequency'] as String?;
    final schedule = med['schedule'] as String? ?? '09:00 AM';
    final loggedAt = med['loggedAt'] as String?;
    final instructions = med['instructions'] as String?;

    Color badgeBg;
    Color badgeText;
    if (status == 'Taken') {
      badgeBg = const Color(0xFFDCFCE7);
      badgeText = const Color(0xFF15803D);
    } else if (status == 'Upcoming') {
      badgeBg = const Color(0xFFE0F2FE);
      badgeText = const Color(0xFF0284C7);
    } else {
      badgeBg = const Color(0xFFFEF3C7);
      badgeText = const Color(0xFFD97706);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Icon, Name + Dosage, Status Badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isTaken ? const Color(0xFFDCFCE7) : const Color(0xFFFFF7ED),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.medication,
                  color: isTaken ? const Color(0xFF16A34A) : const Color(0xFFD97706),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$dosage • $form',
                      style: const TextStyle(
                        fontSize: 12.5,
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
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: badgeText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Metadata Details (Frequency / Schedule / Logged At)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFF1F5F9)),
            ),
            child: Row(
              children: [
                if (frequency != null) ...[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'FREQUENCY',
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF94A3B8),
                            letterSpacing: 0.4,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          frequency,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'SCHEDULE',
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF94A3B8),
                          letterSpacing: 0.4,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        schedule,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                ),
                if (loggedAt != null) ...[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'LOGGED AT',
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF94A3B8),
                            letterSpacing: 0.4,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          loggedAt,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF16A34A),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          if (instructions != null && instructions.isNotEmpty) ...[
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Instructions: ',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
                  ),
                ),
                Expanded(
                  child: Text(
                    instructions,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 14),

          // Bottom Action Row: [ Mark as Given / Completed ] + [ 👁️ Eye Icon ]
          Row(
            children: [
              Expanded(
                child: isTaken
                    ? Container(
                        height: 42,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.check_circle_outline, color: Color(0xFF64748B), size: 16),
                            SizedBox(width: 6),
                            Text(
                              'Completed',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Material(
                        color: const Color(0xFF0052CC),
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          onTap: onMarkGiven,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            height: 42,
                            alignment: Alignment.center,
                            child: const Text(
                              'Mark as Given',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
              const SizedBox(width: 10),
              // Eye Icon Button
              Material(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: onEyeIconTap,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFDBEAFE)),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.visibility_outlined,
                      color: Color(0xFF0052CC),
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

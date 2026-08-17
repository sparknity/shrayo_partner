import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Request Leave screen matching `Request Leave.png` (`/workspace/leave`).
class RequestLeaveScreen extends StatefulWidget {
  const RequestLeaveScreen({super.key});

  @override
  State<RequestLeaveScreen> createState() => _RequestLeaveScreenState();
}

class _RequestLeaveScreenState extends State<RequestLeaveScreen> {
  String selectedLeaveType = 'Medical/Sick Leave';
  final TextEditingController _startDateCtrl = TextEditingController(text: '10/24/2023');
  final TextEditingController _endDateCtrl = TextEditingController(text: '10/26/2023');
  final TextEditingController _reasonCtrl = TextEditingController(
    text: 'Recovering from a severe seasonal flu. Doctor has advised 3 days of complete bed rest.',
  );

  @override
  void dispose() {
    _startDateCtrl.dispose();
    _endDateCtrl.dispose();
    _reasonCtrl.dispose();
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
          onPressed: () => context.canPop() ? context.pop() : context.go('/workspace'),
        ),
        title: const Text(
          'Leave Request',
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
            constraints: const BoxConstraints(maxWidth: 600),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Form Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Leave Details',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Please fill out the form below to submit your leave request for approval.',
                          style: TextStyle(fontSize: 13, color: Color(0xFF64748B), height: 1.4),
                        ),
                        const SizedBox(height: 20),

                        // Leave Type
                        const Text('Leave Type', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: selectedLeaveType,
                              items: const [
                                DropdownMenuItem(value: 'Medical/Sick Leave', child: Text('Medical/Sick Leave')),
                                DropdownMenuItem(value: 'Personal Leave', child: Text('Personal Leave')),
                                DropdownMenuItem(value: 'Annual Vacation', child: Text('Annual Vacation')),
                              ],
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() {
                                    selectedLeaveType = val;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Start Date
                        const Text('Start Date', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _startDateCtrl,
                          decoration: InputDecoration(
                            fillColor: const Color(0xFFF1F5F9),
                            filled: true,
                            suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // End Date
                        const Text('End Date', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _endDateCtrl,
                          decoration: InputDecoration(
                            fillColor: const Color(0xFFF1F5F9),
                            filled: true,
                            suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Reason for Leave
                        const Text('Reason for Leave', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _reasonCtrl,
                          maxLines: 3,
                          decoration: InputDecoration(
                            fillColor: const Color(0xFFF1F5F9),
                            filled: true,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Supporting Documents (Dotted box)
                        const Text('Supporting Documents (Optional)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFCBD5E1), style: BorderStyle.solid),
                          ),
                          child: Column(
                            children: const [
                              Icon(Icons.cloud_upload_outlined, color: Color(0xFF0052CC), size: 28),
                              SizedBox(height: 8),
                              Text('Click to upload or drag and drop', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                              SizedBox(height: 2),
                              Text('PDF, JPG, or PNG (Max 5MB)', style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                            ],
                          ),
                        ),
                        const SizedBox(height: 22),

                        // Submit Button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () => context.push('/workspace/leave/status'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0052CC),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            child: const Text(
                              'Submit Request',
                              style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: OutlinedButton(
                            onPressed: () => context.canPop() ? context.pop() : context.go('/workspace'),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFF0052CC)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              foregroundColor: const Color(0xFF0052CC),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: Color(0xFF0052CC)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 2. Leave Balance Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7).withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'LEAVE BALANCE',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF166534), letterSpacing: 0.5),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: const [
                            Text(
                              '12',
                              style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900, color: Color(0xFF14532D)),
                            ),
                            SizedBox(width: 8),
                            Text('days available', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF166534))),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: const LinearProgressIndicator(
                            value: 12 / 20,
                            backgroundColor: Color(0xFFBBF7D0),
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF16A34A)),
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // 3. Info Alert Box
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Icon(Icons.info_outline, color: Color(0xFF0052CC), size: 20),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Medical leave requests exceeding 3 days require a valid doctor\'s certificate for automatic processing.',
                            style: TextStyle(fontSize: 12.5, color: Color(0xFF334155), height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

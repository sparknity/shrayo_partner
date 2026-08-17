import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Screen 15: Vitals & Measurements screen matching `15.png` pixel-for-pixel.
class BloodPressureDetailsScreen extends StatefulWidget {
  const BloodPressureDetailsScreen({super.key});

  @override
  State<BloodPressureDetailsScreen> createState() => _BloodPressureDetailsScreenState();
}

class _BloodPressureDetailsScreenState extends State<BloodPressureDetailsScreen> {
  final TextEditingController _bpCtrl = TextEditingController(text: '120/80');
  final TextEditingController _heartRateCtrl = TextEditingController(text: '72');
  final TextEditingController _bloodSugarCtrl = TextEditingController(text: '134');
  final TextEditingController _spo2Ctrl = TextEditingController(text: '98');
  final TextEditingController _tempCtrl = TextEditingController(text: '98.4');
  final TextEditingController _weightCtrl = TextEditingController(text: '141.5');
  final TextEditingController _notesCtrl = TextEditingController();

  @override
  void dispose() {
    _bpCtrl.dispose();
    _heartRateCtrl.dispose();
    _bloodSugarCtrl.dispose();
    _spo2Ctrl.dispose();
    _tempCtrl.dispose();
    _weightCtrl.dispose();
    _notesCtrl.dispose();
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
          'Vitals & Measurements',
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
                  // Page Header
                  const Text(
                    'Vitals & Measurements',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Please record the patient's current vitals. All measurements are automatically compared against established normal ranges.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF64748B),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 1. Blood Pressure Card (Active/Focus border)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFEF4444), width: 1.5),
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
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Color(0xFFFFE4E6),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.show_chart,
                                color: Color(0xFFE11D48),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Blood Pressure',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                  Text(
                                    'Normal: 120/80 mmHg',
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: Color(0xFF94A3B8),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFEF4444)),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _bpCtrl,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF0F172A),
                                  ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                                  ),
                                ),
                              ),
                              const Text(
                                'mmHg',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: const [
                            Icon(
                              Icons.error_outline,
                              color: Color(0xFFDC2626),
                              size: 14,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Blood Pressure Required',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFFDC2626),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 2. Heart Rate Card
                  _VitalMetricCard(
                    icon: Icons.favorite,
                    iconBg: const Color(0xFFDBEAFE),
                    iconColor: const Color(0xFF0052CC),
                    title: 'Heart Rate',
                    normalRange: 'Normal: 60-100 bpm',
                    statusDotColor: const Color(0xFF16A34A),
                    controller: _heartRateCtrl,
                    unit: 'bpm',
                    statusBadgeText: 'IN RANGE',
                    statusBadgeColor: const Color(0xFF15803D),
                  ),
                  const SizedBox(height: 12),

                  // 3. Blood Sugar Card
                  _VitalMetricCard(
                    icon: Icons.water_drop_outlined,
                    iconBg: const Color(0xFFF1F5F9),
                    iconColor: const Color(0xFF64748B),
                    title: 'Blood Sugar',
                    normalRange: 'Normal: 70-130 mg/dL',
                    statusDotColor: const Color(0xFFEA580C),
                    controller: _bloodSugarCtrl,
                    unit: 'mg/dL',
                    statusBadgeText: 'ELEVATED',
                    statusBadgeColor: const Color(0xFFC2410C),
                  ),
                  const SizedBox(height: 12),

                  // 4. SpO2 Card
                  _VitalMetricCard(
                    icon: Icons.air,
                    iconBg: const Color(0xFFDBEAFE),
                    iconColor: const Color(0xFF0052CC),
                    title: 'SpO2',
                    normalRange: 'Normal: 95-100%',
                    statusDotColor: const Color(0xFF16A34A),
                    controller: _spo2Ctrl,
                    unit: '%',
                    statusBadgeText: 'OPTIMAL',
                    statusBadgeColor: const Color(0xFF15803D),
                  ),
                  const SizedBox(height: 12),

                  // 5. Temperature Card
                  _VitalMetricCard(
                    icon: Icons.thermostat,
                    iconBg: const Color(0xFFF1F5F9),
                    iconColor: const Color(0xFF64748B),
                    title: 'Temperature',
                    normalRange: 'Normal: 97.8-99.1 °F',
                    statusDotColor: const Color(0xFF16A34A),
                    controller: _tempCtrl,
                    unit: '°F',
                    statusBadgeText: 'NORMAL',
                    statusBadgeColor: const Color(0xFF15803D),
                  ),
                  const SizedBox(height: 12),

                  // 6. Weight Card
                  _VitalMetricCard(
                    icon: Icons.monitor_weight_outlined,
                    iconBg: const Color(0xFFDCFCE7),
                    iconColor: const Color(0xFF16A34A),
                    title: 'Weight',
                    normalRange: 'Baseline: 142 lbs',
                    statusDotColor: const Color(0xFF94A3B8),
                    controller: _weightCtrl,
                    unit: 'lbs',
                    statusBadgeText: '-0.5 LBS FROM BASELINE',
                    statusBadgeColor: const Color(0xFF334155),
                  ),
                  const SizedBox(height: 14),

                  // Observation Notes Box
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Observation Notes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: TextField(
                            controller: _notesCtrl,
                            maxLines: 3,
                            style: const TextStyle(fontSize: 14, color: Color(0xFF0F172A)),
                            decoration: const InputDecoration(
                              hintText:
                                  "Record any qualitative observations or concerns about the patient's condition...",
                              hintStyle:
                                  TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Continue to Completion Button
                  Material(
                    color: const Color(0xFF0052CC),
                    borderRadius: BorderRadius.circular(14),
                    child: InkWell(
                      onTap: () => context.push('/visits/submit'),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        width: double.infinity,
                        height: 52,
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'Continue to Completion',
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
                  const SizedBox(height: 12),

                  // Saved Checkmark footer
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'Saved',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF15803D),
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.check_circle_outline,
                          size: 16,
                          color: Color(0xFF15803D),
                        ),
                      ],
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

class _VitalMetricCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String normalRange;
  final Color statusDotColor;
  final TextEditingController controller;
  final String unit;
  final String statusBadgeText;
  final Color statusBadgeColor;

  const _VitalMetricCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.normalRange,
    required this.statusDotColor,
    required this.controller,
    required this.unit,
    required this.statusBadgeText,
    required this.statusBadgeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      normalRange,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: statusDotColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                Text(
                  unit,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            statusBadgeText,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: statusBadgeColor,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

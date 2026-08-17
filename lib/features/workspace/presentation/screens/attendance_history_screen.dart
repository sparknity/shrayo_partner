import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/fixtures/workspace_fixtures.dart';

/// Attendance History screen matching `Attendance History.png` (`/workspace/attendance/history`).
class AttendanceHistoryScreen extends StatefulWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  State<AttendanceHistoryScreen> createState() => _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  int selectedDay = 23;

  @override
  Widget build(BuildContext context) {
    final summary = WorkspaceFixtures.attendanceHistorySummary;
    final dailyRecords = WorkspaceFixtures.attendanceDailyRecords;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
          onPressed: () => context.canPop() ? context.pop() : context.go('/workspace/attendance'),
        ),
        title: const Text(
          'Attendance History',
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
                  // 1. Days Worked Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Days Worked',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '${summary['daysWorked'] ?? 22}',
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0052CC),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '/ ${summary['totalWorkingDays'] ?? 26} days',
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: ((summary['daysWorked'] as num?) ?? 22) /
                                ((summary['totalWorkingDays'] as num?) ?? 26),
                            backgroundColor: const Color(0xFFE2E8F0),
                            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0052CC)),
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 2. Late Arrivals Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Late Arrivals',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEE2E2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.access_time,
                                color: Color(0xFFDC2626),
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '0${summary['lateArrivalsCount'] ?? 3}',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFFDC2626),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Average delay: ${summary['averageDelayMins'] ?? 12} mins',
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // 3. Calendar Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'October 2023',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  visualDensity: VisualDensity.compact,
                                  icon: const Icon(Icons.chevron_left, size: 20, color: Color(0xFF64748B)),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  visualDensity: VisualDensity.compact,
                                  icon: const Icon(Icons.chevron_right, size: 20, color: Color(0xFF64748B)),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Days Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: const [
                            _CalHeader('S'),
                            _CalHeader('M'),
                            _CalHeader('T'),
                            _CalHeader('W'),
                            _CalHeader('T'),
                            _CalHeader('F'),
                            _CalHeader('S'),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Calendar Grid Days
                        _calRow([
                          _dayItem('24', status: _DayStatus.prevMonth),
                          _dayItem('25', status: _DayStatus.prevMonth),
                          _dayItem('26', status: _DayStatus.prevMonth),
                          _dayItem('27', status: _DayStatus.prevMonth),
                          _dayItem('28', status: _DayStatus.prevMonth),
                          _dayItem('29', status: _DayStatus.prevMonth),
                          _dayItem('30', status: _DayStatus.prevMonth),
                        ]),
                        const SizedBox(height: 8),
                        _calRow([
                          _dayItem('1', status: _DayStatus.present),
                          _dayItem('2', status: _DayStatus.present),
                          _dayItem('3', status: _DayStatus.present),
                          _dayItem('4', status: _DayStatus.present),
                          _dayItem('5', status: _DayStatus.present),
                          _dayItem('6', status: _DayStatus.late),
                          _dayItem('7', status: _DayStatus.offDay),
                        ]),
                        const SizedBox(height: 8),
                        _calRow([
                          _dayItem('8', status: _DayStatus.present),
                          _dayItem('9', status: _DayStatus.present),
                          _dayItem('10', status: _DayStatus.present),
                          _dayItem('11', status: _DayStatus.present),
                          _dayItem('12', status: _DayStatus.present),
                          _dayItem('13', status: _DayStatus.present),
                          _dayItem('14', status: _DayStatus.offDay),
                        ]),
                        const SizedBox(height: 8),
                        _calRow([
                          _dayItem('15', status: _DayStatus.present),
                          _dayItem('16', status: _DayStatus.present),
                          _dayItem('17', status: _DayStatus.late),
                          _dayItem('18', status: _DayStatus.present),
                          _dayItem('19', status: _DayStatus.present),
                          _dayItem('20', status: _DayStatus.present),
                          _dayItem('21', status: _DayStatus.offDay),
                        ]),
                        const SizedBox(height: 8),
                        _calRow([
                          _dayItem('22', status: _DayStatus.present),
                          _dayItem('23', status: _DayStatus.selectedLate),
                          _dayItem('24', status: _DayStatus.plain),
                          _dayItem('25', status: _DayStatus.plain),
                          _dayItem('26', status: _DayStatus.plain),
                          _dayItem('27', status: _DayStatus.plain),
                          _dayItem('28', status: _DayStatus.plain),
                        ]),
                        const SizedBox(height: 18),
                        // Legend
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _legendItem(const Color(0xFF16A34A), 'Present'),
                            const SizedBox(width: 16),
                            _legendItem(const Color(0xFFDC2626), 'Late'),
                            const SizedBox(width: 16),
                            _legendItem(const Color(0xFFE2E8F0), 'Off Day'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 4. Daily Records Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Daily Records',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        'Sorted by: Newest First',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Daily Records List
                  ...dailyRecords.map((rec) => Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(18),
                          child: InkWell(
                            onTap: () => context.push('/workspace/attendance/history/${rec['id']}'),
                            borderRadius: BorderRadius.circular(18),
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Row(
                                children: [
                                  // Date Pill Container
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEFF6FF),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          rec['month'] ?? 'OCT',
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w800,
                                            color: Color(0xFF0052CC),
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        Text(
                                          rec['dayNumber'] ?? '23',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                            color: Color(0xFF0F172A),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          rec['title'] ?? '',
                                          style: const TextStyle(
                                            fontSize: 14.5,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF0F172A),
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          rec['timeRange'] ?? '',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: rec['isLate'] == true
                                                ? FontWeight.w600
                                                : FontWeight.w400,
                                            color: rec['isLate'] == true
                                                ? const Color(0xFFDC2626)
                                                : const Color(0xFF64748B),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: rec['isLate'] == true
                                          ? const Color(0xFFFEE2E2)
                                          : const Color(0xFFDCFCE7),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      rec['status'] ?? '',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: rec['isLate'] == true
                                            ? const Color(0xFFDC2626)
                                            : const Color(0xFF16A34A),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Icon(
                                    Icons.chevron_right,
                                    color: Color(0xFF94A3B8),
                                    size: 18,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )),
                  const SizedBox(height: 16),

                  // 5. Load More History
                  Center(
                    child: TextButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('All attendance records loaded.')),
                        );
                      },
                      icon: const Text(
                        'Load More History',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0052CC),
                        ),
                      ),
                      label: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Color(0xFF0052CC),
                        size: 18,
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

  Widget _calRow(List<Widget> children) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: children,
    );
  }

  Widget _dayItem(String day, {required _DayStatus status}) {
    Color bgColor = Colors.transparent;
    Color textColor = const Color(0xFF0F172A);
    Border? border;

    switch (status) {
      case _DayStatus.prevMonth:
        textColor = const Color(0xFFCBD5E1);
        break;
      case _DayStatus.present:
        bgColor = const Color(0xFF86EFAC);
        textColor = const Color(0xFF14532D);
        break;
      case _DayStatus.late:
        bgColor = const Color(0xFFFECDD3);
        textColor = const Color(0xFF881337);
        break;
      case _DayStatus.offDay:
        bgColor = const Color(0xFFE2E8F0);
        textColor = const Color(0xFF475569);
        break;
      case _DayStatus.selectedLate:
        bgColor = const Color(0xFFFECDD3);
        textColor = const Color(0xFF881337);
        border = Border.all(color: const Color(0xFF0052CC), width: 2);
        break;
      case _DayStatus.plain:
        textColor = const Color(0xFF334155);
        break;
    }

    return GestureDetector(
      onTap: () {
        final parsed = int.tryParse(day);
        if (parsed != null && status != _DayStatus.prevMonth) {
          setState(() {
            selectedDay = parsed;
          });
        }
      },
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
          border: border,
        ),
        alignment: Alignment.center,
        child: Text(
          day,
          style: TextStyle(
            fontSize: 12,
            fontWeight: status == _DayStatus.plain || status == _DayStatus.prevMonth
                ? FontWeight.w500
                : FontWeight.w700,
            color: textColor,
          ),
        ),
      ),
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w500,
            color: Color(0xFF64748B),
          ),
        ),
      ],
    );
  }
}

enum _DayStatus {
  prevMonth,
  present,
  late,
  offDay,
  selectedLate,
  plain,
}

class _CalHeader extends StatelessWidget {
  final String title;
  const _CalHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF64748B),
          ),
        ),
      ),
    );
  }
}

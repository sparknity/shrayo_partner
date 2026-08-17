import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Settings Details screen matching `Settings Details.png` (`/workspace/settings/details`).
class SettingsDetailsScreen extends StatefulWidget {
  const SettingsDetailsScreen({super.key});

  @override
  State<SettingsDetailsScreen> createState() => _SettingsDetailsScreenState();
}

class _SettingsDetailsScreenState extends State<SettingsDetailsScreen> {
  bool biometricEnabled = true;

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
          onPressed: () => context.canPop() ? context.pop() : context.go('/workspace/settings'),
        ),
        title: const Text(
          'Settings Details',
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
                  // 1. ACCOUNT & SECURITY
                  const Text(
                    'ACCOUNT & SECURITY',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF64748B),
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      children: [
                        _tile(
                          icon: Icons.lock_reset,
                          iconBg: const Color(0xFFEFF6FF),
                          iconColor: const Color(0xFF0052CC),
                          title: 'Change Password',
                          hasChevron: true,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Change Password dialog.')),
                            );
                          },
                        ),
                        const Divider(color: Color(0xFFF1F5F9), height: 1, indent: 64),
                        _tile(
                          icon: Icons.fingerprint,
                          iconBg: const Color(0xFFDCFCE7),
                          iconColor: const Color(0xFF16A34A),
                          title: 'Biometric Login',
                          subtitle: 'Use FaceID or Fingerprint',
                          customTrailing: Switch.adaptive(
                            value: biometricEnabled,
                            activeTrackColor: const Color(0xFF16A34A),
                            onChanged: (val) {
                              setState(() {
                                biometricEnabled = val;
                              });
                            },
                          ),
                        ),
                        const Divider(color: Color(0xFFF1F5F9), height: 1, indent: 64),
                        _tile(
                          icon: Icons.shield_outlined,
                          iconBg: const Color(0xFFF1F5F9),
                          iconColor: const Color(0xFF475569),
                          title: 'Security',
                          trailingText: 'Active',
                          trailingTextColor: const Color(0xFF16A34A),
                          hasChevron: true,
                          onTap: () => context.push('/workspace/settings/privacy-security'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 2. PREFERENCES
                  const Text(
                    'PREFERENCES',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF64748B),
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      children: [
                        _tile(
                          icon: Icons.notifications_outlined,
                          iconBg: const Color(0xFFFEF2F2),
                          iconColor: const Color(0xFFDC2626),
                          title: 'Notification Preferences',
                          hasChevron: true,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Notification preferences opened.')),
                            );
                          },
                        ),
                        const Divider(color: Color(0xFFF1F5F9), height: 1, indent: 64),
                        _tile(
                          icon: Icons.language,
                          iconBg: const Color(0xFFEFF6FF),
                          iconColor: const Color(0xFF0052CC),
                          title: 'Language Selection',
                          trailingText: 'English\n(US)',
                          hasChevron: true,
                          onTap: () {},
                        ),
                        const Divider(color: Color(0xFFF1F5F9), height: 1, indent: 64),
                        _tile(
                          icon: Icons.dark_mode_outlined,
                          iconBg: const Color(0xFFF1F5F9),
                          iconColor: const Color(0xFF334155),
                          title: 'Theme',
                          trailingText: 'Light',
                          hasChevron: true,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 3. INFORMATION
                  const Text(
                    'INFORMATION',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF64748B),
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: _tile(
                      icon: Icons.shield_outlined,
                      iconBg: const Color(0xFFF1F5F9),
                      iconColor: const Color(0xFF475569),
                      title: 'Privacy Policy',
                      customTrailing: const Icon(Icons.open_in_new, size: 18, color: Color(0xFF64748B)),
                      onTap: () => context.push('/workspace/settings/privacy-security'),
                    ),
                  ),
                  const SizedBox(height: 36),

                  // 4. Footer
                  Center(
                    child: Column(
                      children: const [
                        Text(
                          'Caregiver Workspace',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Version 2.4.1 (Build 8842)',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'CLINICAL-GRADE ENCRYPTION',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF94A3B8),
                            letterSpacing: 1.0,
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

  Widget _tile({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    String? subtitle,
    String? trailingText,
    Color? trailingTextColor,
    bool hasChevron = false,
    Widget? customTrailing,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (customTrailing != null)
                customTrailing
              else ...[
                if (trailingText != null)
                  Text(
                    trailingText,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: trailingTextColor ?? const Color(0xFF64748B),
                    ),
                    textAlign: TextAlign.right,
                  ),
                if (hasChevron) ...[
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.chevron_right,
                    color: Color(0xFF94A3B8),
                    size: 18,
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}

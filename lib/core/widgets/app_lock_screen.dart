import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Security lock screen UI for PIN entry & biometric re-authentication (Section 5.2).
class AppLockScreen extends StatefulWidget {
  const AppLockScreen({
    super.key,
    required this.onPinSubmitted,
    this.title = 'Enter Security PIN',
    this.subtitle = 'Verify identity to access caregiver workspace',
    this.pinLength = 4,
    this.errorMessage,
    this.onBiometricPressed,
    this.isBiometricAvailable = true,
  });

  final ValueChanged<String> onPinSubmitted;
  final String title;
  final String subtitle;
  final int pinLength;
  final String? errorMessage;
  final VoidCallback? onBiometricPressed;
  final bool isBiometricAvailable;

  @override
  State<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends State<AppLockScreen> {
  String _enteredPin = '';

  void _onKeyPress(String digit) {
    if (_enteredPin.length < widget.pinLength) {
      setState(() {
        _enteredPin += digit;
      });
      if (_enteredPin.length == widget.pinLength) {
        widget.onPinSubmitted(_enteredPin);
      }
    }
  }

  void _onBackspace() {
    if (_enteredPin.isNotEmpty) {
      setState(() {
        _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(AppSpacing.m),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlueLight.withAlpha(40),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.lock_outline, size: 36, color: AppColors.primaryBlue),
              ),
              const SizedBox(height: AppSpacing.l),
              Text(
                widget.title,
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.s),
              Text(
                widget.subtitle,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.pinLength, (index) {
                  final isFilled = index < _enteredPin.length;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: AppSpacing.s),
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: isFilled ? AppColors.primaryBlue : AppColors.surfaceCard,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isFilled ? AppColors.primaryBlue : AppColors.borderDivider,
                      ),
                    ),
                  );
                }),
              ),
              if (widget.errorMessage != null) ...[
                const SizedBox(height: AppSpacing.m),
                Text(
                  widget.errorMessage!,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.emergencyRed,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              const Spacer(),
              _buildKeypad(),
              const SizedBox(height: AppSpacing.l),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKeypad() {
    return Column(
      children: [
        for (var row in [
          ['1', '2', '3'],
          ['4', '5', '6'],
          ['7', '8', '9'],
        ])
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.m),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: row.map((digit) => _buildKeyButton(digit)).toList(),
            ),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (widget.isBiometricAvailable && widget.onBiometricPressed != null)
              IconButton(
                iconSize: 32,
                icon: const Icon(Icons.fingerprint, color: AppColors.primaryBlue),
                onPressed: widget.onBiometricPressed,
              )
            else
              const SizedBox(width: 64, height: 64),
            _buildKeyButton('0'),
            IconButton(
              iconSize: 28,
              icon: const Icon(Icons.backspace_outlined, color: AppColors.textSecondary),
              onPressed: _onBackspace,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKeyButton(String digit) {
    return InkWell(
      onTap: () => _onKeyPress(digit),
      borderRadius: BorderRadius.circular(32),
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: AppColors.surfaceBackground,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.borderDivider.withAlpha(100)),
        ),
        child: Center(
          child: Text(
            digit,
            style: AppTextStyles.headlineMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Form input field specifically tailored for recording vital signs (e.g. Systolic/Diastolic BP or numeric value + unit).
class VitalInputField extends StatelessWidget {
  const VitalInputField({
    super.key,
    required this.label,
    required this.unit,
    this.controller,
    this.secondaryController,
    this.isDualInput = false,
    this.secondaryLabel,
    this.hint = '0',
    this.secondaryHint = '0',
    this.onChanged,
    this.validator,
    this.helperText,
  });

  final String label;
  final String unit;
  final TextEditingController? controller;
  final TextEditingController? secondaryController;
  final bool isDualInput;
  final String? secondaryLabel;
  final String hint;
  final String secondaryHint;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final String? helperText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppSpacing.xs),
        if (!isDualInput)
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                  onChanged: onChanged,
                  validator: validator,
                  style: AppTextStyles.titleMedium,
                  decoration: InputDecoration(
                    hintText: hint,
                    contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: AppSpacing.m),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusCard / 2),
                      borderSide: const BorderSide(color: AppColors.borderDivider),
                    ),
                    suffixIcon: Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: AppSpacing.m),
                      child: Text(
                        unit,
                        style: AppTextStyles.labelMedium.copyWith(color: AppColors.textSecondary),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        else
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: onChanged,
                  validator: validator,
                  style: AppTextStyles.titleMedium,
                  decoration: InputDecoration(
                    hintText: hint,
                    labelText: secondaryLabel ?? 'Systolic',
                    contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: AppSpacing.m),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusCard / 2),
                      borderSide: const BorderSide(color: AppColors.borderDivider),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.s),
                child: Text('/', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
              ),
              Expanded(
                child: TextFormField(
                  controller: secondaryController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: onChanged,
                  validator: validator,
                  style: AppTextStyles.titleMedium,
                  decoration: InputDecoration(
                    hintText: secondaryHint,
                    labelText: 'Diastolic',
                    contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: AppSpacing.m),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusCard / 2),
                      borderSide: const BorderSide(color: AppColors.borderDivider),
                    ),
                    suffixText: unit,
                  ),
                ),
              ),
            ],
          ),
        if (helperText != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(helperText!, style: AppTextStyles.caption),
        ],
      ],
    );
  }
}

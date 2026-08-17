import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Search field widget for Patient Directory with built-in search-as-you-type debouncing.
class PatientDirectorySearchField extends StatefulWidget {
  const PatientDirectorySearchField({
    super.key,
    required this.onSearchChanged,
    this.hint = 'Search patients by name or ID...',
    this.controller,
    this.debounceDuration = const Duration(milliseconds: 300),
    this.onClear,
  });

  final ValueChanged<String> onSearchChanged;
  final String hint;
  final TextEditingController? controller;
  final Duration debounceDuration;
  final VoidCallback? onClear;

  @override
  State<PatientDirectorySearchField> createState() =>
      _PatientDirectorySearchFieldState();
}

class _PatientDirectorySearchFieldState
    extends State<PatientDirectorySearchField> {
  late final TextEditingController _effectiveController;
  bool _hasText = false;
  static const String _debounceTag = 'patient_search_debounce';

  @override
  void initState() {
    super.initState();
    _effectiveController = widget.controller ?? TextEditingController();
    _hasText = _effectiveController.text.isNotEmpty;
    _effectiveController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final text = _effectiveController.text;
    if (_hasText != text.isNotEmpty) {
      setState(() {
        _hasText = text.isNotEmpty;
      });
    }

    EasyDebounce.debounce(
      _debounceTag,
      widget.debounceDuration,
      () => widget.onSearchChanged(text),
    );
  }

  @override
  void dispose() {
    EasyDebounce.cancel(_debounceTag);
    if (widget.controller == null) {
      _effectiveController.dispose();
    } else {
      _effectiveController.removeListener(_onTextChanged);
    }
    super.dispose();
  }

  void _clearSearch() {
    _effectiveController.clear();
    widget.onClear?.call();
    widget.onSearchChanged('');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceBackground,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard / 2),
        border: Border.all(color: AppColors.borderDivider),
      ),
      child: TextField(
        controller: _effectiveController,
        style: AppTextStyles.bodyMedium,
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary.withAlpha(150),
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.primaryBlue,
            size: 22,
          ),
          suffixIcon: _hasText
              ? IconButton(
                  icon: const Icon(Icons.clear, color: AppColors.textSecondary, size: 20),
                  onPressed: _clearSearch,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.m,
            vertical: AppSpacing.s + 4,
          ),
        ),
      ),
    );
  }
}
